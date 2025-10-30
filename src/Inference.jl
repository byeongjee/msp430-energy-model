# Inference.jl - Parameter inference for instruction energy distributions

module Inference

using Gen
using Distributions
using Optim
using Statistics
using Logging

using Main.EnergyModel: Instruction, Operand, EnergyStats

export TrainingData, ModelGranularity, InferenceAlgorithm
export PerOpcode, PerAddressingMode
export ImportanceSampling, MCMC
export single_program_energy_model, parameter_inference_model
export learn_parameters

struct TrainingData
    programs::Vector{Vector{Instruction}}
    energies::Vector{Float64}
end

"""
Granularity level for energy model parameters
"""
@enum ModelGranularity begin
    PerOpcode = 1              # One parameter per opcode (e.g., mov, add, sub)
    PerAddressingMode = 2      # One parameter per (opcode, addressing_mode) combination
end

"""
Inference algorithm for learning energy parameters
"""
@enum InferenceAlgorithm begin
    ImportanceSampling = 1     # Importance sampling (default)
    MCMC = 2                   # Markov Chain Monte Carlo
end

"""
Check if an (opcode, addressing_mode) combination is meaningful for energy modeling.
Some combinations are meaningless because:
- No-operand instructions (ret, nop) don't use addressing modes
- Jump instructions only use symbolic (PC-relative) addressing
"""
function is_meaningful_combination(opcode::Symbol, mode::Symbol)::Bool
    # No-operand instructions - addressing mode is meaningless
    no_operand_instructions = [:ret, :nop, :reti, :dint]
    if opcode in no_operand_instructions
        return false
    end

    # Jump instructions only use symbolic (PC-relative) addressing
    jump_instructions = [:jnz, :jz, :jnc, :jc, :jn, :jge, :jl, :jmp]
    if opcode in jump_instructions
        return mode == :symbolic
    end

    # All other combinations are valid
    return true
end

"""
Get instruction key for parameter lookup based on granularity level.
For dual-operand instructions with PerAddressingMode, uses source and destination modes.
"""
function get_instruction_key(
    inst::Instruction, granularity::ModelGranularity
)::Tuple{Vararg{Symbol}}
    if granularity == PerOpcode
        # Simple: just the opcode
        return (inst.opcode,)
    else  # PerAddressingMode
        if length(inst.operands) == 0
            # No operands (e.g., ret, nop)
            return (inst.opcode,)
        elseif length(inst.operands) == 1
            # Single operand (e.g., push R5, call, jmp)
            return (inst.opcode, inst.operands[1].mode)
        else
            # Dual operand (e.g., mov, add) - use src and dst modes
            src_mode = inst.operands[1].mode
            dst_mode = inst.operands[2].mode
            return (inst.opcode, src_mode, dst_mode)
        end
    end
end

"""
Extract all valid parameter keys from training data based on granularity level.
Only includes meaningful combinations.
"""
function get_valid_param_keys(
    training_data::TrainingData, granularity::ModelGranularity
)::Set{Tuple{Vararg{Symbol}}}
    valid_keys = Set{Tuple{Vararg{Symbol}}}()

    for program in training_data.programs
        for inst in program
            key = get_instruction_key(inst, granularity)

            # For PerAddressingMode, filter out meaningless combinations
            if granularity == PerAddressingMode && length(key) >= 2
                # key is (opcode, mode) or (opcode, src_mode, dst_mode)
                if length(key) == 2
                    # Single operand: check if meaningful
                    if is_meaningful_combination(key[1], key[2])
                        push!(valid_keys, key)
                    end
                else
                    # Dual operand: both modes should be meaningful separately
                    # (we don't filter dual-op combos, just make sure they're valid)
                    push!(valid_keys, key)
                end
            else
                # PerOpcode or already validated
                push!(valid_keys, key)
            end
        end
    end

    return valid_keys
end

@gen function single_program_energy_model(
    instructions::Vector{Instruction},
    params::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}},
    granularity::ModelGranularity,
)::Float64
    total_energy = 0.0

    for (i, inst) in enumerate(instructions)
        # Get parameter key based on granularity
        param_key = get_instruction_key(inst, granularity)

        # Look up parameters - error if not found
        if !haskey(params, param_key)
            error("No parameters found for instruction key $param_key")
        end
        alpha, beta = params[param_key]

        inst_energy = {(:inst_energy, i)} ~ gamma(alpha, beta)
        total_energy += inst_energy
    end

    return total_energy
end

epsilon = 1e-12

@gen function all_programs_energy_model(
    training_data::TrainingData, granularity::ModelGranularity
)::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    # Prior distributions for gamma parameters
    learned_params = Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}()

    # Get all valid parameter keys from training data based on granularity
    valid_keys = get_valid_param_keys(training_data, granularity)

    # For now we are using a stateless model.
    # Assuming that there is a single gamma distribution for each parameter key.
    for param_key in valid_keys
        # Current ≈ 118 µA/MHz (https://www.ti.com/lit/ds/symlink/msp430fr5994.pdf)
        # Voltage: 3.3V
        # -> 0.389mW per MHz
        # -> 3.89 * 10e-10 J per CPU cycle

        # roughly 3 cycle per instuction
        # (https://www.ti.com/sc/docs/products/micro/msp430/userguid/as_5.pdf)

        # -> roughly 1e-9 J per instruction = 1.0 nJ per instruction

        # TODO: Are these priors reasonable?
        log_mu = {(param_key..., :logμ)} ~ normal(log(1.0), 0.7)
        log_kappa = {(param_key..., :logκ)} ~ normal(log(3.0), 0.5)

        mu = exp(log_mu)
        kappa = exp(log_kappa)

        alpha = kappa
        beta = mu / kappa

        learned_params[param_key] = (alpha, beta)
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
                program, learned_params, granularity
            )

        {(:observed_energy_consumption, i)} ~ normal(actual_energy_consumption, sigma)
    end

    return learned_params
