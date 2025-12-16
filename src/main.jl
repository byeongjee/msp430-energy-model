include("../src/types.jl")
include("../src/parser.jl")
include("../src/TraceMetrics.jl")
include("../src/Interpreter.jl")
include("../src/model.jl")
include("../src/Train.jl")
include("../src/Estimation.jl")

using .Types
using .Parser
using .TraceMetrics
using .Interpreter
using .Model
using .Train
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
        "--data-dump"
        help = "Path to objdump -s data dump (used for memory preload in interpret/estimate)"
        required = false
        arg_type = String
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
        help = "Inference algorithm: importance-sampling, mcmc-blocked (for Gamma models), dominant-key (for Mean models), least-squares, least-squares-nnpivot, least-squares-nnls, least-squares-fnnls (for Mean/MeanPair models)"
        arg_type = String
        default = "importance-sampling"
    end

    return parse_args(s)
end

"""
Interpret mode: Run interpreter on assembly file
"""
function run_interpret(
    asm_file::String,
    max_steps::Int;
    data_dump::Union{String,Nothing}=nothing,
    model_str::Union{String,Nothing}="mean_per_addressing_mode_constant",
)
    @info "Running in INTERPRET mode"
    @info "Assembly file" path = asm_file
    if !isnothing(data_dump)
        @info "Data dump" path = data_dump
    end

    # Read and parse assembly file
    asm_content = read(asm_file, String)
    instructions, address_info, _base_address = Interpreter.parse_asm_string(asm_content)
    func_addrs = Parser.find_functions_from_string(asm_content)

    # Get model and granularity before interpretation
    model = Model.create_model(model_str)
    should_track_memory_access = Types.get_should_track_memory_access(model.granularity)
    memory_regions = TraceMetrics.build_memory_regions()
    if should_track_memory_access
        @info "Memory access logging enabled" fram = memory_regions[:fram] sram = memory_regions[:sram]
    end

    final_state, event_traces = Interpreter.interpret_program(
        instructions,
        address_info,
        func_addrs,
        max_steps,
        model.granularity;
        data_file=data_dump,
    )

    # Compute event accesses from traces if model granularity requires it
    event_accesses =
        should_track_memory_access ?
        TraceMetrics.compute_event_accesses(event_traces, memory_regions) :
        Vector{Dict{Symbol,Int}}()

    format_param_key = key -> join(string.(key), "_")
    format_pair_key = pair_key -> begin
        key1_str = join(string.(pair_key[1]), "_")
        key2_str = join(string.(pair_key[2]), "_")
        return key1_str * " -> " * key2_str
    end

    @info "="^60
    @info "EXECUTION SUMMARY"
    @info "="^60
    @info "Successfully executed MSP430 instructions" count = length(instructions)
    @info "Number of events" count = length(event_traces)

    log_event_memory =
        i -> begin
            if should_track_memory_access && i <= length(event_accesses)
                acc = event_accesses[i]
                @info "Event $i memory_accesses" fram_read_hit = get(acc, :fram_read_hit, 0) fram_read_miss = get(acc, :fram_read_miss, 0) fram_write = get(
                    acc, :fram_write, 0
                ) sram_read = get(acc, :sram_read, 0) sram_write = get(
                    acc, :sram_write, 0
                ) other = get(acc, :other, 0) reads = get(acc, :reads, 0) writes = get(
                    acc, :writes, 0
                ) fram = get(acc, :fram, 0) sram = get(acc, :sram, 0) total = get(
                    acc, :total, 0
                )
            end
        end

    if model isa Model.MeanPairModel
        all_param_pairs = Set{Tuple{Model.Key,Model.Key}}()
        for (i, event) in enumerate(event_traces)
            instruction_events = filter(evt -> evt.type == Types.Inst, event)
            pair_keys = Tuple{Model.Key,Model.Key}[]
            for idx in 1:(length(instruction_events) - 1)
                key1 = instruction_events[idx].key
                key2 = instruction_events[idx + 1].key
                push!(pair_keys, Model.normalize_pair(key1, key2))
            end
            unique_pair_keys = unique(pair_keys)
            sort!(unique_pair_keys; by=string)
            union!(all_param_pairs, unique_pair_keys)
            pairs_str = join([format_pair_key(key) for key in unique_pair_keys], " ")
            @info "Event $i param_pairs: $pairs_str" instruction_events = length(
                instruction_events
            )
            log_event_memory(i)
        end
        if !isempty(all_param_pairs)
            pairs_str = join(
                [format_pair_key(key) for key in sort(collect(all_param_pairs); by=string)],
                " ",
            )
            @info "All events param_pairs: $pairs_str"
        end
    else
        all_param_keys = Set{Model.Key}()
        for (i, event) in enumerate(event_traces)
            instruction_events = filter(evt -> evt.type == Types.Inst, event)
            unique_param_keys = unique([inst.key for inst in instruction_events])
            sort!(unique_param_keys; by=string)
            union!(all_param_keys, unique_param_keys)
            keys_str = join([format_param_key(key) for key in unique_param_keys], " ")
            @info "Event $i param_keys: $keys_str" instruction_events = length(
                instruction_events
            )
            log_event_memory(i)
        end
        if !isempty(all_param_keys)
            keys_str = join(
                [format_param_key(key) for key in sort(collect(all_param_keys); by=string)],
                " ",
            )
            @info "All events param_keys: $keys_str"
        end
    end

    return final_state
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
            data_dump = args["data-dump"]
            if isnothing(asm_files) || isempty(asm_files)
                error("--asm is required for interpret mode")
            end
            if length(asm_files) > 1
                error("interpret mode only supports a single assembly file")
            end
            run_interpret(
                asm_files[1], max_steps; data_dump=data_dump, model_str=args["model"]
            )

        elseif mode == "train"
            asm_files = args["asm"]
            data_dump = args["data-dump"]
            if isnothing(asm_files) || isempty(asm_files)
                error("--asm is required for train mode")
            end
            data_files = args["data"]
            if isnothing(data_files) || isempty(data_files)
                error("--data is required for train mode")
            end

            # Read assembly files into strings
            @info "Reading assembly files" files = asm_files
            asm_contents = [read(file, String) for file in asm_files]

            # Read CSV files into DataFrames
            @info "Reading energy measurement files" files = data_files
            energy_dfs = [CSV.read(file, DataFrame) for file in data_files]

            output_file = args["output"]
            n_samples = args["n-samples"]
            model_str = args["model"]
            inference = args["inference"]
            Train.run_train(
                asm_contents,
                energy_dfs,
                output_file,
                max_steps,
                n_samples,
                model_str,
                inference,
            )

        elseif mode == "estimate"
            asm_files = args["asm"]
            data_dump = args["data-dump"]
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
            Estimation.run_estimate(
                asm_files[1], params_file, max_steps, n_samples, output_file, data_dump
            )

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
