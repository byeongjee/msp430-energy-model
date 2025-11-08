# Estimation.jl - Energy cost estimation module

module Estimation

using JSON
using Statistics
using Distributions
using Base.Threads

# Include core types
include("types.jl")

using Main.Inference: ModelGranularity, PerOpcode, PerAddressingMode, get_instruction_key

export load_energy_params, estimate_cost_distribution

"""
Load energy parameters from JSON file
Returns a tuple of (params_dict, granularity)
"""
function load_energy_params(params_file::String)::Tuple{Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}},ModelGranularity}
    if !isfile(params_file)
        error("Energy parameters file not found: $params_file")
    end

    # Read and parse JSON
    file_dict = JSON.parsefile(params_file)

    # Check if this is new format (with granularity) or old format
    granularity = PerOpcode  # Default for backward compatibility
    params_dict = if haskey(file_dict, "granularity") && haskey(file_dict, "parameters")
        # New format with metadata
        granularity_str = file_dict["granularity"]
        granularity = if granularity_str == "PerOpcode"
            PerOpcode
        elseif granularity_str == "PerAddressingMode"
            PerAddressingMode
        else
            @warn "Unknown granularity $granularity_str, defaulting to PerOpcode"
            PerOpcode
        end
        file_dict["parameters"]
    else
        # Old format (backward compatibility) - all keys are single opcodes
        file_dict
    end

    # Convert string keys to tuple keys
    params = Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}()
    for (key_str, param_dict) in params_dict
        # Parse key: "mov_immediate_register" -> (:mov, :immediate, :register)
        # or "mov" -> (:mov,)
        key_parts = Symbol.(split(key_str, "_"))
        param_key = tuple(key_parts...)

        alpha = param_dict["alpha"]
        beta = param_dict["beta"]
        params[param_key] = (alpha, beta)
    end

    @info "Loaded energy parameters" granularity num_parameters = length(params)
    return params, granularity
end

"""
Estimate cost distribution from instruction trace and energy parameters
Returns an EnergyStats-like named tuple with mean, std, min, max, and samples
If an instruction is not in params, uses default Gamma(alpha=1.0, beta=3.0)
"""
function estimate_cost_distribution(
    instructions::Vector{Instruction},
    params::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}},
    granularity::ModelGranularity,
    n_samples::Int=10000,
)::NamedTuple{
    (:mean, :std, :min, :max, :samples),
    Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
}
    @info "Estimating cost distribution" num_instructions = length(instructions) num_samples =
        n_samples granularity

    # Check for missing instructions and warn
    missing_keys = Set{Tuple{Vararg{Symbol}}}()
    for inst in instructions
        param_key = get_instruction_key(inst, granularity)
        if !haskey(params, param_key)
            push!(missing_keys, param_key)
        end
    end

    if !isempty(missing_keys)
        missing_strs = [join(string.(k), "_") for k in missing_keys]
        @warn "The following parameter keys are not in the energy parameters file. Using default Gamma(alpha=1.0, beta=3.0)" missing = join(
            sort(missing_strs), ", "
        )
    end

    # Default parameters for unknown instructions
    default_alpha = 1.0
    default_beta = 3.0

    # Generate samples of total cost
    # For each sample, draw energy for each instruction from Gamma(alpha, beta) and sum
    cost_samples = Vector{Float64}(undef, n_samples)

    @info "Starting parallel sampling with $(Threads.nthreads()) threads..."

    @threads for i in 1:n_samples
        total_cost = 0.0
        for inst in instructions
            param_key = get_instruction_key(inst, granularity)
            alpha, beta = get(params, param_key, (default_alpha, default_beta))
            # Sample from Gamma distribution
            cost = rand(Distributions.Gamma(alpha, beta))
            total_cost += cost
        end
        cost_samples[i] = total_cost
    end

    @info "Sampling completed"

    # Compute statistics
    mean_cost = Statistics.mean(cost_samples)
    std_cost = Statistics.std(cost_samples)
    min_cost = minimum(cost_samples)
    max_cost = maximum(cost_samples)

    @info "Cost distribution statistics" mean = round(mean_cost; digits=3) std = round(
        std_cost; digits=3
    ) min = round(min_cost; digits=3) max = round(max_cost; digits=3)

    return (mean=mean_cost, std=std_cost, min=min_cost, max=max_cost, samples=cost_samples)
end

end # module
