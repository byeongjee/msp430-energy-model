# Estimation.jl - Energy cost estimation module

module Estimation

using JSON
using Statistics
using Distributions
using Main.EnergyModel: Instruction

export load_energy_params, estimate_cost_distribution

"""
Load energy parameters from JSON file
Returns a dictionary mapping instruction names (as symbols) to (alpha, beta) tuples
"""
function load_energy_params(params_file::String)::Dict{Symbol,Tuple{Float64,Float64}}
    if !isfile(params_file)
        error("Energy parameters file not found: $params_file")
    end

    # Read and parse JSON
    params_dict = JSON.parsefile(params_file)

    # Convert to Symbol keys with (alpha, beta) tuple values
    params = Dict{Symbol,Tuple{Float64,Float64}}()
    for (opcode_str, param_dict) in params_dict
        opcode = Symbol(opcode_str)
        alpha = param_dict["alpha"]
        beta = param_dict["beta"]
        params[opcode] = (alpha, beta)
    end

    @info "Loaded energy parameters" num_instructions = length(params)
    return params
end

"""
Estimate cost distribution from instruction trace and energy parameters
Returns an EnergyStats-like named tuple with mean, std, min, max, and samples
If an instruction is not in params, uses default Gamma(alpha=1.0, beta=3.0)
"""
function estimate_cost_distribution(
    instructions::Vector{Instruction},
    params::Dict{Symbol,Tuple{Float64,Float64}},
    n_samples::Int=10000,
)::NamedTuple{
    (:mean, :std, :min, :max, :samples),
    Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
}
    @info "Estimating cost distribution" num_instructions = length(instructions) num_samples =
        n_samples

    # Check for missing instructions and warn
    missing_instructions = Set{Symbol}()
    for inst in instructions
        if !haskey(params, inst.opcode)
            push!(missing_instructions, inst.opcode)
        end
    end

    if !isempty(missing_instructions)
        @warn "The following instructions are not in the energy parameters file. Using default Gamma(alpha=1.0, beta=3.0)" missing = join(
            sort(collect(missing_instructions)), ", "
        )
    end

    # Default parameters for unknown instructions
    default_alpha = 1.0
    default_beta = 3.0

    # Generate samples of total cost
    # For each sample, draw energy for each instruction from Gamma(alpha, beta) and sum
    cost_samples = Float64[]

    # Progress logging interval
    progress_interval = max(1, div(n_samples, 10))  # Log at 10%, 20%, ..., 100%

    for i in 1:n_samples
        total_cost = 0.0
        for inst in instructions
            alpha, beta = get(params, inst.opcode, (default_alpha, default_beta))
            # Sample from Gamma distribution
            cost = rand(Distributions.Gamma(alpha, beta))
            total_cost += cost
        end
        push!(cost_samples, total_cost)

        # Log progress at intervals
        if i % progress_interval == 0 || i == n_samples
            progress_pct = round(100 * i / n_samples; digits=1)
            @info "Sampling progress" samples_completed = i total_samples = n_samples progress = "$(progress_pct)%"
        end
    end

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
