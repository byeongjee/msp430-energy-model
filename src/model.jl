# model.jl - Model module with abstract interface and implementations

module Model

using ..Types: ExecutionTrace

export AbstractModel, TrainingConfig, EstimationConfig
export load_params!, learn_params!, save_params, estimate_energy
export create_model, create_training_config, create_estimation_config

"""
Abstract base type for all energy models.

All models must implement the following interface:
- load_params!(model::AbstractModel, filename::String)
- learn_params!(model::AbstractModel, training_data::TrainingData, config::TrainingConfig)
- save_params(model::AbstractModel, filename::String)
- estimate_energy(model::AbstractModel, execution_trace::ExecutionTrace, config::EstimationConfig)
"""
abstract type AbstractModel end

"""
Abstract base type for training configurations
"""
abstract type TrainingConfig end

"""
Abstract base type for estimation configurations
"""
abstract type EstimationConfig end

"""
Load parameters from a file into the model.

# Arguments
- `model::AbstractModel`: The model to load parameters into
- `filename::String`: Path to the parameters file
"""
function load_params! end

"""
Learn parameters from training data.

# Arguments
- `model::AbstractModel`: The model to train
- `training_data::TrainingData`: Training data containing programs and energy measurements
- `config::TrainingConfig`: Configuration for training (e.g., inference algorithm)

# Returns
Nothing (modifies model in-place)
"""
function learn_params! end

"""
Save model parameters to a file.

# Arguments
- `model::AbstractModel`: The model whose parameters to save
- `filename::String`: Path to save the parameters

# Returns
Nothing
"""
function save_params end

"""
Estimate energy consumption for an execution trace.

# Arguments
- `model::AbstractModel`: The trained model
- `execution_trace::ExecutionTrace`: Sequence of execution events
- `config::EstimationConfig`: Configuration for estimation (e.g., number of samples for probabilistic models)

# Returns
Energy statistics (mean, std, min, max, samples) as a NamedTuple
"""
function estimate_energy end

# Include common model utilities (only once!)
include("model_common.jl")

# Include base model implementations (only once!)
include("models/gamma.jl")
include("models/mean.jl")
include("models/mean_pair.jl")

# ============================================================================
# Model Factory Functions
# ============================================================================

# Gamma models
"""Gamma distribution model with per-instruction (opcode) granularity."""
GammaPerInstruction() = GammaModel(PerOpcode, "gamma_per_instruction")

"""Gamma distribution model with per-addressing-mode granularity."""
GammaPerAddressingMode() = GammaModel(PerAddressingMode, "gamma_per_addressing_mode")

"""Gamma distribution model with per-addressing-mode-constant granularity."""
GammaPerAddressingModeConstant() =
    GammaModel(PerAddressingModeConstant, "gamma_per_addressing_mode_constant")

# Mean models (single instruction)
"""Mean-based model with per-instruction (opcode) granularity."""
MeanPerInstruction() = MeanModel(PerOpcode, "mean_per_instruction")

"""Mean-based model with per-addressing-mode granularity."""
MeanPerAddressingMode() = MeanModel(PerAddressingMode, "mean_per_addressing_mode")

"""Mean-based model with per-addressing-mode-constant granularity."""
MeanPerAddressingModeConstant() =
    MeanModel(PerAddressingModeConstant, "mean_per_addressing_mode_constant")

# Mean models with memory access tracking
"""Mean-based model with per-instruction granularity and memory access event tracking."""
MeanPerInstructionWithMemAccess() =
    MeanModel(PerOpcodeWithMemAccess, "mean_per_instruction_with_mem_access")

"""Mean-based model with per-addressing-mode granularity and memory access event tracking."""
MeanPerAddressingModeWithMemAccess() =
    MeanModel(PerAddressingModeWithMemAccess, "mean_per_addressing_mode_with_mem_access")

"""Mean-based model with per-addressing-mode-constant granularity and memory access event tracking."""
MeanPerAddressingModeConstantWithMemAccess() = MeanModel(
    PerAddressingModeConstantWithMemAccess,
    "mean_per_addressing_mode_constant_with_mem_access",
)

# Mean pair model
"""Mean-based model for consecutive instruction pairs with per-addressing-mode-constant granularity."""
MeanPerPairAddressingModeConstant() =
    MeanPairModel(PerAddressingModeConstant, "mean_per_pair_addressing_mode_constant")

# Model registry: maps model name strings to constructor functions
const MODEL_REGISTRY = Dict{String,Function}(
    "gamma_per_instruction" => GammaPerInstruction,
    "gamma_per_addressing_mode" => GammaPerAddressingMode,
    "gamma_per_addressing_mode_constant" => GammaPerAddressingModeConstant,
    "mean_per_instruction" => MeanPerInstruction,
    "mean_per_addressing_mode" => MeanPerAddressingMode,
    "mean_per_addressing_mode_constant" => MeanPerAddressingModeConstant,
    "mean_per_instruction_with_mem_access" => MeanPerInstructionWithMemAccess,
    "mean_per_addressing_mode_with_mem_access" => MeanPerAddressingModeWithMemAccess,
    "mean_per_addressing_mode_constant_with_mem_access" =>
        MeanPerAddressingModeConstantWithMemAccess,
    "mean_per_pair_addressing_mode_constant" => MeanPerPairAddressingModeConstant,
)

"""
Create a model instance based on the model name.

Available models: $(join(sort(collect(keys(MODEL_REGISTRY))), ", "))
"""
function create_model(model_str::String)::AbstractModel
    if haskey(MODEL_REGISTRY, model_str)
        return MODEL_REGISTRY[model_str]()
    else
        available_models = join(sort(collect(keys(MODEL_REGISTRY))), ", ")
        error("Unknown model type: $model_str. Must be one of: $available_models")
    end
end

"""
Create training configuration for Gamma models.
"""
function create_training_config(
    model::GammaModel, n_samples::Int, inference_algorithm::String
)::TrainingConfig
    return GammaTrainingConfig(n_samples, inference_algorithm)
end

"""
Create training configuration for Mean models.
"""
function create_training_config(
    model::MeanModel, n_samples::Int, inference_algorithm::String
)::TrainingConfig
    return MeanTrainingConfig(inference_algorithm)
end

"""
Create training configuration for MeanPair models.
"""
function create_training_config(
    model::MeanPairModel, n_samples::Int, inference_algorithm::String
)::TrainingConfig
    return MeanTrainingConfig(inference_algorithm)
end

"""
Create estimation configuration for Gamma models.
"""
function create_estimation_config(model::GammaModel, n_samples::Int)::EstimationConfig
    return GammaEstimationConfig(n_samples)
end

"""
Create estimation configuration for Mean models.
"""
function create_estimation_config(model::MeanModel, n_samples::Int)::EstimationConfig
    return MeanEstimationConfig()
end

"""
Create estimation configuration for MeanPair models.
"""
function create_estimation_config(model::MeanPairModel, n_samples::Int)::EstimationConfig
    return MeanEstimationConfig()
end

end # module Model
