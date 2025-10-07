# interpreter.jl - Core probabilistic interpreter

using Gen
using Distributions

"""
Sample energy consumption for a given instruction using stateless Gamma distribution
"""
@gen function sample_instruction_energy(opcode::Symbol)::Float64
    alpha, beta = get_energy_params(opcode)
    energy ~ gamma(alpha, beta)
    return energy
end

"""
Probabilistic interpreter for MSP430 assembly programs.
Returns a generative function that models the program's energy distribution.
"""
@gen function interpret_program(instructions::Vector{Instruction})::Float64
    state = MachineState()
    total_energy = 0.0

    # Execute each instruction and accumulate energy
    for (i, inst) in enumerate(instructions)
        # Sample energy for this instruction
        inst_energy = @trace(sample_instruction_energy(inst.opcode),
            :energy => i)
        total_energy += inst_energy

        # Execute instruction (modifies state)
        execute_instruction!(state, inst)
    end

    return total_energy
end

"""
Create a program-specific energy model with custom parameters for MSP430
"""
@gen function custom_energy_model(instructions::Vector{Instruction},
    custom_params::Dict{Symbol,Tuple{Float64,Float64}})::Float64
    total_energy = 0.0

    for (i, inst) in enumerate(instructions)
        params = get(custom_params, inst.opcode, get_energy_params(inst.opcode))
        alpha, beta = params
        inst_energy ~ gamma(alpha, beta)
        total_energy += inst_energy
    end

    return total_energy
end
