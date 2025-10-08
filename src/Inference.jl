# Inference.jl - Parameter inference for instruction energy distributions

module Inference

using Gen
using Distributions
using Optim
using Statistics
using Logging

# Import types and functions from EnergyModel
using Main.EnergyModel: Instruction, EnergyStats, get_energy_params

# Export public interface
export TrainingData
export instruction_energy_model, parameter_inference_model
export learn_parameters, learn_parameters_mle
export predict_energy, evaluate_parameters

"""
Data structure to hold MSP430 training data
"""
struct TrainingData
    programs::Vector{Vector{Instruction}}
    energies::Vector{Float64}
end

"""
Generative model for parameter inference
Each instruction type has learnable gamma distribution parameters
"""
@gen function instruction_energy_model(
    instructions::Vector{Instruction}, params::Dict{Symbol,Tuple{Float64,Float64}}
)::Float64
    total_energy = 0.0

    for (i, inst) in enumerate(instructions)
        alpha, beta = get(params, inst.opcode, (1.2, 0.2))  # Lower energy defaults for MSP430
        # Use unique address for each instruction in the sequence
        inst_energy = {(:inst_energy, i)} ~ gamma(alpha, beta)
        total_energy += inst_energy
    end

    return total_energy
end

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

    # Sample parameters for each instruction type
    for opcode in all_opcodes
        # Priors for gamma distribution parameters optimized for MSP430 (lower energy)
        # Shape parameter alpha (must be > 0)
        # Use unique addresses for each opcode to avoid Gen trace conflicts
        alpha = {(opcode, :alpha)} ~ gamma(1.5, 0.8)  # Prior: Gamma(1.5,0.8) gives mean=1.2, reasonable for low-power

        # Scale parameter beta (must be > 0)
        beta = {(opcode, :beta)} ~ gamma(1.0, 0.25)  # Prior: Gamma(1,0.25) gives mean=0.25, smaller scale

        learned_params[opcode] = (alpha, beta)
    end

    # Generate energy observations for each program
    for (i, (program, observed_energy)) in
        enumerate(zip(training_data.programs, training_data.energies))
        # Use unique addresses for each program observation
        predicted_energy = {(:predicted_energy, i)} ~ instruction_energy_model(program, learned_params)

        # Observation noise model (smaller noise for MSP430 measurements)
        {(:observed_energy, i)} ~ normal(predicted_energy, 0.05)
    end

    return learned_params
end

"""
Learn MSP430 instruction energy parameters from training data using importance sampling
"""
function learn_parameters(
    training_data::TrainingData; n_samples::Int=1000, n_particles::Int=100
)::Dict{Symbol,Tuple{Float64,Float64}}
    # Get all unique instruction types from training data
    all_opcodes = Set{Symbol}()
    for program in training_data.programs
        for inst in program
            push!(all_opcodes, inst.opcode)
        end
    end

    @info "Starting parameter inference using importance sampling"
    @info "Training data" num_programs = length(training_data.programs) num_opcodes =
        length(all_opcodes) n_samples

    # Create constraints for observed energies
    constraints = choicemap()
    for (i, energy) in enumerate(training_data.energies)
        constraints[(:observed_energy, i)] = energy
    end

    # Run importance sampling
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

    return learned_params
end

