# types.jl - Type definitions

"""
Operand representation with its addressing mode

MSP430 Addressing Modes:
- :register    - Register mode (Rn): Register contents are operand
- :indexed     - Indexed mode (X(Rn)): (Rn + X) points to operand, X in next word
- :symbolic    - Symbolic mode (X(PC)): (PC + X) points to operand, X in next word
- :absolute    - Absolute mode (&addr): Next word contains absolute address
- :indirect    - Indirect register mode (@Rn): Rn is pointer to operand
- :immediate   - Immediate mode (#N): Next word contains immediate constant

TODO: Not yet implemented:
- :autoincrement - Indirect autoincrement (@Rn+): Rn is pointer, incremented after
"""
struct Operand
    value::Any               # Register symbol, immediate value, address, or tuple for indexed
    mode::Symbol            # See addressing modes above
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
