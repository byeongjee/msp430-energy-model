module Estimation

using JSON
using Logging
using ..Types
using ..Interpreter
using ..Parser
using ..Model

export run_estimate

"""
Detect model type from params dictionary by reading the 'model' field
"""
function detect_model_type(params_dict::Dict)::String
    if !haskey(params_dict, "model")
        error("Parameter dictionary missing 'model' field")
    end

    return params_dict["model"]
end

"""
Parse a key string (e.g., "mov_immediate_register") back to a tuple key.
"""
function parse_key_string(key_str::String)::Key
    key_parts = split(key_str, "_")
    return tuple(
        [
            let parsed = tryparse(Int, string(p))
                parsed !== nothing ? parsed : Symbol(p)
            end for p in key_parts
        ]...
    )
end

"""
Collect debug info for a single execution trace (event).
Returns a Dict with key counts and energy contributions.
"""
function collect_event_debug_info(
    event_idx::Int,
    execution_trace::ExecutionTrace,
    estimated_energy::Float64,
    model_params::Dict{Key,Float64},
)::Dict{String,Any}
    # Count occurrences of each instruction key
    key_counts = Dict{String,Int}()
    for execution_event in execution_trace
        key_str = join(string.(execution_event.key), "_")
        key_counts[key_str] = get(key_counts, key_str, 0) + 1
    end

    # Calculate energy contribution per key
    key_energies = Dict{String,Float64}()
    for (key_str, count) in key_counts
        param_key = parse_key_string(key_str)
        if haskey(model_params, param_key)
            key_energies[key_str] = model_params[param_key] * count
        else
            key_energies[key_str] = 1.0 * count  # default energy
        end
    end

    return Dict(
        "event_index" => event_idx,
        "num_events" => length(execution_trace),
        "estimated_energy" => estimated_energy,
        "key_counts" => key_counts,
        "key_energies" => key_energies,
    )
end

"""
Save estimation debug data to a JSON file.
"""
function save_estimation_debug_dump(
    debug_path::String,
    model_str::String,
    model_params::Dict{Key,Float64},
    event_debug_info::Vector,
)
    @info "Dumping estimation debug data" path = debug_path

    # Convert model params to string keys
    params_str = Dict{String,Float64}()
    for (k, v) in model_params
        params_str[join(string.(k), "_")] = v
    end

    debug_data = Dict{String,Any}(
        "model_type" => model_str,
        "num_events" => length(event_debug_info),
        "learned_params" => params_str,
        "events" => event_debug_info,
    )

    open(debug_path, "w") do f
        JSON.print(f, debug_data, 2)
    end
    @info "Estimation debug data saved" path = debug_path
end

"""
Estimate mode: Predict energy consumption using learned parameters
"""
function run_estimate(
    asm_content::String,
    params_dict::Dict,
    max_steps::Int,
    n_samples::Int,
    output_file::Union{String,Nothing}=nothing,
    data_dump::Union{String,Nothing}=nothing,
)::Nothing
    @info "Running in ESTIMATE mode"

    if !isnothing(output_file)
        @info "Statistics output file" path = output_file
    end

    model_str = detect_model_type(params_dict)
    model = Model.create_model(model_str)
    @info "Detected model type" model = model_str
    granularity = model.granularity

    Model.load_params!(model, params_dict)

    # Parse assembly content
    instructions, address_info, _base_address = Interpreter.parse_asm_string(asm_content)
    func_addrs = Parser.find_functions_from_string(asm_content)

    @info "Executing program to get execution traces"
    start_time = time()
    _, execution_traces = Interpreter.interpret_program(
        instructions, address_info, func_addrs, max_steps, granularity; data_file=data_dump
    )
    inference_time = time() - start_time

    all_stats = NamedTuple{
        (:mean, :std, :min, :max, :samples),
        Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
    }[]

    config = Model.create_estimation_config(model, n_samples)
    event_debug_info = Vector{Dict{String,Any}}()

    for (event_idx, execution_trace) in enumerate(execution_traces)
        @info "Execution trace" length = length(execution_trace)
        stats = Model.estimate_energy(model, execution_trace, config)
        push!(all_stats, stats)

        # Collect debug info for this event
        debug_info = collect_event_debug_info(
            event_idx, execution_trace, stats.mean, model.params
        )
        push!(event_debug_info, debug_info)
    end

    # Save debug dump if environment variable is set
    estimate_debug_path = get(ENV, "JULIA_ESTIMATE_DEBUG_DUMP_PATH", nothing)
    if !isnothing(estimate_debug_path)
        save_estimation_debug_dump(
            estimate_debug_path, model_str, model.params, event_debug_info
        )
    end

    @info "="^60
    @info "ESTIMATION COMPLETE"
    @info "="^60
    @info "Inference time" time_seconds = round(inference_time; digits=3)

    if !isnothing(output_file) && !isempty(all_stats)
        @info "Saving estimation statistics" path = output_file num_execution_traces = length(
            all_stats
        )
        execution_traces_array = []
        for stats in all_stats
            push!(
                execution_traces_array,
                Dict(
                    "mean" => stats.mean,
                    "std" => stats.std,
                    "min" => stats.min,
                    "max" => stats.max,
                    "samples" => stats.samples,
                ),
            )
        end
        stats_dict = Dict("execution_traces" => execution_traces_array)
        open(output_file, "w") do f
            JSON.print(f, stats_dict, 4)
        end
        @info "Statistics saved successfully"
    end

    return nothing
end

end # module
