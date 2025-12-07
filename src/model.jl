# model.jl - Model module with abstract interface and implementations

module Model

using ..Types: Trace

export AbstractModel, TrainingConfig, EstimationConfig
export load_params!, learn_params!, save_params, estimate_energy
export create_model, create_training_config, create_estimation_config

"""
Abstract base type for all energy models.

All models must implement the following interface:
- load_params!(model::AbstractModel, filename::String)
- learn_params!(model::AbstractModel, training_data::TrainingData, config::TrainingConfig)
- save_params(model::AbstractModel, filename::String)
- estimate_energy(model::AbstractModel, program::Trace, config::EstimationConfig)
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
Estimate energy consumption for a program.

# Arguments
- `model::AbstractModel`: The trained model
- `program::Trace`: Sequence of traced instructions
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

# Include specific model constructors
include("models/gamma_per_instruction.jl")
include("models/gamma_per_addressing_mode.jl")
include("models/gamma_per_addressing_mode_constant.jl")
include("models/mean_per_instruction.jl")
include("models/mean_per_addressing_mode.jl")
include("models/mean_per_addressing_mode_constant.jl")
include("models/mean_per_pair_addressing_mode_constant.jl")

"""
Create a model instance based on the model name
"""
function create_model(model_str::String)::AbstractModel
    if model_str == "gamma_per_instruction"
        return GammaPerInstruction()
    elseif model_str == "gamma_per_addressing_mode"
        return GammaPerAddressingMode()
    elseif model_str == "gamma_per_addressing_mode_constant"
        return GammaPerAddressingModeConstant()
    elseif model_str == "mean_per_instruction"
        return MeanPerInstruction()
    elseif model_str == "mean_per_addressing_mode"
        return MeanPerAddressingMode()
    elseif model_str == "mean_per_addressing_mode_constant"
        return MeanPerAddressingModeConstant()
    elseif model_str == "mean_per_pair_addressing_mode_constant"
        return MeanPerPairAddressingModeConstant()
    else
        error("Unknown model type: $model_str. Must be one of: gamma_per_instruction, gamma_per_addressing_mode, gamma_per_addressing_mode_constant, mean_per_instruction, mean_per_addressing_mode, mean_per_addressing_mode_constant, mean_per_pair_addressing_mode_constant")
    end
end

"""
Create training configuration based on model type
"""
function create_training_config(model::AbstractModel, n_samples::Int, inference_algorithm::String)::TrainingConfig
    if isa(model, GammaModel)
        return GammaTrainingConfig(n_samples, inference_algorithm)
    elseif isa(model, MeanModel)
        return MeanTrainingConfig(inference_algorithm)
    elseif isa(model, MeanPairModel)
        return MeanTrainingConfig(inference_algorithm)
    else
        error("Unknown model type: $(typeof(model))")
    end
end

"""
Create estimation configuration based on model type
"""
function create_estimation_config(model::AbstractModel, n_samples::Int)::EstimationConfig
    if isa(model, GammaModel)
        return GammaEstimationConfig(n_samples)
    elseif isa(model, MeanModel)
        return MeanEstimationConfig()
    elseif isa(model, MeanPairModel)
        return MeanEstimationConfig()
    else
        error("Unknown model type: $(typeof(model))")
    end
end

end # module Model
