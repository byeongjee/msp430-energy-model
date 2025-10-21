# types.jl - Type definitions

"""
Instruction representation
"""
struct Instruction
    opcode::Symbol
    operands::Vector{Any}
    addressing_mode::Symbol  # src_mode, dst_mode
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
