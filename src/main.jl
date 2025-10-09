include("../src/EnergyModel.jl")
include("../src/Interpreter.jl")
include("../src/Inference.jl")
include("../src/Estimation.jl")
include("../src/Visualization.jl")
using .EnergyModel
using .Interpreter
using .Inference
using .Estimation
using .Visualization
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
        help = "Path to assembly file"
        required = true
        arg_type = String
        "--data"
        help = "Path to energy measurement data (required for train mode)"
        arg_type = String
        "--params"
        help = "Path to energy parameter file (required for estimate mode)"
        arg_type = String
        "--output"
        help = "Output file path (for train mode)"
        arg_type = String
        "--plot"
        help = "Plot output file path (for estimate mode)"
        arg_type = String
        "--max-steps"
        help = "Maximum number of execution steps"
        arg_type = Int
        default = 100000000
    end

    return parse_args(s)
end

"""
Interpret mode: Run interpreter on assembly file
"""
function run_interpret(asm_file::String, max_steps::Int)
    @info "Running in INTERPRET mode"
    @info "Assembly file" path = asm_file

    # Parse instructions from assembly file
    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)

    # Parse event addresses
    begin_event_addr, end_event_addr = Interpreter.parse_event_addresses(asm_file)
    if isnothing(begin_event_addr) || isnothing(end_event_addr)
        @info "begin_event or end_event not found in assembly file"
    else
        @info "begin_event and end_event found in assembly file" begin_event_addr =
            "0x" * string(begin_event_addr; base=16, pad=4) end_event_addr =
            "0x" * string(end_event_addr; base=16, pad=4)
    end

    # Execute program
    final_state, _, _ = Interpreter.interpret_program(
        instructions, addresses, begin_event_addr, end_event_addr, max_steps
    )

    @info "="^60
    @info "EXECUTION SUMMARY"
    @info "="^60
    @info "Successfully executed MSP430 instructions" count = length(instructions)

    return final_state
end

"""
Train mode: Infer energy parameters from assembly and measurement data
"""
function run_train(
    asm_file::String, data_file::String, output_file::Union{String,Nothing}, max_steps::Int
)::Nothing
    @info "Running in TRAIN mode"
    @info "Assembly file" path = asm_file
    @info "Measurement data" path = data_file

    if !isnothing(output_file)
        @info "Output file" path = output_file
    end

    # Parse instructions from assembly file
    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)

    # Parse event addresses
    begin_event_addr, end_event_addr = Interpreter.parse_event_addresses(asm_file)
    if isnothing(begin_event_addr) || isnothing(end_event_addr)
        @info "begin_event or end_event not found in assembly file"
    else
        @info "begin_event and end_event found in assembly file" begin_event_addr =
            "0x" * string(begin_event_addr; base=16, pad=4) end_event_addr =
            "0x" * string(end_event_addr; base=16, pad=4)
    end

    # Execute program
    _, _, event_sequences = Interpreter.interpret_program(
        instructions, addresses, begin_event_addr, end_event_addr, max_steps
    )

    @info "Reading measurement data from CSV"
    df = CSV.read(data_file, DataFrame)

    energies = df.energy_nJ

    if length(event_sequences) != length(energies)
        error(
            "Mismatch between event sequences ($(length(event_sequences))) and energy measurements ($(length(energies)))",
        )
    end

    @info "Creating training data" num_samples = length(energies)
    training_data = TrainingData(event_sequences, energies)

    @info "Training data created successfully"

    # Learn parameters from training data
    @info "Learning energy parameters from training data"
    learned_params = Inference.learn_parameters(training_data)

    @info "Parameter learning complete" num_instruction_types = length(learned_params)

    # Convert parameters to JSON-friendly format
    params_dict = Dict{String,Dict{String,Float64}}()
    for (opcode, (alpha, beta)) in learned_params
        params_dict[string(opcode)] = Dict("alpha" => alpha, "beta" => beta)
    end

    # Export parameters to file if output path is provided
    if !isnothing(output_file)
        @info "Exporting parameters to file" path = output_file
        open(output_file, "w") do f
            JSON.print(f, params_dict, 4)  # 4 spaces for indentation
        end
        @info "Parameters exported successfully"
    else
        @info "No output file specified, printing parameters to console"
        println(JSON.json(params_dict, 4))
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
    plot_file::Union{String,Nothing}=nothing,
)::Nothing
    @info "Running in ESTIMATE mode"
    @info "Assembly file" path = asm_file
    @info "Energy parameters" path = params_file

    if !isnothing(plot_file)
        @info "Plot output file" path = plot_file
    end

    # 1. Load energy parameters from JSON
    params = load_energy_params(params_file)

    # 2. Parse assembly file
    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)

    # 3. Execute program to get instruction trace
    @info "Executing program to get instruction trace"
    _, all_instructions, _ = Interpreter.interpret_program(
        instructions, addresses, nothing, nothing, max_steps
    )

    @info "Instruction trace collected" trace_length = length(all_instructions)

    # 4. Estimate cost distribution
    stats = estimate_cost_distribution(all_instructions, params)

    # 5. Plot cost distribution (separated from business logic)
    try
        plot_cost_distribution(stats, plot_file)
    catch e
        @warn "Failed to plot cost distribution" error = e
        @info "Continuing without plot"
    end

    @info "="^60
    @info "ESTIMATION COMPLETE"
    @info "="^60

    return nothing
end

"""
Main function
"""
function main()
    args = parse_commandline()

    mode = lowercase(args["mode"])
    asm_file = args["asm"]
    max_steps = args["max-steps"]

    try
        if mode == "interpret"
            run_interpret(asm_file, max_steps)

        elseif mode == "train"
            data_file = args["data"]
            if isnothing(data_file)
                error("--data is required for train mode")
            end
            output_file = args["output"]
            run_train(asm_file, data_file, output_file, max_steps)

        elseif mode == "estimate"
            params_file = args["params"]
            if isnothing(params_file)
                error("--params is required for estimate mode")
            end
            plot_file = args["plot"]
            run_estimate(asm_file, params_file, max_steps, plot_file)

        else
            error("Invalid mode: $mode. Must be one of: interpret, train, estimate")
        end

    catch e
        @error "Execution failed" error = e
        exit(1)
    end

    return nothing
end

# Run main function if called directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