end

"""
Learn MSP430 instruction energy parameters from training data using MCMC
TODO: Implement full MCMC inference algorithm
"""
function learn_parameters_mcmc(
    training_data::TrainingData, granularity::ModelGranularity; n_samples::Int=1000
)::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    # Get all valid parameter keys based on granularity
    valid_keys = get_valid_param_keys(training_data, granularity)

    @info "Starting parameter inference using MCMC"
    @info "Training data" num_programs = length(training_data.programs) granularity num_param_keys =
        length(valid_keys) n_samples

    # Start timing
    start_time = time()

    # TODO: Implement MCMC inference
    # For now, this is a skeleton that uses a simple fallback strategy
    @warn "MCMC inference is not yet fully implemented - using default parameters"

    learned_params = Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}()

    for param_key in valid_keys
        # Default parameters based on rough estimates
        # Current ≈ 118 µA/MHz -> roughly 1 nJ per instruction
        # Using Gamma distribution with mean=1.0, variance=0.33
        alpha = 3.0
        beta = 0.33
        learned_params[param_key] = (alpha, beta)

        mean_energy = alpha * beta
        @info "Using default parameters (MCMC not implemented)" param_key alpha beta mean_energy =
            round(mean_energy; digits=6)
    end

    # Calculate and log execution time
    learning_time = time() - start_time
    @info "Parameter learning completed (MCMC skeleton)" time = learning_time num_learned_params =
        length(learned_params)

    return learned_params
end

"""
Learn MSP430 instruction energy parameters from training data using importance sampling
"""
function learn_parameters_importance_sampling(
    training_data::TrainingData, granularity::ModelGranularity; n_samples::Int=1000
)::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    # Get all valid parameter keys based on granularity
    valid_keys = get_valid_param_keys(training_data, granularity)

    @info "Starting parameter inference using importance sampling"
    @info "Training data" num_programs = length(training_data.programs) granularity num_param_keys =
        length(valid_keys) n_samples

    # Start timing
    start_time = time()

    constraints = choicemap()
    for (i, energy) in enumerate(training_data.energies)
        constraints[(:observed_energy_consumption, i)] = energy
    end

    @info "Running importance sampling..."
    (traces, log_weights) = importance_sampling(
        all_programs_energy_model, (training_data, granularity), constraints, n_samples
    )

    # Compute effective sample size
    normalized_weights = exp.(log_weights .- maximum(log_weights))
    normalized_weights ./= sum(normalized_weights)
    ess = 1.0 / sum(normalized_weights .^ 2)

    @info "Importance sampling complete" effective_sample_size = round(ess; digits=2)

    learned_params = Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}()

    @info "Computing weighted parameter averages..."
    for param_key in valid_keys
        alphas = Float64[]
        betas = Float64[]
        weights = Float64[]

        for (trace, log_weight) in zip(traces, log_weights)
            params = get_retval(trace)
            if haskey(params, param_key)
                alpha, beta = params[param_key]
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
            learned_params[param_key] = (avg_alpha, avg_beta)

            # Calculate statistics
            mean_energy = avg_alpha * avg_beta
            @info "Learned parameters" param_key alpha = round(avg_alpha; digits=4) beta = round(
                avg_beta; digits=4
            ) mean_energy = round(mean_energy; digits=6)
        else
            # Fallback to default parameters
            learned_params[param_key] = (1.0, 3.0)
            @warn "Using default parameters (no samples)" param_key
        end
    end

    # Calculate and log execution time
    learning_time = time() - start_time
    @info "Parameter learning completed" time = learning_time num_learned_params = length(
        learned_params
    )

    return learned_params
end

"""
Learn MSP430 instruction energy parameters from training data.

# Arguments
- `training_data`: Training data containing programs and measured energies
- `granularity`: Model granularity level (PerOpcode or PerAddressingMode)
- `algorithm`: Inference algorithm to use (ImportanceSampling or MCMC)
- `n_samples`: Number of samples to use for inference (default: 1000)

# Returns
Dictionary mapping instruction keys to (alpha, beta) parameters of Gamma distributions
"""
function learn_parameters(
    training_data::TrainingData,
    granularity::ModelGranularity,
    algorithm::InferenceAlgorithm=ImportanceSampling;
    n_samples::Int=1000,
)::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    if algorithm == ImportanceSampling
        return learn_parameters_importance_sampling(
            training_data, granularity; n_samples=n_samples
        )
    elseif algorithm == MCMC
        return learn_parameters_mcmc(training_data, granularity; n_samples=n_samples)
    else
        error("Unknown inference algorithm: $algorithm")
    end
end

end # module
