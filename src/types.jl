# types.jl - Core type definitions module

module Types

export Operand,
    Instruction,
    ExecutionEvent,
    EventType,
    ExecutionTrace,
    WithEvent,
    CacheLine,
    MultiplierState,
    MachineState,
    EnergyStats,
    TrainingData,
    get_inst,
    Key,
    ModelGranularity,
    PerOpcode,
    PerAddressingMode,
    PerAddressingModeConstant,
    PerOpcodeWithMemAccess,
    PerAddressingModeWithMemAccess,
    PerAddressingModeConstantWithMemAccess,
    get_base_granularity,
    get_should_track_memory_access,
    SPECIAL_CALL_FUNCTIONS

"""
Type alias for parameter keys.
Keys can contain symbols (opcodes, addressing modes) and integers (compile-time constants).
"""
const Key = Tuple{Vararg{Union{Symbol,Int}}}

"""
Granularity level for energy model parameters.
Determines how fine-grained the energy model is.
"""
@enum ModelGranularity begin
    PerOpcode = 1                    # One parameter per opcode (e.g., mov, add, sub)
    PerAddressingMode = 2            # One parameter per (opcode, addressing_mode) combination
    PerAddressingModeConstant = 3    # Like PerAddressingMode but includes compile-time constants
    PerOpcodeWithMemAccess = 4                    # PerOpcode + memory access events
    PerAddressingModeWithMemAccess = 5            # PerAddressingMode + memory access events
    PerAddressingModeConstantWithMemAccess = 6    # PerAddressingModeConstant + memory access events
end

"""
Get the base granularity level (without memory access tracking).
For granularities with memory access, returns the corresponding base granularity.
For base granularities, returns the same value.
"""
function get_base_granularity(g::ModelGranularity)::ModelGranularity
    if g == PerOpcodeWithMemAccess
        return PerOpcode
    elseif g == PerAddressingModeWithMemAccess
        return PerAddressingMode
    elseif g == PerAddressingModeConstantWithMemAccess
        return PerAddressingModeConstant
    else
        return g
    end
end

"""
Check if this granularity level tracks memory access events.
"""
function get_should_track_memory_access(g::ModelGranularity)::Bool
    return g in [
        PerOpcodeWithMemAccess,
        PerAddressingModeWithMemAccess,
        PerAddressingModeConstantWithMemAccess,
    ]
end

# Instructions where immediate constants significantly affect energy
const constant_aware_opcodes = [:rlam, :rrum, :pushm, :popm, :rpt]

"""
MSP430 ABI runtime library and libm functions that should be treated as single
composite instructions for energy modeling. When a CALL/CALLA targets one of these,
the entire call (CALL + body + RET) is modeled as a single event with key
(:call, :__funcname) instead of the generic (:call, :immediate).

Maps all known symbol names (including GCC internal aliases) to their canonical
key symbol. For example, __mulhi2 and __mspabi_mpyi_f5hw both map to :__mspabi_mpyi.
"""
const SPECIAL_CALL_FUNCTIONS = Dict{String,Symbol}(
    "__mspabi_divi" => :__mspabi_divi,
    "__mspabi_divli" => :__mspabi_divli,
    "__mspabi_divu" => :__mspabi_divu,
    "__mspabi_mpyi" => :__mspabi_mpyi,
    "__mspabi_mpyi_f5hw" => :__mspabi_mpyi,
    "__mulhi2" => :__mspabi_mpyi,
    "__mspabi_mpyl" => :__mspabi_mpyl,
    "__mspabi_mpyl_f5hw" => :__mspabi_mpyl,
    "__mulsi2" => :__mspabi_mpyl,
    "__mspabi_remu" => :__mspabi_remu,
    "__mspabi_remul" => :__mspabi_remul,
    "__mspabi_mpyll" => :__mspabi_mpyll,
    "__mspabi_mpyll_f5hw" => :__mspabi_mpyll,
    "__muldi3" => :__mspabi_mpyll,
    "__mspabi_addd" => :__mspabi_addd,
    "__mspabi_subd" => :__mspabi_subd,
    "__mspabi_mpyd" => :__mspabi_mpyd,
    "__mspabi_divd" => :__mspabi_divd,
    "__mspabi_addf" => :__mspabi_addf,
    "__mspabi_mpyf" => :__mspabi_mpyf,
    "__mspabi_divf" => :__mspabi_divf,
    "__mspabi_cvtdf" => :__mspabi_cvtdf,
    "__mspabi_cvtfd" => :__mspabi_cvtfd,
    "__mspabi_fltuld" => :__mspabi_fltuld,
    "__mspabi_fltulf" => :__mspabi_fltulf,
    "__mspabi_fixfli" => :__mspabi_fixfli,
    "cos" => :cos,
    "sin" => :sin,
)

