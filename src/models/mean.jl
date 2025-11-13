# mean.jl - Generic Mean-based energy model

using JSON
using Statistics

"""
Configuration for Mean-based models
"""
struct MeanConfig <: ModelConfig
    inference_algorithm::String
end

"""
Generic Mean-based model.
Uses simple mean energy per instruction key based on specified granularity.
"""
mutable struct MeanModel <: AbstractModel
    params::Dict{ParamKey,Float64}
    granularity::ModelGranularity
    model_type::String

    function MeanModel(granularity::ModelGranularity, model_type::String)
        new(Dict{ParamKey,Float64}(), granularity, model_type)
    end
end

"""
Get dominant instruction key from a program (most frequent instruction).
Used for microbenchmarks where one instruction type dominates.
"""
function get_dominant_key(
    program::Vector{Instruction}, granularity::ModelGranularity
)::ParamKey
    # Count instruction types
    inst_counts = Dict{ParamKey,Int}()
    for inst in program
        key = get_instruction_key(inst, granularity)
        inst_counts[key] = get(inst_counts, key, 0) + 1
    end
    # nop should not be considered
    # in microbenchmarks, nop is not expected to be executed (they are skipped
    # by jmp instructions)
    delete!(inst_counts, :nop)

    # Return key with maximum count
    return argmax(inst_counts)
end

"""
Load parameters from JSON file for Mean model
"""
function load_params!(model::MeanModel, filename::String)
    if !isfile(filename)
        error("Parameter file not found: $filename")
    end

    file_dict = JSON.parsefile(filename)

    # Verify it's the right model type
    if !haskey(file_dict, "model")
        error("Parameter file missing 'model' field")
    end

    if file_dict["model"] != model.model_type
        @warn "Expected $(model.model_type) model, got $(file_dict["model"])"
    end

    params_dict = file_dict["parameters"]

    # Convert string keys to tuple keys
    model.params = Dict{ParamKey,Float64}()
    for (key_str, mean_energy) in params_dict
        # Split by underscore and convert to appropriate types
        key_parts = split(key_str, "_")
        param_key = tuple(
            [
                let parsed = tryparse(Int, p)
                    parsed !== nothing ? parsed : Symbol(p)
                end for p in key_parts
            ]...
        )

        model.params[param_key] = Float64(mean_energy)
    end

    @info "Loaded Mean model parameters" model_type = model.model_type num_parameters = length(
        model.params
    )
    return nothing
end

"""
Learn parameters from training data using dominant-key inference algorithm
"""
function learn_params_dominant_key!(model::MeanModel, training_data::TrainingData)
    # Accumulate total energy and instruction count for each dominant key
    total_energy = Dict{ParamKey,Float64}()
    total_instructions = Dict{ParamKey,Int}()

    for (energy, program) in zip(training_data.energies, training_data.programs)
        dominant_key = get_dominant_key(program, model.granularity)

        # Accumulate for this key
        num_instructions = length(program)
        total_energy[dominant_key] = get(total_energy, dominant_key, 0.0) + energy
        total_instructions[dominant_key] =
            get(total_instructions, dominant_key, 0) + num_instructions
    end

    # Compute mean energy per instruction (weighted average)
    model.params = Dict{ParamKey,Float64}()

    for key in keys(total_energy)
        mean_energy = total_energy[key] / total_instructions[key]
        model.params[key] = mean_energy

        @debug "Learned mean energy per instruction" param_key = key mean_energy = round(
            mean_energy; digits=6
        ) total_insts = total_instructions[key]
    end

    return nothing
end

"""
Learn parameters from training data using simple mean
"""
function learn_params!(model::MeanModel, training_data::TrainingData, config::MeanConfig)
    @info "Learning Mean model parameters" granularity = model.granularity num_programs = length(
        training_data.programs
    ) inference_algorithm = config.inference_algorithm

    if config.inference_algorithm == "dominant-key"
        learn_params_dominant_key!(model, training_data)
    else
        error("Unknown inference algorithm for Mean model: $(config.inference_algorithm)")
    end

    @info "Learned Mean model parameters" num_parameters = length(model.params)
    return nothing
end

"""
Save parameters to JSON file
"""
function save_params(model::MeanModel, filename::String)
    # Convert tuple keys to string keys
    params_dict = Dict{String,Float64}()
    for (param_key, mean_energy) in model.params
        key_str = join(string.(param_key), "_")
        params_dict[key_str] = mean_energy
    end

    output_dict = Dict{String,Any}("model" => model.model_type, "parameters" => params_dict)

    @info "Saving Mean model parameters" path = filename model_type = model.model_type
    open(filename, "w") do f
        JSON.print(f, output_dict, 4)
    end
    @info "Parameters saved successfully"
    return nothing
end

"""
Estimate energy for a program using dominant-key inference algorithm
"""
function estimate_energy_dominant_key(
    model::MeanModel, program::Vector{Instruction}
)::NamedTuple{
    (:mean, :std, :min, :max, :samples),
    Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
}
    total_energy = 0.0
    unknown_keys = Set{ParamKey}()
    default_energy = 1.0  # Default 1nJ per instruction

    for inst in program
        key = get_instruction_key(inst, model.granularity)

        if haskey(model.params, key)
            total_energy += model.params[key]
        else
            # Use default if not found
            push!(unknown_keys, key)
            total_energy += default_energy
        end
    end

    if !isempty(unknown_keys)
        unknown_strs = [join(string.(k), "_") for k in unknown_keys]
        @warn "Unknown instruction keys. Using default 1.0nJ" keys = join(
            sort(unknown_strs), ", "
        )
    end

    # Mean model is deterministic, so std=0 and min=max=mean
    return (
        mean=total_energy,
        std=0.0,
        min=total_energy,
        max=total_energy,
        samples=[total_energy],
    )
end

"""
Estimate energy for a program (deterministic - just sums mean energies)
"""
function estimate_energy(
    model::MeanModel, program::Vector{Instruction}, config::MeanConfig
)::NamedTuple{
    (:mean, :std, :min, :max, :samples),
    Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
}
    @info "Estimating energy with Mean model" granularity = model.granularity num_instructions = length(
        program
    ) inference_algorithm = config.inference_algorithm

    if config.inference_algorithm == "dominant-key"
        result = estimate_energy_dominant_key(model, program)
    else
        error("Unknown inference algorithm for Mean model: $(config.inference_algorithm)")
    end

    @info "Energy estimation complete" total_energy = round(result.mean; digits=3)
    return result
end
