# model.jl - Model module with abstract interface and implementations

module Model

export AbstractModel, ModelConfig
export load_params!, learn_params!, save_params, estimate_energy
export create_model, create_model_config

"""
Abstract base type for all energy models.

All models must implement the following interface:
- load_params!(model::AbstractModel, filename::String)
- learn_params!(model::AbstractModel, training_data::TrainingData, config::ModelConfig)
- save_params(model::AbstractModel, filename::String)
- estimate_energy(model::AbstractModel, program::Vector{Instruction}, config::ModelConfig)
"""
abstract type AbstractModel end

"""
Abstract base type for model configurations
"""
abstract type ModelConfig end

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
- `config::ModelConfig`: Configuration for learning (e.g., number of samples, inference algorithm)

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
- `program::Vector{Instruction}`: Sequence of instructions
- `config::ModelConfig`: Configuration for estimation (e.g., number of samples)

# Returns
Energy statistics (mean, std, min, max, samples) as a NamedTuple
"""
function estimate_energy end

# Include common model utilities (only once!)
include("model_common.jl")

# Include base model implementations (only once!)
include("models/gamma.jl")
include("models/mean.jl")

# Include specific model constructors
include("models/gamma_per_instruction.jl")
include("models/gamma_per_addressing_mode.jl")
include("models/mean_per_instruction.jl")
include("models/mean_per_addressing_mode.jl")

"""
Create a model instance based on the model name
"""
function create_model(model_str::String)::AbstractModel
    if model_str == "gamma_per_instruction"
        return GammaPerInstruction()
    elseif model_str == "gamma_per_addressing_mode"
        return GammaPerAddressingMode()
    elseif model_str == "mean_per_instruction"
        return MeanPerInstruction()
    elseif model_str == "mean_per_addressing_mode"
        return MeanPerAddressingMode()
    else
        error("Unknown model type: $model_str. Must be one of: gamma_per_instruction, gamma_per_addressing_mode, mean_per_instruction, mean_per_addressing_mode")
    end
end

"""
Create model configuration based on model type
"""
function create_model_config(model::AbstractModel, n_samples::Int, inference_algorithm::String)::ModelConfig
    if isa(model, GammaModel)
        return GammaConfig(n_samples=n_samples, inference_algorithm=inference_algorithm)
    elseif isa(model, MeanModel)
        return MeanConfig()
    else
        error("Unknown model type: $(typeof(model))")
    end
end

end # module Model