# MSP430 multiplier-mapped memory addresses (Table 9-65 of MSP430FR5994 datasheet)
const multiplier_address_modes = Dict(
    UInt32(0x04C0) => :MPY,
    UInt32(0x04C8) => :OP2,
    UInt32(0x04CA) => :RESLO,
    UInt32(0x04CC) => :RESHI,
    UInt32(0x04D0) => :MPY32L,
    UInt32(0x04D2) => :MPY32H,
    UInt32(0x04E0) => :OP2L,
    UInt32(0x04E2) => :OP2H,
    UInt32(0x04E4) => :RES0,
    UInt32(0x04E6) => :RES1,
)

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
"""
The feature value is the coefficient for this event's key in the energy model's linear combination:
E = Σ (feature_value_i × energy_param_i). For regular instructions this is 1.0 (one occurrence).
For special functions like memcpy, it can represent variable work such as bytes copied.
"""
const DEFAULT_FEATURE_VALUE = 1.0

struct ExecutionEvent
    type::EventType
    inst::Union{Nothing,Instruction}
    memory_access_info::Vector{Any}  # For memory access events: [addr, data_size]; empty for Inst events
    key::Key
    feature_value::Float64
end

"""
Get instruction key for parameter lookup based on granularity level.
For dual-operand instructions with PerAddressingMode, uses source and destination modes.
For PerAddressingModeConstant, also includes compile-time constant values for specific instructions.
"""
function get_instruction_key(inst::Instruction, model_granularity::ModelGranularity)::Key
    # Treat RPT blocks as a single instruction keyed by the nested instruction
    if inst.opcode == :rpt && inst.rpt_nested !== nothing
        repeat_count = length(inst.operands) >= 1 ? Int(inst.operands[1].value) : 0
        nested_key = get_instruction_key(inst.rpt_nested, model_granularity)
        return (:rpt, repeat_count, nested_key...)
    end

    # Remap absolute accesses to multiplier-mapped addresses into distinct modes
    remap_mode(op::Operand)::Symbol = begin
        if op.mode == :absolute && op.value isa Integer
            addr = UInt32(op.value)
            return get(multiplier_address_modes, addr, op.mode)
        end
        return op.mode
    end

    # Use base granularity for instruction key computation
    # (memory access tracking doesn't affect instruction keys)
    base_granularity = get_base_granularity(model_granularity)

    if base_granularity == PerOpcode
        # Simple: just the opcode
        return (inst.opcode,)
    elseif base_granularity == PerAddressingMode
        # Addressing mode aware, but no constant differentiation
        if length(inst.operands) == 0
            # No operands (e.g., ret, nop)
            return (inst.opcode,)
        elseif length(inst.operands) == 1
            # Single operand (e.g., push R5, call, jmp)
            return (inst.opcode, remap_mode(inst.operands[1]))
        else
            # Dual operand (e.g., mov, add) - use src and dst modes
            src_mode = remap_mode(inst.operands[1])
            dst_mode = remap_mode(inst.operands[2])
            return (inst.opcode, src_mode, dst_mode)
        end
    else  # PerAddressingModeConstant
        # Like PerAddressingMode but includes compile-time constants
        if length(inst.operands) == 0
            # No operands (e.g., ret, nop)
            return (inst.opcode,)
        elseif length(inst.operands) == 1
            # Single operand (e.g., push R5, call, jmp)
            src_mode = remap_mode(inst.operands[1])

            if inst.opcode in constant_aware_opcodes && src_mode == :immediate
                constant_value = Int(inst.operands[1].value)
                return (inst.opcode, src_mode, constant_value)
            end

            return (inst.opcode, src_mode)
        else
            # Dual operand (e.g., mov, add) - use src and dst modes
            src_mode = remap_mode(inst.operands[1])
            dst_mode = remap_mode(inst.operands[2])

            # Special handling for instructions with compile-time constants
            # These instructions have immediate values that significantly affect energy
            if inst.opcode in constant_aware_opcodes && src_mode == :immediate
                # Include the constant value in the key (convert to Int for type consistency)
                constant_value = Int(inst.operands[1].value)
                return (inst.opcode, src_mode, constant_value, dst_mode)
            end

            return (inst.opcode, src_mode, dst_mode)
        end
    end
