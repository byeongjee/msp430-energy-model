include("../src/types.jl")
include("../src/machine_state.jl")
include("../src/parser.jl")
include("../src/Interpreter.jl")
include("../src/model.jl")
include("../src/models/gamma_per_instruction.jl")
include("../src/models/gamma_per_addressing_mode.jl")
include("../src/models/mean_per_instruction.jl")
include("../src/models/mean_per_addressing_mode.jl")
include("../src/Estimation.jl")

using .Interpreter
using .Estimation
using ArgParse
using CSV
using DataFrames
using JSON

"""
Create a model instance based on the model name
"""
function create_model(model_str::String)::Model
    if model_str == "gamma_per_instruction"
        return GammaPerInstruction()
    elseif model_str == "gamma_per_addressing_mode"
        return GammaPerAddressingMode()
    elseif model_str == "mean_per_instruction"
        return MeanPerInstruction()
    elseif model_str == "mean_per_addressing_mode"
        return MeanPerAddressingMode()
    else
        error("Unknown model type: $model_str. Must be one of: gamma_per_instruction, gamma_per_addressing_mode, mean_per_instruction, mean_per_addressing_mode")
    end
end

"""
Create model configuration based on model type
"""
function create_model_config(model::Model, n_samples::Int, inference_algorithm::String)::ModelConfig
    if isa(model, GammaModel)
        return GammaConfig(n_samples=n_samples, inference_algorithm=inference_algorithm)
    elseif isa(model, MeanModel)
        return MeanConfig()
    else
        error("Unknown model type: $(typeof(model))")
    end
end

"""
Parse command line arguments
"""
function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "mode"
        help = "Mode: interpret, train, or estimate"
        required = true
        arg_type = String
        "--asm"
        help = "Path(s) to assembly file(s) (space-separated for multiple files)"
        required = false
        arg_type = String
        nargs = '+'
        "--data"
        help = "Path(s) to energy measurement data (space-separated, required for train mode)"
        arg_type = String
        nargs = '+'
        "--params"
        help = "Path to energy parameter file (required for estimate mode)"
        arg_type = String
        "--output"
        help = "Output file path (for train/estimate mode)"
        arg_type = String
        "--max-steps"
        help = "Maximum number of execution steps"
        arg_type = Int
        default = 100000000
        "--n-samples"
        help = "Number of samples for importance sampling inference (train mode)"
        arg_type = Int
        default = 100
        "--model"
        help = "Model type: gamma_per_instruction, gamma_per_addressing_mode, mean_per_instruction, mean_per_addressing_mode"
        arg_type = String
        default = "gamma_per_instruction"
        "--inference"
        help = "Inference algorithm: importance-sampling, or mcmc-blocked (default: importance-sampling, only for Gamma models)"
        arg_type = String
        default = "importance-sampling"
    end

    return parse_args(s)
end

"""
Interpret mode: Run interpreter on assembly file
"""
function run_interpret(asm_file::String, max_steps::Int)
    @info "Running in INTERPRET mode"
    @info "Assembly file" path = asm_file

    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)

    func_addrs = find_functions(asm_file)

    # Execute program
    final_state, event_sequences = Interpreter.interpret_program(
        instructions, addresses, func_addrs, max_steps
    )

    @info "="^60
    @info "EXECUTION SUMMARY"
    @info "="^60
    @info "Successfully executed MSP430 instructions" count = length(instructions)
    @info "Number of events" count = length(event_sequences)

    # Print number of instructions in each event
    for (i, event) in enumerate(event_sequences)
        @info "Event $i" instructions = length(event)
    end

    return final_state
end

