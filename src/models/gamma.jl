# gamma.jl - Generic Gamma distribution model

using JSON
using Statistics
using Distributions
using Base.Threads

# Assume types.jl, model.jl, and Inference.jl are already included by main.jl
# We only use symbols from Inference module
using Main.Inference: TrainingData, ModelGranularity, learn_parameters, get_instruction_key

"""
Configuration for Gamma-based models
"""
struct GammaConfig <: ModelConfig
    n_samples::Int
    inference_algorithm::String

    function GammaConfig(; n_samples::Int=1000, inference_algorithm::String="importance-sampling")
        new(n_samples, inference_algorithm)
    end
end

"""
Generic Gamma distribution model.
Uses Gamma(alpha, beta) distributions for each instruction key based on specified granularity.
"""
mutable struct GammaModel <: Model
    params::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    granularity::ModelGranularity

    function GammaModel(granularity::ModelGranularity)
        new(Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}(), granularity)
    end
end

"""
Load parameters from JSON file for Gamma model
"""
function load_params!(model::GammaModel, filename::String)
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
    model.params = Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}()
    for (key_str, param_dict) in params_dict
        key_parts = Symbol.(split(key_str, "_"))
        param_key = tuple(key_parts...)
        alpha = param_dict["alpha"]
        beta = param_dict["beta"]
        model.params[param_key] = (alpha, beta)
    end

    @info "Loaded Gamma model parameters" granularity = model.granularity num_parameters = length(model.params)
    return nothing
end

"""
Learn parameters from training data using Gamma distributions
"""
function learn_params!(model::GammaModel, training_data::TrainingData, config::GammaConfig)
    @info "Learning Gamma model parameters" granularity = model.granularity n_samples = config.n_samples algorithm = config.inference_algorithm

    model.params = learn_parameters(
        training_data,
        model.granularity,
        config.inference_algorithm;
        n_samples=config.n_samples
    )

    @info "Learned Gamma model parameters" num_parameters = length(model.params)
    return nothing
end

"""
Save parameters to JSON file
"""
function save_params(model::GammaModel, filename::String)
    # Convert tuple keys to string keys
    params_dict = Dict{String,Dict{String,Float64}}()
    for (param_key, (alpha, beta)) in model.params
        key_str = join(string.(param_key), "_")
        params_dict[key_str] = Dict("alpha" => alpha, "beta" => beta)
    end

    # Create output with metadata
    output_dict = Dict{String,Any}(
        "granularity" => string(model.granularity),
        "parameters" => params_dict
    )

    @info "Saving Gamma model parameters" path = filename granularity = model.granularity
    open(filename, "w") do f
        JSON.print(f, output_dict, 4)
    end
    @info "Parameters saved successfully"
    return nothing
end

"""
Estimate energy distribution for a program
"""
function estimate_energy(
    model::GammaModel,
    program::Vector{Instruction},
    config::GammaConfig
)::NamedTuple{(:mean, :std, :min, :max, :samples), Tuple{Float64,Float64,Float64,Float64,Vector{Float64}}}

    @info "Estimating energy with Gamma model" granularity = model.granularity num_instructions = length(program) n_samples = config.n_samples

    # Default parameters for unknown instructions
    default_alpha = 1.0
    default_beta = 3.0

    # Check for missing instructions
    missing_keys = Set{Tuple{Vararg{Symbol}}}()
    for inst in program
        param_key = get_instruction_key(inst, model.granularity)
        if !haskey(model.params, param_key)
            push!(missing_keys, param_key)
        end
    end

    if !isempty(missing_keys)
        missing_strs = [join(string.(k), "_") for k in missing_keys]
        @warn "Unknown parameter keys. Using default Gamma(alpha=1.0, beta=3.0)" missing = join(sort(missing_strs), ", ")
    end

    # Generate samples
    cost_samples = Vector{Float64}(undef, config.n_samples)

    @threads for i in 1:config.n_samples
        total_cost = 0.0
        for inst in program
            param_key = get_instruction_key(inst, model.granularity)
            alpha, beta = get(model.params, param_key, (default_alpha, default_beta))
            cost = rand(Distributions.Gamma(alpha, beta))
            total_cost += cost
        end
        cost_samples[i] = total_cost
    end

    # Compute statistics
    mean_cost = Statistics.mean(cost_samples)
    std_cost = Statistics.std(cost_samples)
    min_cost = minimum(cost_samples)
    max_cost = maximum(cost_samples)

    @info "Energy estimation complete" mean = round(mean_cost; digits=3) std = round(std_cost; digits=3)

    return (mean=mean_cost, std=std_cost, min=min_cost, max=max_cost, samples=cost_samples)
end
