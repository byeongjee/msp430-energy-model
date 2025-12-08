module Estimation

using JSON
using Logging
using ..Types: Trace, Event
using ..Interpreter
using ..Parser
using ..Model

export run_estimate

"""
Detect model type from params file by reading the 'model' field
"""
function detect_model_type(params_file::String)::String
    file_dict = JSON.parsefile(params_file)

    if !haskey(file_dict, "model")
        error("Parameter file missing 'model' field")
    end

    return file_dict["model"]
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
    data_dump::Union{String,Nothing}=nothing,
)::Nothing
    @info "Running in ESTIMATE mode"
    @info "Assembly file" path = asm_file
    @info "Energy parameters" path = params_file

    if !isnothing(output_file)
        @info "Statistics output file" path = output_file
    end

    model_str = detect_model_type(params_file)
    model = Model.create_model(model_str)
    @info "Detected model type" model = model_str

    Model.load_params!(model, params_file)

    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)
    func_addrs = Parser.find_functions(asm_file)

    @info "Executing program to get event traces"
    start_time = time()
    _, event_traces, _ = Interpreter.interpret_program(
        instructions, addresses, func_addrs, max_steps; data_file=data_dump
    )
    inference_time = time() - start_time

    all_stats = NamedTuple{
        (:mean, :std, :min, :max, :samples),
        Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
    }[]

    config = Model.create_estimation_config(model, n_samples)

    for event_trace in event_traces
        @info "Event trace" length = length(event_trace)
        stats = Model.estimate_energy(model, event_trace, config)
        push!(all_stats, stats)
    end

    @info "="^60
    @info "ESTIMATION COMPLETE"
    @info "="^60
    @info "Inference time" time_seconds = round(inference_time; digits=3)

    if !isnothing(output_file) && !isempty(all_stats)
        @info "Saving estimation statistics" path = output_file num_events = length(
            all_stats
        )
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
