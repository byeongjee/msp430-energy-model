# mean.jl - Generic Mean-based energy model

using JSON
using Statistics

include("../model_common.jl")

"""
Configuration for Mean-based models
"""
struct MeanConfig <: ModelConfig
    # Mean models don't need sampling configuration
    function MeanConfig()
        new()
    end
end

"""
Generic Mean-based model.
Uses simple mean energy per instruction key based on specified granularity.
"""
mutable struct MeanModel <: AbstractModel
    params::Dict{Tuple{Vararg{Symbol}},Float64}
    granularity::ModelGranularity

    function MeanModel(granularity::ModelGranularity)
        new(Dict{Tuple{Vararg{Symbol}},Float64}(), granularity)
    end
end

"""
Get dominant instruction key from a program (most frequent instruction).
Used for microbenchmarks where one instruction type dominates.
"""
function get_dominant_key(program::Vector{Instruction}, granularity::ModelGranularity)::Tuple{Vararg{Symbol}}
    # Count instruction types
    inst_counts = Dict{Tuple{Vararg{Symbol}},Int}()
    for inst in program
        key = get_instruction_key(inst, granularity)
        inst_counts[key] = get(inst_counts, key, 0) + 1
    end

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

    # Check format and extract parameters
    params_dict = if haskey(file_dict, "granularity") && haskey(file_dict, "parameters")
        # Verify it's the right granularity
        expected_granularity = string(model.granularity)
        if file_dict["granularity"] != expected_granularity
            @warn "Expected $expected_granularity granularity, got $(file_dict["granularity"])"
        end
        file_dict["parameters"]
    else
        # Old format
        file_dict
    end

    # Convert string keys to tuple keys
    model.params = Dict{Tuple{Vararg{Symbol}},Float64}()
    for (key_str, mean_energy) in params_dict
        key_parts = Symbol.(split(key_str, "_"))
        param_key = tuple(key_parts...)
        # Handle both formats: just a number or a dict with "mean"
        if isa(mean_energy, Number)
            model.params[param_key] = Float64(mean_energy)
        else
            model.params[param_key] = Float64(mean_energy["mean"])
        end
    end

    @info "Loaded Mean model parameters" granularity = model.granularity num_parameters = length(model.params)
    return nothing
end

"""
Learn parameters from training data using simple mean
"""
function learn_params!(model::MeanModel, training_data::TrainingData, config::MeanConfig)
    @info "Learning Mean model parameters" granularity = model.granularity num_programs = length(training_data.programs)

    # Accumulate total energy and instruction count for each dominant key
    total_energy = Dict{Tuple{Vararg{Symbol}},Float64}()
    total_instructions = Dict{Tuple{Vararg{Symbol}},Int}()

    for (energy, program) in zip(training_data.energies, training_data.programs)
        dominant_key = get_dominant_key(program, model.granularity)

        # Accumulate for this key
        num_instructions = length(program)
        total_energy[dominant_key] = get(total_energy, dominant_key, 0.0) + energy
        total_instructions[dominant_key] = get(total_instructions, dominant_key, 0) + num_instructions
    end

    # Compute mean energy per instruction (weighted average)
    model.params = Dict{Tuple{Vararg{Symbol}},Float64}()

    for key in keys(total_energy)
        mean_energy = total_energy[key] / total_instructions[key]
        model.params[key] = mean_energy

        @info "Learned mean energy per instruction" param_key = key mean_energy = round(mean_energy; digits=6) total_insts = total_instructions[key]
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

    output_dict = Dict{String,Any}(
        "granularity" => string(model.granularity),
        "parameters" => params_dict
    )

    @info "Saving Mean model parameters" path = filename granularity = model.granularity
    open(filename, "w") do f
        JSON.print(f, output_dict, 4)
    end
    @info "Parameters saved successfully"
    return nothing
end

"""
Estimate energy for a program (deterministic - just sums mean energies)
"""
function estimate_energy(
    model::MeanModel,
    program::Vector{Instruction},
    config::MeanConfig
)::NamedTuple{(:mean, :std, :min, :max, :samples), Tuple{Float64,Float64,Float64,Float64,Vector{Float64}}}

    @info "Estimating energy with Mean model" granularity = model.granularity num_instructions = length(program)

    total_energy = 0.0
    unknown_keys = Set{Tuple{Vararg{Symbol}}}()
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
        @warn "Unknown instruction keys. Using default 1.0nJ" keys = join(sort(unknown_strs), ", ")
    end

    @info "Energy estimation complete" total_energy = round(total_energy; digits=3)

    # Mean model is deterministic, so std=0 and min=max=mean
    return (mean=total_energy, std=0.0, min=total_energy, max=total_energy, samples=[total_energy])
end
