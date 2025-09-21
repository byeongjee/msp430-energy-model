# MSP430EnergyModel.jl - Main module file for MSP430 energy modeling

module MSP430EnergyModel

# Core dependencies
using Gen
using Distributions
using Statistics

# Include all source files
include("types.jl")
include("energy_params.jl")
include("machine_state.jl")
include("msp430_machine_state.jl")
include("parser.jl")
include("msp430_parser.jl")
include("interpreter.jl")
include("inference.jl")

# Export main types
export ARMInstruction, MSP430Instruction
export AbstractInstruction, ARMInstructionWrapper, MSP430InstructionWrapper
export MachineState, MSP430MachineState
export EnergyStats
export TrainingData, MSP430TrainingData, UnifiedTrainingData

# Export energy parameter functions
export get_energy_params, get_arm_energy_params, get_msp430_energy_params
export get_energy_params_for_architecture
export register_instruction!, register_msp430_defaults!

# Export machine state functions
export execute_instruction!, execute_msp430_instruction!

# Export parsing functions
export parse_arm_assembly, parse_arm_line, parse_arm_file
export parse_msp430_assembly, parse_msp430_line, parse_msp430_file
export parse_operands, parse_msp430_operands
export validate_msp430_instruction, get_instruction_format

# Export interpreter functions
export sample_instruction_energy
export interpret_arm_program, interpret_msp430_program, interpret_program
export custom_arm_energy_model, custom_msp430_energy_model

# Export inference functions
export learn_parameters, learn_parameters_mle, learn_msp430_parameters, learn_msp430_parameters_mle
export predict_msp430_energy, evaluate_msp430_parameters
export predict_energy, predict_msp430_energy, predict_energy_unified
export evaluate_parameters

# Export utility functions
export reg_num_to_symbol, reg_symbol_to_num

# Initialize MSP430 energy parameters
function __init__()
    register_msp430_defaults!()
end

end # module