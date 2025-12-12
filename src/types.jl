# types.jl - Core type definitions module

module Types

export Operand,
    Instruction,
    ExecutionEvent,
    EventType,
    ExecutionTrace,
    WithEvent,
    CacheLine,
    MachineState,
    EnergyStats,
    TrainingData,
    get_inst

"""
Operand representation with its addressing mode

MSP430 Addressing Modes:
- :register      - Register mode (Rn): Register contents are operand
- :indexed       - Indexed mode (X(Rn)): (Rn + X) points to operand, X in next word
- :symbolic      - Symbolic mode (X(PC)): (PC + X) points to operand, X in next word
- :absolute      - Absolute mode (&addr): Next word contains absolute address
- :indirect      - Indirect register mode (@Rn): Rn is pointer to operand
- :autoincrement - Indirect autoincrement (@Rn+): Rn is pointer, incremented after
- :immediate     - Immediate mode (#N): Next word contains immediate constant
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
    data_size::Symbol        # :byte (8-bit), :word (16-bit), or :address (20-bit)
    rpt_nested::Union{Nothing,Instruction}  # Nested instruction for rpt blocks
end

# Convenience constructors to keep existing call sites unchanged
Instruction(opcode::Symbol, operands::Vector{Operand}, data_size::Symbol) =
    Instruction(opcode, operands, data_size, nothing)
Instruction(
    opcode::Symbol, operands::Vector{Operand}, data_size::Symbol; rpt_nested=nothing
) = Instruction(opcode, operands, data_size, rpt_nested)

"""
ExecutionEvent produced by the interpreter.
"""
@enum EventType begin
    Inst
    FRAMReadHit
    FRAMReadMiss
    FRAMWrite
    SRAMRead
    SRAMWrite
    Other
end
struct ExecutionEvent
    type::EventType
    inst::Union{Nothing,Instruction}
    operand_addressing_mode_and_constants::Vector{Any}
end

"""
Alias for a single trace of executed instructions.
"""
const ExecutionTrace = Vector{ExecutionEvent}

"""
Alias for a value with associated execution events.
Functions return WithEvent{T} to propagate events functionally.
"""
const WithEvent{T} = Tuple{T,Vector{ExecutionEvent}}

"""
Extract the underlying instruction from a trace entry.
"""
get_inst(event::ExecutionEvent)::Instruction = event.inst

"""
Cache line used by the MSP430FR5994-style cache simulation.
"""
mutable struct CacheLine
    valid::Bool
    tag::UInt32
    data::Vector{UInt8}
    last_used::UInt64
end

"""
Machine state for processor simulation

Register sizes:
- PC (R0), SP (R1): 20-bit
- SR (R2): 16-bit (status register)
- R3: 16-bit (constant generator)
- R4-R15: 20-bit (general purpose registers in MSP430X)
"""
mutable struct MachineState
    registers::Dict{Symbol,UInt32}  # All stored as UInt32, masked per register capabilities
    memory::Dict{UInt32,UInt16}     # 20-bit address space, 16-bit words
    cache::Vector{Vector{CacheLine}}  # 2-way, 4-line cache
    cache_tick::UInt64               # Monotonic counter for LRU
    current_inst_cache_hit::Bool     # Cache hit status for fetched instruction
    current_operand_cache_hits::Vector{Bool}  # Cache hits for operand reads in current instruction
    flags::Dict{Symbol,Bool}        # V, N, Z, C flags
    repeat_counter::Int             # For RPT instruction: number of times to repeat next instruction
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

"""
Training data structure containing programs and their energy measurements
"""
struct TrainingData
    programs::Vector{ExecutionTrace}
    energies::Vector{Float64}
end

end # module Types