"""
Process a single assembly file and its corresponding measurement data
Returns event sequences and energy measurements
"""
function process_training_file(
    asm_file::String, data_file::String, max_steps::Int
)::Tuple{Vector{Vector{Instruction}},Vector{Float64}}
    @info "Processing training file" asm = asm_file data = data_file

    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)

    func_addrs = find_functions(asm_file)
    begin_event_addr = get(func_addrs, "begin_event", nothing)
    end_event_addr = get(func_addrs, "end_event", nothing)

    if isnothing(begin_event_addr) || isnothing(end_event_addr)
        @info "begin_event or end_event not found in assembly file"
    else
        @info "begin_event and end_event found in assembly file" begin_event_addr =
            "0x" * string(begin_event_addr; base=16, pad=4) end_event_addr =
            "0x" * string(end_event_addr; base=16, pad=4)
    end

    _, event_sequences = Interpreter.interpret_program(
        instructions, addresses, func_addrs, max_steps
    )

    @info "Reading measurement data from CSV"
    df = CSV.read(data_file, DataFrame)

    energies = df.energy_nJ

    if length(event_sequences) != length(energies)
        error(
            "Mismatch between event sequences ($(length(event_sequences))) and energy measurements ($(length(energies))) for file: $asm_file",
        )
    end

    @info "File processed successfully" num_events = length(event_sequences)

    return event_sequences, energies
end

"""
Train mode: Infer energy parameters from assembly and measurement data
Supports single or multiple files for training
"""
function run_train(
    asm_files::Vector{String},
    data_files::Vector{String},
    output_file::Union{String,Nothing},
    max_steps::Int,
    n_samples::Int,
    model_str::String,
    inference_str::String,
)::Nothing
    @info "Running in TRAIN mode"
    @info "Number of training files" n_files = length(asm_files)

    # Validate that number of asm files matches number of data files
    if length(asm_files) != length(data_files)
        error(
            "Number of assembly files ($(length(asm_files))) must match number of data files ($(length(data_files)))",
        )
    end

    # Create model
    model = create_model(model_str)
    @info "Model type" model = model_str

    if !isnothing(output_file)
        @info "Output file" path = output_file
    end

    # Process each file and collect event sequences and energies
    all_event_sequences = Vector{Vector{Instruction}}()
    all_energies = Vector{Float64}()

    for (asm_file, data_file) in zip(asm_files, data_files)
        event_sequences, energies = process_training_file(asm_file, data_file, max_steps)
        append!(all_event_sequences, event_sequences)
        append!(all_energies, energies)
    end

    @info "Creating combined training data" total_samples = length(all_energies)
    training_data = TrainingData(all_event_sequences, all_energies)

    @info "Training data created successfully"

    # Create model config and learn parameters
    config = create_model_config(model, n_samples, inference_str)
    learn_params!(model, training_data, config)

    # Export parameters to file if output path is provided
    if !isnothing(output_file)
        save_params(model, output_file)
    else
        @info "No output file specified, skipping save"
    end

    return nothing
end


"""
Main function
"""
function main()
    args = parse_commandline()

    mode = lowercase(args["mode"])
    max_steps = args["max-steps"]

    try
        if mode == "interpret"
            asm_files = args["asm"]
            if isnothing(asm_files) || isempty(asm_files)
                error("--asm is required for interpret mode")
            end
            if length(asm_files) > 1
                error("interpret mode only supports a single assembly file")
            end
            run_interpret(asm_files[1], max_steps)

        elseif mode == "train"
            asm_files = args["asm"]
            if isnothing(asm_files) || isempty(asm_files)
                error("--asm is required for train mode")
            end
            data_files = args["data"]
            if isnothing(data_files) || isempty(data_files)
                error("--data is required for train mode")
            end
            output_file = args["output"]
            n_samples = args["n-samples"]
            model_str = args["model"]
            inference = args["inference"]
            run_train(
                asm_files,
                data_files,
                output_file,
                max_steps,
                n_samples,
                model_str,
                inference,
            )

        elseif mode == "estimate"
            asm_files = args["asm"]
            if isnothing(asm_files) || isempty(asm_files)
                error("--asm is required for estimate mode")
            end
            if length(asm_files) > 1
                error("estimate mode only supports a single assembly file")
            end
            params_file = args["params"]
            if isnothing(params_file)
                error("--params is required for estimate mode")
            end
            output_file = args["output"]
            n_samples = args["n-samples"]
            Estimation.run_estimate(asm_files[1], params_file, max_steps, n_samples, output_file)

        else
            error("Invalid mode: $mode. Must be one of: interpret, train, estimate")
        end

    catch e
        @error "Execution failed" error = e
        exit(1)
    end

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
