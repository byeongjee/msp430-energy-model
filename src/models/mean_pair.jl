# mean_pair.jl - Generic Mean-based energy model for instruction pairs

using JSON
using Statistics
using LinearAlgebra
using NonNegLeastSquares

"""
Generic Mean-based model for instruction pairs.
Uses simple mean energy per consecutive instruction pair based on specified granularity.
"""
mutable struct MeanPairModel <: AbstractModel
    params::Dict{Tuple{ParamKey,ParamKey},Float64}
    granularity::ModelGranularity
    model_type::String

    function MeanPairModel(granularity::ModelGranularity, model_type::String)
        new(Dict{Tuple{ParamKey,ParamKey},Float64}(), granularity, model_type)
    end
end


"""
Load parameters from JSON file for MeanPair model
"""
function load_params!(model::MeanPairModel, filename::String)
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

    # Convert string keys to tuple pair keys
    model.params = Dict{Tuple{ParamKey,ParamKey},Float64}()
    for (key_str, mean_energy) in params_dict
        # Split by " -> " to separate the two instruction keys
        parts = split(key_str, " -> ")
        if length(parts) != 2
            error("Invalid pair key format: $key_str")
        end

        # Parse each instruction key
        key1_parts = split(parts[1], "_")
        key2_parts = split(parts[2], "_")

        param_key1 = tuple(
            [
                let parsed = tryparse(Int, p)
                    parsed !== nothing ? parsed : Symbol(p)
                end for p in key1_parts
            ]...
        )

        param_key2 = tuple(
            [
                let parsed = tryparse(Int, p)
                    parsed !== nothing ? parsed : Symbol(p)
                end for p in key2_parts
            ]...
        )

        model.params[(param_key1, param_key2)] = Float64(mean_energy)
    end

    @info "Loaded MeanPair model parameters" model_type = model.model_type num_parameters = length(
        model.params
    )
    return nothing
end

"""
Learn parameters from training data using least-squares inference algorithm.
Formulates the problem as finding x that minimizes ||Ax - B||^2 where:
- A[i,j] = count of pair j in program i
- B[i] = measured energy of program i
- x[j] = mean energy per pair for pair j
"""
function learn_params_least_squares!(model::MeanPairModel, training_data::TrainingData)
    # Collect all unique instruction pairs
    all_pairs = Set{Tuple{ParamKey,ParamKey}}()
    for program in training_data.programs
        if length(program) < 2
            continue
        end
        for i in 1:(length(program)-1)
            key1 = get_instruction_key(program[i], model.granularity)
            key2 = get_instruction_key(program[i+1], model.granularity)
            push!(all_pairs, (key1, key2))
        end
    end

    # Sort pairs lexicographically for consistent ordering
    sorted_pairs = sort(collect(all_pairs))
    pair_to_idx = Dict(pair => i for (i, pair) in enumerate(sorted_pairs))

    @info "Building least-squares system for pairs" num_programs = length(training_data.programs) num_pairs = length(sorted_pairs)

    # Build matrix A where A[i,j] = count of pair j in program i
    num_programs = length(training_data.programs)
    num_pairs = length(sorted_pairs)
    A = zeros(Float64, num_programs, num_pairs)

    for (i, program) in enumerate(training_data.programs)
        if length(program) < 2
            continue
        end
        for k in 1:(length(program)-1)
            key1 = get_instruction_key(program[k], model.granularity)
            key2 = get_instruction_key(program[k+1], model.granularity)
            pair_key = (key1, key2)
            j = pair_to_idx[pair_key]
            A[i, j] += 1.0
        end
    end

    # Build vector B with measured energies
    B = Vector{Float64}(training_data.energies)

    # Solve non-negative least squares: minimize ||Ax - B||^2 subject to x >= 0
    # Using :fnnls (Fast NNLS) algorithm which is much faster than default :nnls
    @info "Solving non-negative least-squares system for pairs (using Fast NNLS algorithm)"
    x = nonneg_lsq(A, B; alg=:fnnls)

    # Store results in model.params
    model.params = Dict{Tuple{ParamKey,ParamKey},Float64}()
    for (i, pair_key) in enumerate(sorted_pairs)
        model.params[pair_key] = x[i]

        @debug "Learned mean energy per pair (least-squares)" pair_key = pair_key mean_energy = round(
            x[i]; digits=6
        )
    end

    # Calculate goodness-of-fit metrics
    B_pred = A * x  # Predicted energies
    residuals = B .- B_pred

    # R² (coefficient of determination)
    ss_tot = sum((B .- mean(B)).^2)
    ss_res = sum(residuals.^2)
    r_squared = 1 - (ss_res / ss_tot)

    # RMSE (Root Mean Squared Error)
    rmse = sqrt(mean(residuals.^2))

    # MAE (Mean Absolute Error)
    mae = mean(abs.(residuals))

    # Max absolute error
    max_error = maximum(abs.(residuals))

    @info "Goodness of fit metrics" R²=round(r_squared, digits=6) RMSE=round(rmse, digits=3) MAE=round(mae, digits=3) Max_Error=round(max_error, digits=3)

    return nothing
