# mean.jl - Generic Mean-based energy model

using JSON
using Statistics
using LinearAlgebra
using NonNegLeastSquares
using Optim

"""
Training configuration for Mean-based models
"""
struct MeanTrainingConfig <: TrainingConfig
    inference_algorithm::String
end

"""
Estimation configuration for Mean-based models
"""
struct MeanEstimationConfig <: EstimationConfig end

"""
Generic Mean-based model.
Uses simple mean energy per instruction key based on specified granularity.
"""
mutable struct MeanModel <: AbstractModel
    params::Dict{Key,Float64}
    granularity::ModelGranularity
    model_type::String

    function MeanModel(granularity::ModelGranularity, model_type::String)
        new(Dict{Key,Float64}(), granularity, model_type)
    end
end

"""
Get dominant event key from an execution trace (most frequent event key).
Used for microbenchmarks where one event type dominates.
"""
function get_dominant_key(
    execution_trace::ExecutionTrace, model_granularity::ModelGranularity
)::Key
    # Count event types
    key_counts = Dict{Key,Int}()
    for execution_event in execution_trace
        key = execution_event.key
        key_counts[key] = get(key_counts, key, 0) + 1
    end
    # nop should not be considered
    # in microbenchmarks, nop is not expected to be executed (they are skipped
    # by jmp instructions)
    delete!(key_counts, :nop)

    # Return key with maximum count
    return argmax(key_counts)
end

"""
Load parameters from dictionary for Mean model
"""
function load_params!(model::MeanModel, params_dict::Dict)
    # Verify it's the right model type
    if !haskey(params_dict, "model")
        error("Parameter dictionary missing 'model' field")
    end

    if params_dict["model"] != model.model_type
        @warn "Expected $(model.model_type) model, got $(params_dict["model"])"
    end

    parameters = params_dict["parameters"]

    # Convert string keys to tuple keys
    model.params = Dict{Key,Float64}()
    for (key_str, mean_energy) in parameters
        param_key = parse_key_string(key_str)

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
    # Accumulate total energy and event count for each dominant key
    total_energy = Dict{Key,Float64}()
    total_events = Dict{Key,Int}()

    for (energy, execution_trace) in
        zip(training_data.energies, training_data.execution_traces)
        dominant_key = get_dominant_key(execution_trace, model.granularity)

        # Accumulate for this key
        num_events = length(execution_trace)
        total_energy[dominant_key] = get(total_energy, dominant_key, 0.0) + energy
        total_events[dominant_key] = get(total_events, dominant_key, 0) + num_events
    end

    # Compute mean energy per event (weighted average)
    model.params = Dict{Key,Float64}()

    for key in keys(total_energy)
        mean_energy = total_energy[key] / total_events[key]
        model.params[key] = mean_energy

        @debug "Learned mean energy per event" param_key = key mean_energy = round(
            mean_energy; digits=6
        ) total_events = total_events[key]
    end

    return nothing
end

"""
Build the training matrix A, vector B, and sorted keys from training data.
A[i,j] = count of key j in execution trace i
B[i] = measured energy of execution trace i
"""
function build_training_matrix(training_data::TrainingData)
    # Collect all unique instruction keys
    all_keys = Set{Key}()
    for execution_trace in training_data.execution_traces
        for execution_event in execution_trace
            push!(all_keys, execution_event.key)
        end
    end
    sorted_keys = sort(collect(all_keys))
    key_to_idx = Dict(key => i for (i, key) in enumerate(sorted_keys))

    num_traces = length(training_data.execution_traces)
    num_keys = length(sorted_keys)
    A = zeros(Float64, num_traces, num_keys)
    for (i, execution_trace) in enumerate(training_data.execution_traces)
        for execution_event in execution_trace
            j = key_to_idx[execution_event.key]
            A[i, j] += 1.0
        end
    end
    B = Vector{Float64}(training_data.energies)

    return A, B, sorted_keys
end

