include("../src/types.jl")
include("../src/machine_state.jl")
include("../src/parser.jl")
include("../src/Interpreter.jl")
include("../src/model.jl")
include("../src/Train.jl")
include("../src/Estimation.jl")

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
            Train.run_train(
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
