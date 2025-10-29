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
        help = "Mode: interpret, train, estimate, or visualize"
        required = true
        arg_type = String
        "--asm"
        help = "Path to assembly file (not required for visualize mode)"
        required = false
        arg_type = String
        "--data"
        help = "Path to energy measurement data (required for train mode)"
        arg_type = String
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

    func_addrs = EnergyModel.find_functions(asm_file)

    # Execute program
    final_state, _ = Interpreter.interpret_program(
        instructions, addresses, func_addrs, max_steps
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
    asm_file::String,
    data_file::String,
    output_file::Union{String,Nothing},
    max_steps::Int,
    n_samples::Int,
    granularity_str::String,
)::Nothing
    @info "Running in TRAIN mode"
    @info "Assembly file" path = asm_file
    @info "Measurement data" path = data_file

    # Parse granularity
    granularity = if granularity_str == "opcode"
        Inference.PerOpcode
    elseif granularity_str == "addressing_mode"
        Inference.PerAddressingMode
    else
        error("Invalid granularity: $granularity_str. Must be 'opcode' or 'addressing_mode'")
    end
    @info "Model granularity" granularity

    if !isnothing(output_file)
        @info "Output file" path = output_file
    end

    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)

    func_addrs = EnergyModel.find_functions(asm_file)
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
            "Mismatch between event sequences ($(length(event_sequences))) and energy measurements ($(length(energies)))",
        )
    end

    @info "Creating training data" num_samples = length(energies)
    training_data = TrainingData(event_sequences, energies)

    @info "Training data created successfully"

    @info "Learning energy parameters from training data" n_samples
    learned_params = Inference.learn_parameters(training_data, granularity; n_samples=n_samples)

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
        "parameters" => params_dict
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

    func_addrs = EnergyModel.find_functions(asm_file)

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
        @info "Saving estimation statistics" path = output_file num_events = length(all_stats)
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
Visualize mode: Visualize energy parameter distributions
"""
function run_visualize(
    params_file::String, output_file::Union{String,Nothing}=nothing
)::Nothing
    @info "Running in VISUALIZE mode"
    @info "Energy parameters" path = params_file

    if !isnothing(output_file)
        @info "Output file" path = output_file
    end

    # Load energy parameters
    params, granularity = load_energy_params(params_file)

    # Visualize parameter distributions
    try
        visualize_instruction_params(params, granularity, output_file)
    catch e
        @warn "Failed to visualize instruction parameters" error = e
        rethrow(e)
    end

    @info "="^60
    @info "VISUALIZATION COMPLETE"
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
            if isnothing(asm_file)
                error("--asm is required for interpret mode")
            end
            run_interpret(asm_file, max_steps)

        elseif mode == "train"
            if isnothing(asm_file)
                error("--asm is required for train mode")
            end
            data_file = args["data"]
            if isnothing(data_file)
                error("--data is required for train mode")
            end
            output_file = args["output"]
            n_samples = args["n-samples"]
            granularity = args["granularity"]
            run_train(asm_file, data_file, output_file, max_steps, n_samples, granularity)

        elseif mode == "estimate"
            if isnothing(asm_file)
                error("--asm is required for estimate mode")
            end
            params_file = args["params"]
            if isnothing(params_file)
                error("--params is required for estimate mode")
            end
            output_file = args["output"]
            run_estimate(asm_file, params_file, max_steps, output_file)

        elseif mode == "visualize"
            params_file = args["params"]
            if isnothing(params_file)
                error("--params is required for visualize mode")
            end
            output_file = args["output"]
            run_visualize(params_file, output_file)

        else
            error(
                "Invalid mode: $mode. Must be one of: interpret, train, estimate, visualize"
            )
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