"""
Learn parameters from training data using least-squares inference algorithm.
Formulates the problem as finding x that minimizes ||Ax - B||^2 where:
- A[i,j] = count of key j in execution trace i
- B[i] = measured energy of execution trace i
- x[j] = mean energy per event for key j

Supports multiple least-squares algorithms:
- "least-squares": Standard unconstrained LS using A \\ B
- "least-squares-nnpivot": Non-negative LS using pivot method
- "least-squares-nnls": Non-negative LS using NNLS algorithm
- "least-squares-fnnls": Non-negative LS using Fast NNLS algorithm
"""
function learn_params_least_squares!(
    model::MeanModel, training_data::TrainingData, inference_algorithm::String
)
    @info "Building least-squares system" num_execution_traces = length(
        training_data.execution_traces
    ) algorithm = inference_algorithm

    A, B, sorted_keys = build_training_matrix(training_data)
    num_execution_traces, num_keys = size(A)
    @info "Least-squares system built" num_keys = num_keys

    # Solve least squares based on the specified algorithm
    @info "Solving least-squares system" algorithm = inference_algorithm
    x = if inference_algorithm == "least-squares"
        A \ B
    elseif inference_algorithm == "least-squares-nnpivot"
        nonneg_lsq(A, B; alg=:pivot)
    elseif inference_algorithm == "least-squares-nnls"
        nonneg_lsq(A, B; alg=:nnls)
    elseif inference_algorithm == "least-squares-fnnls"
        nonneg_lsq(A, B; alg=:fnnls)
    else
        error(
            "Unknown least-squares algorithm: $inference_algorithm. Must be one of: least-squares, least-squares-nnpivot, least-squares-nnls, least-squares-fnnls",
        )
    end

    # Store results in model.params
    model.params = Dict{Key,Float64}()
    for (i, key) in enumerate(sorted_keys)
        model.params[key] = x[i]

        @debug "Learned mean energy per instruction (least-squares)" param_key = key mean_energy = round(
            x[i]; digits=6
        )
    end

    # Calculate goodness-of-fit metrics
    B_pred = A * x  # Predicted energies
    residuals = B .- B_pred

    # R² (coefficient of determination)
    ss_tot = sum((B .- mean(B)) .^ 2)
    ss_res = sum(residuals .^ 2)
    r_squared = 1 - (ss_res / ss_tot)

    # RMSE (Root Mean Squared Error)
    rmse = sqrt(mean(residuals .^ 2))

    # MAE (Mean Absolute Error)
    mae = mean(abs.(residuals))

    # Max absolute error
    max_error = maximum(abs.(residuals))

    @info "Goodness of fit metrics" R² = round(r_squared; digits=6) RMSE = round(
        rmse; digits=3
    ) MAE = round(mae; digits=3) Max_Error = round(max_error; digits=3)

    # Debug dump: save matrices for analysis if environment variable is set
    debug_dump_path = get(ENV, "JULIA_LS_DEBUG_DUMP_PATH", nothing)
    if !isnothing(debug_dump_path)
        @info "Dumping least-squares debug data" path = debug_dump_path

        # Convert keys to string representations for JSON
        key_labels = [join(string.(k), "_") for k in sorted_keys]

        # Per-sample key counts for detailed analysis
        sample_key_counts = Vector{Dict{String,Int}}()
        for (i, execution_trace) in enumerate(training_data.execution_traces)
            counts = Dict{String,Int}()
            for execution_event in execution_trace
                key_str = join(string.(execution_event.key), "_")
                counts[key_str] = get(counts, key_str, 0) + 1
            end
            push!(sample_key_counts, counts)
        end

        # Compute per-sample relative error
        relative_errors = [(B[i] - B_pred[i]) / B[i] * 100 for i in 1:length(B)]

        # Column statistics: coverage (how many samples use each key)
        column_coverage = [count(A[:, j] .> 0) for j in 1:num_keys]

        # Compute matrix rank and condition number
        matrix_rank = rank(A)
        # Condition number (use SVD to avoid issues with non-square matrices)
        svd_result = svd(A)
        singular_values = svd_result.S
        # Condition number is ratio of largest to smallest non-zero singular value
        nonzero_sv = filter(s -> s > 1e-10, singular_values)
        condition_number = length(nonzero_sv) > 0 ? maximum(nonzero_sv) / minimum(nonzero_sv) : Inf

        debug_data = Dict{String,Any}(
            "metadata" => Dict(
                "num_samples" => num_execution_traces,
                "num_keys" => num_keys,
                "algorithm" => inference_algorithm,
                "r_squared" => r_squared,
                "rmse" => rmse,
                "mae" => mae,
                "max_error" => max_error,
                "matrix_rank" => matrix_rank,
                "condition_number" => condition_number,
            ),
            "key_labels" => key_labels,
            "solution_x" => x,
            "measured_B" => B,
            "predicted_B" => B_pred,
            "residuals" => residuals,
            "relative_errors_percent" => relative_errors,
            "column_coverage" => column_coverage,
            "sample_key_counts" => sample_key_counts,
            "singular_values" => singular_values,
            # Store A as a sparse representation to save space
            # Each entry is [row, col, value] for non-zero entries
            "matrix_A_sparse" => [
                [i, j, A[i, j]] for i in 1:num_execution_traces for
                j in 1:num_keys if A[i, j] > 0
            ],
            "matrix_A_shape" => [num_execution_traces, num_keys],
        )

        open(debug_dump_path, "w") do f
            JSON.print(f, debug_data, 2)
        end
        @info "Debug data saved successfully" path = debug_dump_path
    end

    return nothing
