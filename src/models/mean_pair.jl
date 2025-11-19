# mean_pair.jl - Generic Mean-based energy model for instruction pairs

using JSON
using Statistics
using LinearAlgebra
using NonNegLeastSquares

"""
Helper function to normalize pair to unordered form (canonical order).
Returns pairs in lexicographically sorted order so (A,B) and (B,A) map to same pair.
"""
function normalize_pair(key1::ParamKey, key2::ParamKey)::Tuple{ParamKey,ParamKey}
    # Sort lexicographically to create canonical unordered pair
    if key1 <= key2
        return (key1, key2)
    else
        return (key2, key1)
    end
end

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

Supports multiple least-squares algorithms:
- "least-squares": Standard unconstrained LS using A \\ B
- "least-squares-nnpivot": Non-negative LS using pivot method
- "least-squares-nnls": Non-negative LS using NNLS algorithm
- "least-squares-fnnls": Non-negative LS using Fast NNLS algorithm
"""
function learn_params_least_squares!(model::MeanPairModel, training_data::TrainingData, inference_algorithm::String)
    # Collect all unique instruction pairs (as unordered pairs)
    all_pairs = Set{Tuple{ParamKey,ParamKey}}()
    for program in training_data.programs
        if length(program) < 2
            continue
        end
        for i in 1:(length(program)-1)
            key1 = get_instruction_key(program[i], model.granularity)
            key2 = get_instruction_key(program[i+1], model.granularity)
            # Normalize to unordered pair
            unordered_pair = normalize_pair(key1, key2)
            push!(all_pairs, unordered_pair)
        end
    end

    # Sort pairs lexicographically for consistent ordering
    sorted_pairs = sort(collect(all_pairs))
    pair_to_idx = Dict(pair => i for (i, pair) in enumerate(sorted_pairs))

    # Analyze which opcodes appear in the data
    all_opcodes = Set{Symbol}()
    for (key1, key2) in all_pairs
        push!(all_opcodes, key1[1])
        push!(all_opcodes, key2[1])
    end
    expected_opcodes = Set([:add, :mov, :cmp, :inc, :rlam, :jmp, :jge, :jl])
    unexpected_opcodes = setdiff(all_opcodes, expected_opcodes)

    if !isempty(unexpected_opcodes)
        @warn "Found unexpected opcodes in training data (compiler-generated):" opcodes=sort(collect(unexpected_opcodes))
    end

    @info "Building least-squares system for unordered pairs (before filtering)" num_programs = length(training_data.programs) num_pairs = length(sorted_pairs) algorithm = inference_algorithm total_opcodes = length(all_opcodes) unexpected_opcodes_count = length(unexpected_opcodes)

    # Build initial matrix A where A[i,j] = count of pair j in program i
    num_programs = length(training_data.programs)
    num_pairs = length(sorted_pairs)
    A_full = zeros(Float64, num_programs, num_pairs)

    for (i, program) in enumerate(training_data.programs)
        if length(program) < 2
            continue
        end
        for k in 1:(length(program)-1)
            key1 = get_instruction_key(program[k], model.granularity)
            key2 = get_instruction_key(program[k+1], model.granularity)
            # Normalize to unordered pair
            pair_key = normalize_pair(key1, key2)
            j = pair_to_idx[pair_key]
            A_full[i, j] += 1.0
        end
    end

    # Filter out pairs that include loop/auxiliary instructions
    EXCLUDED_OPCODES = Set([:br, :mova, :nop, :rla])  # Hardcoded: loop-related, not main benchmark instructions

    pairs_to_keep_idx = Int[]
    for (idx, (key1, key2)) in enumerate(sorted_pairs)
        opcode1 = key1[1]
        opcode2 = key2[1]
        # Keep pair only if neither opcode is in the excluded list
        if !(opcode1 in EXCLUDED_OPCODES || opcode2 in EXCLUDED_OPCODES)
            push!(pairs_to_keep_idx, idx)
        end
    end

    @info "Filtering pairs with excluded opcodes" excluded_opcodes=sort(collect(EXCLUDED_OPCODES)) pairs_before=length(sorted_pairs) pairs_after=length(pairs_to_keep_idx) pairs_removed=length(sorted_pairs)-length(pairs_to_keep_idx)

    # Create filtered matrix and pair list
    A = A_full[:, pairs_to_keep_idx]
    filtered_pairs = sorted_pairs[pairs_to_keep_idx]

    @info "Building least-squares system for unordered pairs (after filtering)" num_programs = num_programs num_pairs = length(filtered_pairs) algorithm = inference_algorithm

    # Build vector B with measured energies
    B = Vector{Float64}(training_data.energies)

    # Solve least squares based on the specified algorithm
    @info "Solving least-squares system for pairs" algorithm = inference_algorithm
    x = if inference_algorithm == "least-squares"
        A \ B
    elseif inference_algorithm == "least-squares-nnpivot"
        nonneg_lsq(A, B; alg=:pivot)
    elseif inference_algorithm == "least-squares-nnls"
        nonneg_lsq(A, B; alg=:nnls)
    elseif inference_algorithm == "least-squares-fnnls"
        nonneg_lsq(A, B; alg=:fnnls)
    else
        error("Unknown least-squares algorithm: $inference_algorithm. Must be one of: least-squares, least-squares-nnpivot, least-squares-nnls, least-squares-fnnls")
    end

    # Store results in model.params
    model.params = Dict{Tuple{ParamKey,ParamKey},Float64}()
    for (i, pair_key) in enumerate(filtered_pairs)
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

    if startswith(config.inference_algorithm, "least-squares")
        learn_params_least_squares!(model, training_data, config.inference_algorithm)
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
        # Normalize to unordered pair
        pair_key = normalize_pair(key1, key2)

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