"""
Alternative maximum likelihood estimation approach for MSP430
"""
function learn_parameters_mle(
    training_data::TrainingData
)::Dict{Symbol,Tuple{Float64,Float64}}
    @info "Starting parameter inference using MLE (method of moments)"
    @info "Training data" num_programs = length(training_data.programs)

    # Collect instruction counts and total energies per instruction type
    instruction_energies = Dict{Symbol,Vector{Float64}}()

    @info "Distributing energy proportionally among instructions..."
    # For each program, distribute total energy proportionally among instructions
    for (program, total_energy) in zip(training_data.programs, training_data.energies)
        # Simple heuristic: distribute energy based on current parameter means
        instruction_weights = Float64[]
        for inst in program
            alpha, beta = get_energy_params(inst.opcode)
            push!(instruction_weights, alpha * beta)  # Expected value of gamma dist
        end

        total_weight = sum(instruction_weights)
        if total_weight > 0
            for (inst, weight) in zip(program, instruction_weights)
                estimated_energy = total_energy * (weight / total_weight)
                if !haskey(instruction_energies, inst.opcode)
                    instruction_energies[inst.opcode] = Float64[]
                end
                push!(instruction_energies[inst.opcode], estimated_energy)
            end
        end
    end

    @info "Collected energy samples for $(length(instruction_energies)) instruction types"

    # Fit gamma distributions to each instruction's energy samples
    learned_params = Dict{Symbol,Tuple{Float64,Float64}}()

    @info "Fitting gamma distributions using method of moments..."
    for (opcode, energies) in instruction_energies
        if length(energies) >= 2
            # Method of moments estimation for gamma distribution
            sample_mean = mean(energies)
            sample_var = var(energies)

            if sample_var > 0 && sample_mean > 0
                # For gamma distribution: mean = alpha*beta, variance = alpha*beta²
                # So: beta = variance/mean, alpha = mean/beta = mean²/variance
                beta_est = sample_var / sample_mean
                alpha_est = sample_mean / beta_est

                # Ensure parameters are positive and reasonable for MSP430
                alpha_est = max(alpha_est, 0.1)
                beta_est = max(beta_est, 0.01)

                learned_params[opcode] = (alpha_est, beta_est)

                @info "Learned parameters (MLE)" opcode alpha = round(
                    alpha_est; digits=4
                ) beta = round(beta_est; digits=4) mean_energy = round(
                    sample_mean; digits=6
                ) num_samples = length(energies)
            else
                learned_params[opcode] = get_energy_params(opcode)
                @warn "Using default parameters (zero variance or negative mean)" opcode
            end
        else
            learned_params[opcode] = get_energy_params(opcode)
            @warn "Using default parameters (insufficient samples)" opcode num_samples = length(
                energies
            )
        end
    end

    return learned_params
end

"""
Predict energy consumption for a new MSP430 program using learned parameters
"""
function predict_energy(
    program::Vector{Instruction},
    learned_params::Dict{Symbol,Tuple{Float64,Float64}};
    n_samples::Int=1000,
)::EnergyStats
    energies = Float64[]

    for _ in 1:n_samples
        total_energy = 0.0
        for inst in program
            alpha, beta = get(learned_params, inst.opcode, get_energy_params(inst.opcode))
            inst_energy = rand(Gamma(alpha, beta))
            total_energy += inst_energy
        end
        push!(energies, total_energy)
    end

    return EnergyStats(
        mean(energies), std(energies), minimum(energies), maximum(energies), energies
    )
end

"""
Evaluate learned parameters on MSP430 test data
"""
function evaluate_parameters(
    learned_params::Dict{Symbol,Tuple{Float64,Float64}},
    test_data::TrainingData;
    n_samples::Int=1000,
)::NamedTuple{
    (:mse, :mae, :correlation, :predictions, :actual),
    Tuple{Float64,Float64,Float64,Vector{Float64},Vector{Float64}},
}
    predictions = Float64[]
    actual_energies = test_data.energies

    for program in test_data.programs
        predicted_stats = predict_energy(program, learned_params; n_samples=n_samples)
        push!(predictions, predicted_stats.mean)
    end

    # Calculate evaluation metrics
    mse = mean((predictions .- actual_energies) .^ 2)
    mae = mean(abs.(predictions .- actual_energies))
    correlation = cor(predictions, actual_energies)

    return (
        mse=mse,
        mae=mae,
        correlation=correlation,
        predictions=predictions,
        actual=actual_energies,
    )
end

end # module
