# types.jl - Type definitions

"""
ARM instruction representation
"""
struct ARMInstruction
    opcode::Symbol
    operands::Vector{Any}
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
Energy statistics result
"""
struct EnergyStats
    mean::Float64
    std::Float64
    min::Float64
    max::Float64
    samples::Vector{Float64}
end