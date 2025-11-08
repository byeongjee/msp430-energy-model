# model.jl - Abstract Model interface for energy estimation

"""
Abstract base type for all energy models.

All models must implement the following interface:
- load_params!(model::Model, filename::String)
- learn_params!(model::Model, training_data::TrainingData, config::ModelConfig)
- save_params(model::Model, filename::String)
- estimate_energy(model::Model, program::Vector{Instruction}, config::ModelConfig)
"""
abstract type Model end

"""
Abstract base type for model configurations
"""
abstract type ModelConfig end

"""
Load parameters from a file into the model.

# Arguments
- `model::Model`: The model to load parameters into
- `filename::String`: Path to the parameters file
"""
function load_params! end

"""
Learn parameters from training data.

# Arguments
- `model::Model`: The model to train
- `training_data::TrainingData`: Training data containing programs and energy measurements
- `config::ModelConfig`: Configuration for learning (e.g., number of samples, inference algorithm)

# Returns
Nothing (modifies model in-place)
"""
function learn_params! end

"""
Save model parameters to a file.

# Arguments
- `model::Model`: The model whose parameters to save
- `filename::String`: Path to save the parameters

# Returns
Nothing
"""
function save_params end

"""
Estimate energy consumption for a program.

# Arguments
- `model::Model`: The trained model
- `program::Vector{Instruction}`: Sequence of instructions
- `config::ModelConfig`: Configuration for estimation (e.g., number of samples)

# Returns
Energy statistics (mean, std, min, max, samples) as a NamedTuple
"""
function estimate_energy end
