# types.jl - Type definitions

"""
Operand representation with its addressing mode
"""
struct Operand
    value::Any               # Register symbol, immediate value, address, or tuple for indexed
    mode::Symbol            # :register, :immediate, :indirect, :indexed, :absolute, :relative
end

"""
Instruction representation
"""
struct Instruction
    opcode::Symbol
    operands::Vector{Operand}
    data_size::Symbol        # :byte or :word
end

"""
Machine state for processor simulation
"""
mutable struct MachineState
    registers::Dict{Symbol,UInt16}  # R0-R15, 16-bit registers
    memory::Dict{UInt16,UInt16}     # 16-bit address space, 16-bit words
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
