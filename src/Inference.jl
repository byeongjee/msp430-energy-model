# Inference.jl - Parameter inference for instruction energy distributions

module Inference

using Gen
using Distributions
using Optim
using Statistics
using Logging

using Main.EnergyModel: Instruction, EnergyStats, get_energy_params

export TrainingData
export single_program_energy_model, parameter_inference_model
export learn_parameters

struct TrainingData
    programs::Vector{Vector{Instruction}}
    energies::Vector{Float64}
end

"""
Generative model for parameter inference
Each instruction type has learnable gamma distribution parameters
"""
@gen function single_program_energy_model(
    instructions::Vector{Instruction}, params::Dict{Symbol,Tuple{Float64,Float64}}
)::Float64
    total_energy = 0.0

    for (i, inst) in enumerate(instructions)
        alpha, beta = params[inst.opcode]
        # Use unique address for each instruction in the sequence
        inst_energy = {(:inst_energy, i)} ~ gamma(alpha, beta)
        total_energy += inst_energy
    end

    return total_energy
end

epsilon = 1e-12

"""
Inference model that learns parameters from MSP430 data
"""
@gen function parameter_inference_model(
    training_data::TrainingData
)::Dict{Symbol,Tuple{Float64,Float64}}
    # Prior distributions for gamma parameters
    learned_params = Dict{Symbol,Tuple{Float64,Float64}}()

    # Get all unique instruction types from training data
    all_opcodes = Set{Symbol}()
    for program in training_data.programs
        for inst in program
            push!(all_opcodes, inst.opcode)
        end
    end

    # For now we are using a stateless model.
    # Assuming that there is a single gamma distribution for each type of instruction.
    for opcode in all_opcodes
        # Current ≈ 118 µA/MHz (https://www.ti.com/lit/ds/symlink/msp430fr5994.pdf)
        # Voltage: 3.3V
        # -> 0.389mW per MHz
        # -> 3.89 * 10e-10 J per CPU cycle

        # roughly 3 cycle per instuction
        # (https://www.ti.com/sc/docs/products/micro/msp430/userguid/as_5.pdf)

        # -> roughly 1e-9 J per instruction = 1.0 nJ per instruction

        # TODO: Are these priors reasonable?
        log_mu = {(opcode, :logμ)} ~ normal(log(1.0), 0.7)
        log_kappa = {(opcode, :logκ)} ~ normal(log(3.0), 0.5)

        mu = exp(log_mu)
        kappa = exp(log_kappa)

        alpha = kappa
        beta = mu / kappa

        learned_params[opcode] = (alpha, beta)
    end

    # Compute median observed energy (in the same units as y)
    m = median(training_data.energies)
    rho = 0.05  # start with 5% of median total as typical noise
    tau = 0.7   # FIXME: Arbitrary value suggested by ChatGPT

    # Learn sigma with a scale-aware, weakly-informative prior
    log_sigma = {:log_obs_sigma} ~ normal(log(rho * m + epsilon), tau)
    sigma = exp(log_sigma)

    # Generate energy observations for each program
    for (i, program) in enumerate(training_data.programs)
        actual_energy_consumption =
            {(:actual_energy_consumption, i)} ~ single_program_energy_model(
                # TODO: What should be the priors?
                program,
                learned_params,
            )

        {(:observed_energy_consumption, i)} ~ normal(actual_energy_consumption, sigma)
    end

    return learned_params
end

"""
Learn MSP430 instruction energy parameters from training data using importance sampling
"""
function learn_parameters(
    training_data::TrainingData; n_samples::Int=1000
)::Dict{Symbol,Tuple{Float64,Float64}}
    # Get all unique instruction types from training data
    all_opcodes = Set{Symbol}()
    for program in training_data.programs
        for inst in program
            push!(all_opcodes, inst.opcode)
        end
    end

    @info "Starting parameter inference using importance sampling"
    @info "Training data" num_programs = length(training_data.programs) num_opcodes = length(
        all_opcodes
    ) n_samples

    # Start timing
    start_time = time()

    constraints = choicemap()
    for (i, energy) in enumerate(training_data.energies)
        constraints[(:observed_energy_consumption, i)] = energy
    end

    @info "Running importance sampling..."
    (traces, log_weights) = importance_sampling(
        parameter_inference_model, (training_data,), constraints, n_samples
    )

    # Compute effective sample size
    normalized_weights = exp.(log_weights .- maximum(log_weights))
    normalized_weights ./= sum(normalized_weights)
    ess = 1.0 / sum(normalized_weights .^ 2)

    @info "Importance sampling complete" effective_sample_size = round(ess; digits=2)

    learned_params = Dict{Symbol,Tuple{Float64,Float64}}()

    @info "Computing weighted parameter averages..."
    for opcode in all_opcodes
        alphas = Float64[]
        betas = Float64[]
        weights = Float64[]

        for (trace, log_weight) in zip(traces, log_weights)
            params = get_retval(trace)
            if haskey(params, opcode)
                alpha, beta = params[opcode]
                push!(alphas, alpha)
                push!(betas, beta)
                push!(weights, exp(log_weight))
            end
        end

        # Weighted average
        total_weight = sum(weights)
        if total_weight > 0
            avg_alpha = sum(alphas .* weights) / total_weight
            avg_beta = sum(betas .* weights) / total_weight
            learned_params[opcode] = (avg_alpha, avg_beta)

            # Calculate statistics
            mean_energy = avg_alpha * avg_beta
            @info "Learned parameters" opcode alpha = round(avg_alpha; digits=4) beta = round(
                avg_beta; digits=4
            ) mean_energy = round(mean_energy; digits=6)
        else
            # Fallback to default parameters
            learned_params[opcode] = get_energy_params(opcode)
            @warn "Using default parameters for opcode (no samples)" opcode
        end
    end

    # Calculate and log execution time
    learning_time = time() - start_time
    @info "Parameter learning completed" time = learning_time num_learned_opcodes = length(
        learned_params
    )

    return learned_params
end

end # module
