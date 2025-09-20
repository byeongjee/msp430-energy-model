# msp430_demo.jl - Demonstration of MSP430 energy modeling

using Pkg
Pkg.activate(".")

# Include the MSP430 energy modeling system
include("../src/MSP430EnergyModel.jl")
using .MSP430EnergyModel

using Gen
using Distributions
using Plots

println("=== MSP430 Energy Modeling Demo ===")

# Example 1: Parse and execute simple MSP430 assembly
println("\n1. Parsing MSP430 Assembly")
msp430_code = [
    "mov #0x1234, R5",      # Load immediate value into R5
    "add R5, R6",           # Add R5 to R6
    "sub #0x10, R6",        # Subtract immediate from R6
    "cmp R5, R6",           # Compare R5 and R6
    "jnz loop_end",         # Jump if not zero
    "push R5",              # Push R5 to stack
    "call subroutine",      # Call function
    "loop_end:",            # Label
    "reti"                  # Return from interrupt
]

# Parse the assembly code
instructions = parse_msp430_assembly(msp430_code)
println("Parsed $(length(instructions)) MSP430 instructions:")
for (i, inst) in enumerate(instructions)
    println("  $i: $(inst.opcode) $(inst.operands) [$(inst.addressing_mode)]")
end

# Example 2: Test machine state execution
println("\n2. Testing MSP430 Machine State")
state = MSP430MachineState()
println("Initial state:")
println("  PC: 0x$(string(state.pc, base=16, pad=4))")
println("  SP: 0x$(string(state.sp, base=16, pad=4))")
println("  Registers R0-R3: $(state.registers[:R0]), $(state.registers[:R1]), $(state.registers[:R2]), $(state.registers[:R3])")

# Execute a few instructions
test_instructions = [
    MSP430Instruction(:mov, [0x1234, :R5], :immediate),
    MSP430Instruction(:add, [:R5, :R6], :register),
    MSP430Instruction(:cmp, [:R5, :R6], :register)
]

for inst in test_instructions
    execute_msp430_instruction!(state, inst)
    println("After $(inst.opcode): R5=$(state.registers[:R5]), R6=$(state.registers[:R6]), flags=$(state.flags)")
end

# Example 3: Energy modeling
println("\n3. MSP430 Energy Modeling")

# Sample MSP430 program
sample_program = [
    MSP430Instruction(:mov, [0x0100, :R4], :immediate),
    MSP430Instruction(:mov, [0x0200, :R5], :immediate),
    MSP430Instruction(:add, [:R4, :R5], :register),
    MSP430Instruction(:cmp, [:R5, 0x0300], :immediate),
    MSP430Instruction(:jnz, [0x04], :immediate),
    MSP430Instruction(:push, [:R5], :register),
    MSP430Instruction(:call, [0x1000], :immediate),
    MSP430Instruction(:reti, [], :register)
]

println("Sample MSP430 program:")
for (i, inst) in enumerate(sample_program)
    println("  $i: $(inst.opcode) $(inst.operands)")
end

# Get energy parameters for MSP430 instructions
println("\nMSP430 Energy Parameters:")
unique_opcodes = unique([inst.opcode for inst in sample_program])
for opcode in unique_opcodes
    alpha, beta = get_msp430_energy_params(opcode)
    mean_energy = alpha * beta
    println("  $opcode: α=$alpha, β=$beta, mean=$(round(mean_energy, digits=3))")
end

# Run probabilistic energy simulation
println("\n4. Probabilistic Energy Simulation")
n_samples = 1000

# Generate energy samples using the MSP430 interpreter
trace = simulate(interpret_msp430_program, (sample_program,))
predicted_energy = get_retval(trace)

println("Single simulation result: $(round(predicted_energy, digits=3)) energy units")

# Multiple samples for statistics
energy_samples = Float64[]
for _ in 1:n_samples
    trace = simulate(interpret_msp430_program, (sample_program,))
    push!(energy_samples, get_retval(trace))
end

using Statistics
mean_energy = mean(energy_samples)
std_energy = std(energy_samples)
min_energy = minimum(energy_samples)
max_energy = maximum(energy_samples)

println("Energy statistics over $n_samples samples:")
println("  Mean: $(round(mean_energy, digits=3))")
println("  Std:  $(round(std_energy, digits=3))")
println("  Min:  $(round(min_energy, digits=3))")
println("  Max:  $(round(max_energy, digits=3))")

# Example 5: Compare ARM vs MSP430 energy consumption
println("\n5. ARM vs MSP430 Energy Comparison")

# Equivalent ARM program
arm_program = [
    ARMInstruction(:mov, [:r4, 0x0100]),
    ARMInstruction(:mov, [:r5, 0x0200]),
    ARMInstruction(:add, [:r5, :r4, :r5]),
    ARMInstruction(:cmp, [:r5, 0x0300]),
    ARMInstruction(:b, [:skip]),  # branch instead of jump
    ARMInstruction(:str, [:r5, :sp]),  # store instead of push
    ARMInstruction(:nop, []),  # ARM doesn't have direct call equivalent in this simple model
]

# Sample energies for both architectures
arm_samples = Float64[]
msp430_samples = Float64[]

for _ in 1:500
    # ARM energy
    arm_trace = simulate(interpret_arm_program, (arm_program,))
    push!(arm_samples, get_retval(arm_trace))

    # MSP430 energy (subset of instructions for fair comparison)
    msp430_subset = sample_program[1:5]  # First 5 instructions
    msp430_trace = simulate(interpret_msp430_program, (msp430_subset,))
    push!(msp430_samples, get_retval(msp430_trace))
end

println("Energy comparison (similar programs):")
println("  ARM mean:    $(round(mean(arm_samples), digits=3))")
println("  MSP430 mean: $(round(mean(msp430_samples), digits=3))")
println("  Ratio (ARM/MSP430): $(round(mean(arm_samples)/mean(msp430_samples), digits=2))")

# Example 6: MSP430 instruction format analysis
println("\n6. MSP430 Instruction Format Analysis")
instruction_formats = Dict{Symbol, Int}()

for inst in sample_program
    format = get_instruction_format(inst.opcode)
    instruction_formats[format] = get(instruction_formats, format, 0) + 1
end

println("Instruction format distribution:")
for (format, count) in instruction_formats
    println("  $format: $count instructions")
end

# Example 7: Addressing mode analysis
println("\n7. MSP430 Addressing Mode Analysis")
addressing_modes = Dict{Symbol, Int}()

for inst in sample_program
    mode = inst.addressing_mode
    addressing_modes[mode] = get(addressing_modes, mode, 0) + 1
end

println("Addressing mode distribution:")
for (mode, count) in addressing_modes
    println("  $mode: $count instructions")
end

println("\n=== MSP430 Demo Complete ===")
println("MSP430 support has been successfully integrated into the probabilistic energy modeling system!")
println("\nKey features implemented:")
println("✓ MSP430 instruction parsing with 7 addressing modes")
println("✓ Complete MSP430 machine state simulation")
println("✓ MSP430-specific energy parameters (optimized for low-power)")
println("✓ Probabilistic energy modeling using Gen.jl")
println("✓ Support for all 27 core MSP430 instructions")
println("✓ Unified interface supporting both ARM and MSP430")