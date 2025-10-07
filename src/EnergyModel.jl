# EnergyModel.jl - Main module file for energy modeling

module EnergyModel

# Core dependencies
using Gen
using Distributions
using Statistics

# Include all source files
include("types.jl")
include("energy_params.jl")
include("machine_state.jl")
include("parser.jl")
include("probabilistic_model_builder.jl")
include("inference.jl")

# Export main types
export Instruction
export MachineState
export EnergyStats
export TrainingData

# Export energy parameter functions
export get_energy_params
export register_instruction!

# Export machine state functions
export execute_instruction!

# Export parsing functions
export parse_assembly, parse_line, parse_file
export parse_operands
export validate_instruction, get_instruction_format

# Export interpreter functions
export sample_instruction_energy
export interpret_program
export custom_energy_model

# Export inference functions
export learn_parameters, learn_parameters_mle
export predict_energy, evaluate_parameters

# Export utility functions
export reg_num_to_symbol, reg_symbol_to_num

end # module
