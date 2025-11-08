# Estimation.jl - Energy estimation orchestration module

module Estimation

using JSON
using Logging

# Import Interpreter module
using Main.Interpreter

export run_estimate

"""
Detect model type from params file by checking parameter format
"""
function detect_model_type(params_file::String)::String
    file_dict = JSON.parsefile(params_file)

    # Extract parameters
    params_dict = if haskey(file_dict, "parameters")
        file_dict["parameters"]
    else
        file_dict
    end

    # Check first parameter to determine type
    for (key, value) in params_dict
        if isa(value, Dict) && haskey(value, "alpha") && haskey(value, "beta")
            # Gamma model
            granularity = get(file_dict, "granularity", "PerOpcode")
            if granularity == "PerOpcode"
                return "gamma_per_instruction"
            else
                return "gamma_per_addressing_mode"
            end
        else
            # Mean model
            granularity = get(file_dict, "granularity", "PerOpcode")
            if granularity == "PerOpcode"
                return "mean_per_instruction"
            else
                return "mean_per_addressing_mode"
            end
        end
    end

    error("Could not detect model type from params file")
end

"""
Estimate mode: Predict energy consumption using learned parameters
"""
function run_estimate(
    asm_file::String,
    params_file::String,
    max_steps::Int,
    n_samples::Int,
    output_file::Union{String,Nothing}=nothing,
)::Nothing
    @info "Running in ESTIMATE mode"
    @info "Assembly file" path = asm_file
    @info "Energy parameters" path = params_file

    if !isnothing(output_file)
        @info "Statistics output file" path = output_file
    end

    # Detect and create model (use Main namespace where these are defined)
    model_str = detect_model_type(params_file)
    model = Main.create_model(model_str)
    @info "Detected model type" model = model_str

    # Load parameters
    Main.load_params!(model, params_file)

    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)

    func_addrs = Main.find_functions(asm_file)

    @info "Executing program to get event sequences"
    start_time = time()
    _, event_sequences = Interpreter.interpret_program(
        instructions, addresses, func_addrs, max_steps
    )
    inference_time = time() - start_time

    # Estimate energy for each event sequence
    all_stats = NamedTuple{
        (:mean, :std, :min, :max, :samples),
        Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
    }[]

    # Create config for estimation
    config = Main.create_model_config(model, n_samples, "importance-sampling")

    for event_sequence in event_sequences
        @info "Event sequence" length = length(event_sequence)
        stats = Main.estimate_energy(model, event_sequence, config)
        push!(all_stats, stats)
    end

    @info "="^60
    @info "ESTIMATION COMPLETE"
    @info "="^60
    @info "Inference time" time_seconds = round(inference_time; digits=3)

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

end # module