end

"""
Learn parameters from training data
"""
function learn_params!(model::MeanPairModel, training_data::TrainingData, config::MeanTrainingConfig)
    @info "Learning MeanPair model parameters" granularity = model.granularity num_programs = length(
        training_data.programs
    ) inference_algorithm = config.inference_algorithm

    if config.inference_algorithm == "least-squares"
        learn_params_least_squares!(model, training_data)
    else
        error("Unknown inference algorithm for MeanPair model: $(config.inference_algorithm)")
    end

    @info "Learned MeanPair model parameters" num_parameters = length(model.params)
    return nothing
end

"""
Save parameters to JSON file
"""
function save_params(model::MeanPairModel, filename::String)
    # Convert tuple pair keys to string keys
    params_dict = Dict{String,Float64}()
    for ((key1, key2), mean_energy) in model.params
        key1_str = join(string.(key1), "_")
        key2_str = join(string.(key2), "_")
        key_str = key1_str * " -> " * key2_str
        params_dict[key_str] = mean_energy
    end

    output_dict = Dict{String,Any}("model" => model.model_type, "parameters" => params_dict)

    @info "Saving MeanPair model parameters" path = filename model_type = model.model_type
    open(filename, "w") do f
        JSON.print(f, output_dict, 4)
    end
    @info "Parameters saved successfully"
    return nothing
end

"""
Estimate energy by summing mean energies for consecutive pairs
"""
function estimate_energy_sum_pair_means(
    model::MeanPairModel, program::Vector{Instruction}
)::NamedTuple{
    (:mean, :std, :min, :max, :samples),
    Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
}
    if length(program) < 2
        @warn "Program has less than 2 instructions, cannot estimate pair-based energy"
        return (mean=0.0, std=0.0, min=0.0, max=0.0, samples=[0.0])
    end

    total_energy = 0.0
    unknown_pairs = Set{Tuple{ParamKey,ParamKey}}()
    default_energy = 1.0  # Default 1nJ per pair

    for i in 1:(length(program)-1)
        key1 = get_instruction_key(program[i], model.granularity)
        key2 = get_instruction_key(program[i+1], model.granularity)
        pair_key = (key1, key2)

        if haskey(model.params, pair_key)
            total_energy += model.params[pair_key]
        else
            # Use default if not found
            push!(unknown_pairs, pair_key)
            total_energy += default_energy
        end
    end

    if !isempty(unknown_pairs)
        unknown_strs = [
            join(string.(k1), "_") * " -> " * join(string.(k2), "_")
            for (k1, k2) in unknown_pairs
        ]
        @warn "Unknown instruction pairs. Using default 1.0nJ" pairs = join(
            sort(unknown_strs), ", "
        )
    end

    # MeanPair model is deterministic, so std=0 and min=max=mean
    return (
        mean=total_energy,
        std=0.0,
        min=total_energy,
        max=total_energy,
        samples=[total_energy],
    )
end

"""
Estimate energy for a program (deterministic - just sums mean energies for pairs)
"""
function estimate_energy(
    model::MeanPairModel, program::Vector{Instruction}, config::MeanEstimationConfig
)::NamedTuple{
    (:mean, :std, :min, :max, :samples),
    Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
}
    @info "Estimating energy with MeanPair model" granularity = model.granularity num_instructions = length(
        program
    ) num_pairs = max(0, length(program) - 1)

    result = estimate_energy_sum_pair_means(model, program)

    @info "Energy estimation complete" total_energy = round(result.mean; digits=3)
    return result
end
