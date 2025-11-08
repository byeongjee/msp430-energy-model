# gamma.jl - Generic Gamma distribution model

using JSON
using Statistics
using Distributions
using Base.Threads
using Gen
using Logging

# Include common model utilities
include("../model_common.jl")

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

# ============================================================================
# Gen.jl Probabilistic Inference Functions
# ============================================================================

epsilon = 1e-12

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
Compute posterior means from MCMC traces.
"""
function compute_posterior_means(
    traces::Vector, valid_keys::Set{Tuple{Vararg{Symbol}}}
)::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    learned_params = Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}()

    for param_key in valid_keys
        alphas = Float64[]
        betas = Float64[]

        for trace in traces
            params = get_retval(trace)
            if haskey(params, param_key)
                alpha, beta = params[param_key]
                push!(alphas, alpha)
                push!(betas, beta)
            end
        end

        # Posterior mean
        avg_alpha = mean(alphas)
        avg_beta = mean(betas)
        learned_params[param_key] = (avg_alpha, avg_beta)

        mean_energy = avg_alpha * avg_beta
        @info "Learned parameters (MCMC)" param_key alpha = round(avg_alpha; digits=4) beta = round(
            avg_beta; digits=4
        ) mean_energy = round(mean_energy; digits=6)
    end

    return learned_params
end

"""
Learn parameters using MCMC with blocked Gibbs sampling
"""
function learn_parameters_mcmc_blocked(
    training_data::TrainingData,
    granularity::ModelGranularity;
    n_samples::Int=1000,
    burn_in::Int=100,
)::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    # Get all valid parameter keys based on granularity
    valid_keys = get_valid_param_keys(training_data, granularity)

    @info "Starting MCMC inference (Blocked Gibbs/MH)"
    @info "Training data" num_programs = length(training_data.programs) granularity num_param_keys = length(
        valid_keys
    ) n_samples burn_in

    # Start timing
    start_time = time()

    # Set up constraints (observed energies)
    constraints = choicemap()
    for (i, energy) in enumerate(training_data.energies)
        constraints[(:observed_energy_consumption, i)] = energy
    end

    # Initialize trace with constraints
    @info "Initializing trace..."
    trace, = generate(all_programs_energy_model, (training_data, granularity), constraints)
    @info "Initial log probability" log_prob = get_score(trace)

    @info "Number of parameter blocks" num_blocks = length(valid_keys) + 1

    # MCMC sampling with blocked updates
    traces = []
    total_proposals = 0
    total_accepted = 0

    for i in 1:(burn_in + n_samples)
        # Block 1: Update each instruction's parameters separately
        for param_key in valid_keys
            selection = select((param_key..., :logμ), (param_key..., :logκ))
            trace, accepted = mh(trace, selection)
            total_proposals += 1
            if accepted
                total_accepted += 1
            end
        end

        # Block 2: Update observation noise parameter
        trace, accepted = mh(trace, select(:log_obs_sigma))
        total_proposals += 1
        if accepted
            total_accepted += 1
        end

        # Collect samples after burn-in
        if i > burn_in
            push!(traces, trace)
        end

        if i % 10 == 0
            acceptance_rate = total_accepted / total_proposals
            @info "MCMC progress" iteration = i log_prob = round(get_score(trace); digits=2) acceptance_rate = round(
                acceptance_rate; digits=3
            )
        end
    end

    # Final acceptance rate
    final_acceptance_rate = total_accepted / total_proposals
    @info "MCMC sampling complete" total_iterations = burn_in + n_samples acceptance_rate = round(
        final_acceptance_rate; digits=3
    )

    # Compute posterior means
    @info "Computing posterior means..."
    learned_params = compute_posterior_means(traces, valid_keys)

    # Calculate and log execution time
    learning_time = time() - start_time
    @info "Parameter learning completed (Blocked-MCMC)" time = learning_time num_learned_params = length(
        learned_params
    )

    return learned_params
end

"""
Learn parameters using importance sampling
"""
function learn_parameters_importance_sampling(
    training_data::TrainingData, granularity::ModelGranularity; n_samples::Int=1000
)::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    # Get all valid parameter keys based on granularity
    valid_keys = get_valid_param_keys(training_data, granularity)

    @info "Starting parameter inference using importance sampling"
    @info "Training data" num_programs = length(training_data.programs) granularity num_param_keys = length(
        valid_keys
    ) n_samples

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
Main entry point for parameter learning - dispatches to correct algorithm
"""
function learn_parameters(
    training_data::TrainingData,
    granularity::ModelGranularity,
    algorithm::String;
    n_samples::Int,
)::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}}
    if algorithm == "importance-sampling"
        return learn_parameters_importance_sampling(
            training_data, granularity; n_samples=n_samples
        )
    elseif algorithm == "mcmc-blocked"
        return learn_parameters_mcmc_blocked(
            training_data, granularity; n_samples=n_samples
        )
    else
        error(
            "Unknown inference algorithm: $algorithm. " *
            "Must be one of: importance-sampling, mcmc-blocked",
        )
    end
end

# ============================================================================
# GammaModel Implementation
# ============================================================================

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
