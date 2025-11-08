include("../src/types.jl")
include("../src/machine_state.jl")
include("../src/parser.jl")
include("../src/Interpreter.jl")
include("../src/Inference.jl")
include("../src/Estimation.jl")
using .Interpreter
using .Inference
using .Estimation
using ArgParse
using CSV
using DataFrames
using JSON

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
        "--granularity"
        help = "Model granularity: opcode or addressing_mode (default: opcode)"
        arg_type = String
        default = "opcode"
        "--inference"
        help = "Inference algorithm: importance-sampling, or mcmc-blocked (default: importance-sampling)"
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
    granularity_str::String,
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

    # Parse granularity
    granularity = if granularity_str == "opcode"
        Inference.PerOpcode
    elseif granularity_str == "addressing_mode"
        Inference.PerAddressingMode
    else
        error("Invalid granularity: $granularity_str. Must be 'opcode' or 'addressing_mode'")
    end
    @info "Model granularity" granularity

    # Validate inference algorithm
    valid_inference_algorithms = ["importance-sampling", "mcmc-blocked"]
    if !(inference_str in valid_inference_algorithms)
        error(
            "Invalid inference algorithm: $inference_str. Must be one of: " *
            join(valid_inference_algorithms, ", "),
        )
    end
    @info "Inference algorithm" algorithm = inference_str

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

    @info "Learning energy parameters from training data" n_samples
    learned_params = Inference.learn_parameters(
        training_data, granularity, inference_str; n_samples=n_samples
    )

    @info "Parameter learning complete" num_parameters = length(learned_params)

    # Convert tuple keys to string keys for JSON serialization
    params_dict = Dict{String,Dict{String,Float64}}()
    for (param_key, (alpha, beta)) in learned_params
        # Convert tuple of symbols to string: (:mov, :immediate, :register) -> "mov_immediate_register"
        key_str = join(string.(param_key), "_")
        params_dict[key_str] = Dict("alpha" => alpha, "beta" => beta)
    end

    # Create output with metadata
    output_dict = Dict{String,Any}(
        "granularity" => string(granularity),  # Save granularity for loading
        "parameters" => params_dict,
    )

    # Export parameters to file if output path is provided
    if !isnothing(output_file)
        @info "Exporting parameters to file" path = output_file
        open(output_file, "w") do f
            JSON.print(f, output_dict, 4)  # 4 spaces for indentation
        end
        @info "Parameters exported successfully"
    else
        @info "No output file specified, printing parameters to console"
        println(JSON.json(output_dict, 4))
    end

    return nothing
end

"""
Estimate mode: Predict energy consumption using learned parameters
"""
function run_estimate(
    asm_file::String,
    params_file::String,
    max_steps::Int,
    output_file::Union{String,Nothing}=nothing,
)::Nothing
    @info "Running in ESTIMATE mode"
    @info "Assembly file" path = asm_file
    @info "Energy parameters" path = params_file

    if !isnothing(output_file)
        @info "Statistics output file" path = output_file
    end

    params, granularity = load_energy_params(params_file)

    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)

    func_addrs = find_functions(asm_file)

    @info "Executing program to get event sequences"
    start_time = time()
    _, event_sequences = Interpreter.interpret_program(
        instructions, addresses, func_addrs, max_steps
    )
    inference_time = time() - start_time

    # Track all parameter keys and unknown parameter keys across all event sequences
    all_param_keys = Set{Tuple{Vararg{Symbol}}}()
    all_unknown_param_keys = Set{Tuple{Vararg{Symbol}}}()
    all_stats = NamedTuple{
        (:mean, :std, :min, :max, :samples),
        Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
    }[]

    for event_sequence in event_sequences
        @info "Event sequence" length = length(event_sequence)

        # Check for unknown parameter keys in this sequence
        for inst in event_sequence
            param_key = Inference.get_instruction_key(inst, granularity)
            push!(all_param_keys, param_key)
            if !haskey(params, param_key)
                push!(all_unknown_param_keys, param_key)
            end
        end

        stats = estimate_cost_distribution(event_sequence, params, granularity)
        push!(all_stats, stats)
    end

    @info "="^60
    @info "ESTIMATION COMPLETE"
    @info "="^60
    @info "Inference time" time_seconds = round(inference_time; digits=3)

    # Show all parameter keys used
    param_key_strs = [join(string.(k), "_") for k in all_param_keys]
    @info "Parameter keys used" count = length(all_param_keys) keys = join(
        sort(param_key_strs), ", "
    )

    # Emit warning for unknown parameter keys if any were found
    if !isempty(all_unknown_param_keys)
        unknown_key_strs = [join(string.(k), "_") for k in all_unknown_param_keys]
        @warn "Unknown parameter keys encountered (not in energy parameters file)" count = length(
            all_unknown_param_keys
        ) keys = join(sort(unknown_key_strs), ", ") default_params = "Using Gamma(alpha=1.0, beta=3.0) for these parameter keys"
    end

    # Save stats to JSON if requested
    if !isnothing(output_file) && !isempty(all_stats)
        @info "Saving estimation statistics" path = output_file num_events = length(
            all_stats
        )
        # Save all event sequences' stats as an array
        events_array = []
        for stats in all_stats
            push!(
                events_array,
                Dict(
                    "mean" => stats.mean,
                    "std" => stats.std,
                    "min" => stats.min,
                    "max" => stats.max,
                    "samples" => stats.samples,
                ),
            )
        end
        stats_dict = Dict("events" => events_array)
        open(output_file, "w") do f
            JSON.print(f, stats_dict, 4)
        end
        @info "Statistics saved successfully"
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
            granularity = args["granularity"]
            inference = args["inference"]
            run_train(
                asm_files,
                data_files,
                output_file,
                max_steps,
                n_samples,
                granularity,
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
            run_estimate(asm_files[1], params_file, max_steps, output_file)

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