end

"""
Constructor for ExecutionEvent with granularity (for Inst events).
Computes key from instruction using get_instruction_key.
"""
function ExecutionEvent(
    ::Type{Val{Inst}}, inst::Instruction, model_granularity::ModelGranularity
)::ExecutionEvent
    key = get_instruction_key(inst, model_granularity)
    return ExecutionEvent(Inst, inst, Any[], key, DEFAULT_FEATURE_VALUE)
end

"""
Constructor for ExecutionEvent without granularity (for memory access events).
Key is simply the event type as a tuple.
"""
function ExecutionEvent(
    event_type::EventType, inst::Union{Nothing,Instruction}, memory_access_info::Vector{Any}
)::ExecutionEvent
    key = (Symbol(event_type),)
    return ExecutionEvent(event_type, inst, memory_access_info, key, DEFAULT_FEATURE_VALUE)
end

"""
Constructor for feature-valued ExecutionEvent.
Used for special function features (e.g., bytes copied by memcpy).
"""
function ExecutionEvent(key::Key, feature_value::Float64)::ExecutionEvent
    return ExecutionEvent(Inst, nothing, Any[], key, feature_value)
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
Hardware multiplier state for MSP430FR5994.

The MSP430FR5994 has a hardware multiplier peripheral at addresses 0x04C0-0x04EA.
Writing to operand registers and then to the OP2 register triggers multiplication.
"""
mutable struct MultiplierState
    op1_mode::Symbol      # Operation type: :mpy, :mpys, :mac, :macs, :mpy32, :mpys32, :mac32, :macs32
    op1_value::UInt32     # Operand 1 value (16 or 32-bit depending on mode)
    op2_value::UInt32     # Operand 2 value (16 or 32-bit)
    result::UInt64        # Full 64-bit result (for 32x32 multiply)
    sumext::UInt16        # Sum extension register
end

MultiplierState() = MultiplierState(:mpy, UInt32(0), UInt32(0), UInt64(0), UInt16(0))

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
    flags::Dict{Symbol,Bool}        # V, N, Z, C flags
    repeat_counter::Int             # For RPT instruction: number of times to repeat next instruction
    multiplier::MultiplierState     # Hardware multiplier peripheral state
    # Debug state (moved from global to avoid test pollution)
    debug_u32_buffer::UInt16        # For DEBUG_MAGIC_U32_LO/HI
    debug_char_buffer::IOBuffer     # For DEBUG_MAGIC_CHR
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
    execution_traces::Vector{ExecutionTrace}
    energies::Vector{Float64}
end

end # module Types