end

"""
Learn parameters using MAP estimation with log-normal prior.
Optimizes in log-space to enforce positivity of all energy parameters.

The objective is: minimize ||b - A*exp(y)||² + λ*||y - μ₀||²
where y = log(x), μ₀ is the prior mean in log-space, and λ controls prior strength.
"""
function learn_params_map!(model::MeanModel, training_data::TrainingData)
    A, B, sorted_keys = build_training_matrix(training_data)
    num_traces, num_keys = size(A)

    @info "MAP estimation" num_traces=num_traces num_keys=num_keys

    # Prior parameters
    mu0 = log(1.0)  # Prior median: ~1 nJ per instruction
    sigma0 = 2.0     # Wide prior (lets data dominate)

    # Estimate observation noise from data
    sigma_obs = median(B) * 0.05
    lambda = (sigma_obs / sigma0)^2

    @info "MAP prior parameters" prior_median_nJ=exp(mu0) sigma0=sigma0 sigma_obs=round(sigma_obs; digits=3) lambda=round(lambda; digits=6)

    # Initialize from clamped LS solution (fallback to prior if singular)
    y0 = try
        x_ls = A \ B
        log.(max.(x_ls, 1e-6))
    catch e
        if isa(e, LinearAlgebra.SingularException)
            @warn "Singular matrix in LS initialization, falling back to prior mean"
            fill(mu0, num_keys)
        else
            rethrow(e)
        end
    end

    # Objective: ||b - A*exp(y)||² + λ*||y - μ₀||²
    function objective(y)
        x = exp.(y)
        residuals = B .- A * x
        data_term = dot(residuals, residuals)
        prior_term = lambda * dot(y .- mu0, y .- mu0)
        return data_term + prior_term
    end

    # Gradient
    function gradient!(g, y)
        x = exp.(y)
        residuals = B .- A * x
        # d/dy_j of data_term: -2 * sum_i (residual_i * A[i,j] * x_j)
        # d/dy_j of prior_term: 2 * lambda * (y_j - mu0)
        g .= -2.0 .* (A' * residuals) .* x .+ 2.0 .* lambda .* (y .- mu0)
    end

    # Optimize
    result = Optim.optimize(objective, gradient!, y0, LBFGS(),
        Optim.Options(iterations=10000, g_tol=1e-8, show_trace=false))

    @info "MAP optimization" converged=Optim.converged(result) iterations=Optim.iterations(result) minimum=round(Optim.minimum(result); digits=3)

    y_opt = Optim.minimizer(result)
    x = exp.(y_opt)

    # Store results
    model.params = Dict{Key,Float64}()
    for (i, key) in enumerate(sorted_keys)
        model.params[key] = x[i]
        @debug "Learned energy (MAP)" param_key=key energy=round(x[i]; digits=6)
    end

    # Goodness-of-fit metrics (same as least-squares)
    B_pred = A * x
    residuals = B .- B_pred
    ss_tot = sum((B .- mean(B)).^2)
    ss_res = sum(residuals.^2)
    r_squared = 1 - (ss_res / ss_tot)
    rmse = sqrt(mean(residuals.^2))
    mae = mean(abs.(residuals))
    max_error = maximum(abs.(residuals))

    @info "Goodness of fit metrics" R²=round(r_squared; digits=6) RMSE=round(rmse; digits=3) MAE=round(mae; digits=3) Max_Error=round(max_error; digits=3)

    # All parameters should be positive
    min_energy = minimum(values(model.params))
    max_energy = maximum(values(model.params))
    @info "Parameter range" min_energy=round(min_energy; digits=6) max_energy=round(max_energy; digits=6) all_positive=(min_energy > 0)

    # Debug dump support (same env var as least-squares)
    debug_dump_path = get(ENV, "JULIA_LS_DEBUG_DUMP_PATH", nothing)
    if !isnothing(debug_dump_path)
        @info "Dumping MAP debug data" path=debug_dump_path

        key_labels = [join(string.(k), "_") for k in sorted_keys]

        sample_key_counts = Vector{Dict{String,Int}}()
        for (i, execution_trace) in enumerate(training_data.execution_traces)
            counts = Dict{String,Int}()
            for execution_event in execution_trace
                key_str = join(string.(execution_event.key), "_")
                counts[key_str] = get(counts, key_str, 0) + 1
            end
            push!(sample_key_counts, counts)
        end

        relative_errors = [(B[i] - B_pred[i]) / B[i] * 100 for i in 1:length(B)]
        column_coverage = [count(A[:, j] .> 0) for j in 1:num_keys]

        matrix_rank = rank(A)
        svd_result = svd(A)
        singular_values = svd_result.S
        nonzero_sv = filter(s -> s > 1e-10, singular_values)
        condition_number = length(nonzero_sv) > 0 ? maximum(nonzero_sv) / minimum(nonzero_sv) : Inf

        debug_data = Dict{String,Any}(
            "metadata" => Dict(
                "num_samples" => num_traces,
                "num_keys" => num_keys,
                "algorithm" => "map",
                "r_squared" => r_squared,
                "rmse" => rmse,
                "mae" => mae,
                "max_error" => max_error,
                "matrix_rank" => matrix_rank,
                "condition_number" => condition_number,
                "prior_mu0" => mu0,
                "prior_sigma0" => sigma0,
                "lambda" => lambda,
                "converged" => Optim.converged(result),
                "iterations" => Optim.iterations(result),
            ),
            "key_labels" => key_labels,
            "solution_x" => x,
            "measured_B" => B,
            "predicted_B" => B_pred,
            "residuals" => residuals,
            "relative_errors_percent" => relative_errors,
            "column_coverage" => column_coverage,
            "sample_key_counts" => sample_key_counts,
            "singular_values" => singular_values,
            # Store A as a sparse representation to save space
            # Each entry is [row, col, value] for non-zero entries
            "matrix_A_sparse" => [
                [i, j, A[i, j]] for i in 1:num_traces for
                j in 1:num_keys if A[i, j] > 0
            ],
            "matrix_A_shape" => [num_traces, num_keys],
        )

        open(debug_dump_path, "w") do f
            JSON.print(f, debug_data, 2)
        end
        @info "Debug data saved successfully" path=debug_dump_path
    end

    return nothing
end

"""
Learn parameters from training data
"""
function learn_params!(
    model::MeanModel, training_data::TrainingData, config::MeanTrainingConfig
)
    @info "Learning Mean model parameters" model_granularity = model.granularity num_programs = length(
        training_data.execution_traces
    ) inference_algorithm = config.inference_algorithm

    if config.inference_algorithm == "dominant-key"
        learn_params_dominant_key!(model, training_data)
    elseif config.inference_algorithm == "map"
        learn_params_map!(model, training_data)
    elseif startswith(config.inference_algorithm, "least-squares")
        learn_params_least_squares!(model, training_data, config.inference_algorithm)
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
Estimate energy by summing mean energies from learned parameters
"""
function estimate_energy_sum_means(
    model::MeanModel, execution_trace::ExecutionTrace
)::NamedTuple{
    (:mean, :std, :min, :max, :samples),
    Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
}
    total_energy = 0.0
    unknown_keys = Set{Key}()
    default_energy = 1.0  # Default 1nJ per instruction

    for execution_event in execution_trace
        key = execution_event.key

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
Estimate energy for an execution trace (deterministic - just sums mean energies)
"""
function estimate_energy(
    model::MeanModel, execution_trace::ExecutionTrace, config::MeanEstimationConfig
)::NamedTuple{
    (:mean, :std, :min, :max, :samples),
    Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
}
    @info "Estimating energy with Mean model" model_granularity = model.granularity num_events = length(
        execution_trace
    )

    result = estimate_energy_sum_means(model, execution_trace)

    @info "Energy estimation complete" total_energy = round(result.mean; digits=3)
    return result
end
