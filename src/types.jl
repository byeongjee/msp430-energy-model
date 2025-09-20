# types.jl - Type definitions

"""
ARM instruction representation
"""
struct ARMInstruction
    opcode::Symbol
    operands::Vector{Any}
end

"""
MSP430 instruction representation
"""
struct MSP430Instruction
    opcode::Symbol
    operands::Vector{Any}
    addressing_mode::Symbol  # src_mode, dst_mode for MSP430
end

"""
Abstract instruction type for unified processing
"""
abstract type AbstractInstruction end

"""
Wrapper for ARM instructions
"""
struct ARMInstructionWrapper <: AbstractInstruction
    instruction::ARMInstruction
end

"""
Wrapper for MSP430 instructions
"""
struct MSP430InstructionWrapper <: AbstractInstruction
    instruction::MSP430Instruction
end

"""
Machine state for ARM processor simulation
"""
mutable struct MachineState
    registers::Dict{Symbol,Int64}
    memory::Dict{Int64,Int64}
    pc::Int64  # Program counter
    flags::Dict{Symbol,Bool}  # N, Z, C, V flags
end

"""
Machine state for MSP430 processor simulation
"""
mutable struct MSP430MachineState
    registers::Dict{Symbol,UInt16}  # R0-R15, 16-bit registers
    memory::Dict{UInt16,UInt16}     # 16-bit address space, 16-bit words
    pc::UInt16                      # Program counter (R0)
    sp::UInt16                      # Stack pointer (R1)
    sr::UInt16                      # Status register (R2) - contains flags
    flags::Dict{Symbol,Bool}        # V, N, Z, C flags
end

"""
Energy statistics result
"""
struct EnergyStats
    mean::Float64
    std::Float64
    min::Float64
    max::Float64
    samples::Vector{Float64}
end