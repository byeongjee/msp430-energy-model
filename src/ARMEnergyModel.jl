# ARMEnergyModel.jl - Main module file

module ARMEnergyModel

using Gen
using Distributions
using Statistics
using Plots
using StatsPlots

# Include all components
include("types.jl")
include("energy_params.jl")
include("machine_state.jl")
include("interpreter.jl")
include("parser.jl")
include("analysis.jl")
include("visualization.jl")
include("inference.jl")

# Export main functions
export ARMInstruction, MachineState, EnergyStats
export parse_arm_assembly, parse_arm_file
export interpret_arm_program, sample_instruction_energy
export analyze_energy_distribution, analyze_instruction_energies, compare_programs
export plot_instruction_energy_distributions, plot_program_energy_distribution
export plot_instruction_breakdown, plot_cumulative_energy, comprehensive_energy_analysis
export register_instruction!, get_energy_params
export TrainingData, learn_parameters, learn_parameters_mle, predict_energy, evaluate_parameters

end # module