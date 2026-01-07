# instruction_handlers.jl - Instruction handler type hierarchy and dispatch system
#
# This file defines the instruction handler interface that makes adding new
# instructions easy. To add a new instruction:
#
# 1. Create a handler type (struct XxxHandler <: [Base handler type] end)
# 2. Add it to INSTRUCTION_HANDLERS dict
# 3. Implement execute!(state, ::XxxHandler, ops, data_size, addresses, current_idx)
# 4. Optionally override should_advance_pc(::XxxHandler, state, ops) if needed
#

# ============================================================================
# Abstract Type Hierarchy
# ============================================================================

"""
Abstract base type for all instruction handlers.
Each handler implements:
- execute!(state, handler, ops, data_size, addresses, current_idx)
- optionally: should_advance_pc(handler, state, ops) [default: true]
"""
abstract type AbstractInstructionHandler end

"""
Handler for dual-operand instructions (src, dst)
"""
abstract type DualOperandHandler <: AbstractInstructionHandler end

"""
Handler for single-operand instructions
"""
abstract type SingleOperandHandler <: AbstractInstructionHandler end

"""
Handler for jump/conditional branch instructions
"""
abstract type JumpHandler <: AbstractInstructionHandler end

# ============================================================================
# Concrete Handler Types (one per instruction or group of similar instructions)
# ============================================================================

# Dual operand handlers
struct MovHandler <: DualOperandHandler end
struct AddHandler <: DualOperandHandler end
struct AddcHandler <: DualOperandHandler end
struct SubHandler <: DualOperandHandler end
struct SubcHandler <: DualOperandHandler end
struct CmpHandler <: DualOperandHandler end
struct DaddHandler <: DualOperandHandler end
struct BitHandler <: DualOperandHandler end
struct BicHandler <: DualOperandHandler end
struct BisHandler <: DualOperandHandler end
struct XorHandler <: DualOperandHandler end
struct AndHandler <: DualOperandHandler end

# Single operand handlers
struct RrcHandler <: SingleOperandHandler end
struct RrcmHandler <: SingleOperandHandler end
struct SwpbHandler <: SingleOperandHandler end
struct RraHandler <: SingleOperandHandler end
struct RruxHandler <: SingleOperandHandler end
struct RrumHandler <: SingleOperandHandler end
struct SxtHandler <: SingleOperandHandler end
struct InvHandler <: SingleOperandHandler end
struct PushHandler <: SingleOperandHandler end
struct CallHandler <: SingleOperandHandler end
struct RetiHandler <: SingleOperandHandler end
struct ClrHandler <: SingleOperandHandler end
struct RetHandler <: SingleOperandHandler end
struct CallaHandler <: SingleOperandHandler end
struct RetaHandler <: SingleOperandHandler end
struct IncHandler <: SingleOperandHandler end
struct DecHandler <: SingleOperandHandler end
struct DintHandler <: SingleOperandHandler end
struct EintHandler <: SingleOperandHandler end
struct SetcHandler <: SingleOperandHandler end
struct ClrcHandler <: SingleOperandHandler end
struct RlcHandler <: SingleOperandHandler end
struct NopHandler <: SingleOperandHandler end
struct BrHandler <: SingleOperandHandler end
struct PushmHandler <: SingleOperandHandler end
struct PopmHandler <: SingleOperandHandler end
struct PopHandler <: SingleOperandHandler end
struct RlaHandler <: SingleOperandHandler end
struct RlamHandler <: SingleOperandHandler end
struct SbcHandler <: SingleOperandHandler end
struct AdcHandler <: SingleOperandHandler end
struct DecdHandler <: SingleOperandHandler end
struct IncdHandler <: SingleOperandHandler end
struct RptHandler <: SingleOperandHandler end

# Jump handlers
struct JnzHandler <: JumpHandler end
struct JzHandler <: JumpHandler end
struct JncHandler <: JumpHandler end
struct JcHandler <: JumpHandler end
struct JnHandler <: JumpHandler end
struct JgeHandler <: JumpHandler end
struct JlHandler <: JumpHandler end
struct JmpHandler <: JumpHandler end

# ============================================================================
# Opcode to Handler Mapping
# ============================================================================

"""
Map opcode symbols to handler instances.
To add a new instruction, simply add an entry here after defining the handler type.
"""
const INSTRUCTION_HANDLERS = Dict{Symbol,AbstractInstructionHandler}(
    # Dual operand instructions
    :mov => MovHandler(),
    :mova => MovHandler(),  # Extended MOV for 20-bit address operations
    :add => AddHandler(),
    :adda => AddHandler(),  # Extended ADD for 20-bit address operations
    :addc => AddcHandler(),
    :sub => SubHandler(),
    :subc => SubcHandler(),
    :cmp => CmpHandler(),
    :dadd => DaddHandler(),
    :daddx => DaddHandler(),  # Extended DADD for 20-bit address operations
    :bit => BitHandler(),
    :bic => BicHandler(),
    :bis => BisHandler(),
    :xor => XorHandler(),
    :and => AndHandler(),
    # Single operand instructions
    :rrc => RrcHandler(),
    :rrcm => RrcmHandler(),
    :swpb => SwpbHandler(),
    :rra => RraHandler(),
    :rrax => RraHandler(),  # Extended RRA for 20-bit address operations
    :rrux => RruxHandler(),
    :rrum => RrumHandler(),
    :sxt => SxtHandler(),
    :inv => InvHandler(),
    :push => PushHandler(),
    :call => CallHandler(),
    :reti => RetiHandler(),
    :clr => ClrHandler(),
    :ret => RetHandler(),
    :calla => CallaHandler(),
    :reta => RetaHandler(),
    :inc => IncHandler(),
    :dec => DecHandler(),
    :dint => DintHandler(),
    :eint => EintHandler(),
    :setc => SetcHandler(),
    :clrc => ClrcHandler(),
    :rlc => RlcHandler(),
    :nop => NopHandler(),
    :br => BrHandler(),
    :pushm => PushmHandler(),
    :popm => PopmHandler(),
    :pop => PopHandler(),
    :rla => RlaHandler(),
    :rlam => RlamHandler(),
    :rlax => RlaHandler(),  # Extended RLA for 20-bit address operations
    :sbc => SbcHandler(),
    :adc => AdcHandler(),
    :decd => DecdHandler(),
    :incd => IncdHandler(),
    :rpt => RptHandler(),
    # Jump instructions
    :jnz => JnzHandler(),
    :jz => JzHandler(),
    :jnc => JncHandler(),
    :jc => JcHandler(),
    :jn => JnHandler(),
    :jge => JgeHandler(),
    :jl => JlHandler(),
    :jmp => JmpHandler(),
)

"""
Get handler for a given opcode symbol.
"""
function get_handler(opcode::Symbol)::AbstractInstructionHandler
    handler = get(INSTRUCTION_HANDLERS, opcode, nothing)
    if handler === nothing
        error("Unknown instruction opcode: $opcode")
    end
    return handler
end

# ============================================================================
# PC Update Logic (centralized trait-based predicates)
# ============================================================================

"""
Determine if PC should advance after instruction execution.
Default: advance PC for all instructions.
Override for instructions that manage their own PC (jumps, calls, branches).
"""
should_advance_pc(
    ::AbstractInstructionHandler, state::MachineState, ops::Vector{Operand}
)::Bool = true

# Instructions that manage their own PC: never advance
should_advance_pc(::CallHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::RetHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::CallaHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::RetaHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::RetiHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::BrHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::JumpHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::RptHandler, state::MachineState, ops::Vector{Operand})::Bool = false

# MOV/MOVA to PC acts as a branch: don't advance if destination is PC
function should_advance_pc(
    ::MovHandler, state::MachineState, ops::Vector{Operand}
)::Bool
    # Don't advance if destination operand is PC (R0)
    if length(ops) >= 2 && ops[2].mode == :register && ops[2].value == :PC
        return false
    end
    return true
end

# ============================================================================
# Operand Validation
# ============================================================================

"""
    require_operand_count(ops::Vector{Operand}, required::Int, opcode::Symbol)

Validate that instruction has the required number of operands.
Throws ArgumentError if validation fails (instead of silently returning).
"""
function require_operand_count(ops::Vector{Operand}, required::Int, opcode::Symbol)
    if length(ops) < required
        throw(ArgumentError("$opcode requires at least $required operand(s), got $(length(ops))"))
    end
end


# ============================================================================
# Single-Operand Common Pattern
# ============================================================================

"""
    execute_single_operand_rmw!(transform, state, opcode, inst, ops, data_size, should_track)

Execute a single-operand read-modify-write instruction.
The transform function receives (state, operand_val, data_size) and should:
1. Compute and return the result
2. Update flags as appropriate for the instruction (inside the function)

Note: transform is the first argument to support Julia's `do` block syntax.

This pattern applies to: RRC, SWPB, RRA, RRAX, RRUX, SXT, INV, INC, DEC, RLC,
RLA, RLAX, ADC, SBC, DECD, INCD
"""
function execute_single_operand_rmw!(
    transform::Function,  # (state, operand_val, data_size) -> result::UInt32 (first for do syntax)
    state::MachineState,
    opcode::Symbol,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 1, opcode)
    events = ExecutionEvent[]
    operand_val, read_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, read_events)

    result = transform(state, operand_val, data_size)

    write_events = set_operand_value!(
        state, ops[1], result, data_size, inst, should_track_memory_access
    )
    append!(events, write_events)
    return events
end

# ============================================================================
# Instruction Execution Methods (using multiple dispatch)
# ============================================================================
# Generic shim: allow execute! to accept the full Instruction for flexibility
function execute!(
    state::MachineState,
    handler::AbstractInstructionHandler,
    inst::Instruction,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute!(
        state,
        handler,
        inst,
        inst.operands,
        inst.data_size,
        address_info,
        current_idx,
        should_track_memory_access,
    )
end

# Each handler implements execute! with its specific logic.
# Helper functions (get_operand_value, set_operand_value!, etc.) are defined
# in machine_state.jl and used here.
# ============================================================================

# ----------------------------------------------------------------------------
# Dual Operand Instructions
# ----------------------------------------------------------------------------

# MOV/MOVA - Move source to destination (MOVA is 20-bit variant, data_size set by parser)
function execute!(
    state::MachineState,
    ::MovHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :mov)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_events = set_operand_value!(
        state, ops[2], src_val, data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    return events
end

# ADD/ADDA - Add source to destination (ADDA is 20-bit variant, data_size set by parser)
function execute!(
    state::MachineState,
    ::AddHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :add)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    result = UInt32(dst_val + src_val)
    update_flags_add!(state, result, dst_val, src_val, data_size)
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# ADDC - Add with carry
function execute!(
    state::MachineState,
    ::AddcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :addc)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    carry = state.flags[:C] ? UInt32(1) : UInt32(0)
    result = UInt32(dst_val + src_val + carry)
    update_flags_add!(state, result, dst_val, src_val, data_size)
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# SUB - Subtract source from destination
function execute!(
    state::MachineState,
    ::SubHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :sub)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    result = UInt32(dst_val - src_val)
    update_flags_sub!(state, result, dst_val, src_val, data_size)
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# SUBC - Subtract with carry
function execute!(
    state::MachineState,
    ::SubcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :subc)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    carry = state.flags[:C] ? UInt32(0) : UInt32(1)  # Inverted for subtraction
    result = UInt32(dst_val - src_val - carry)
    update_flags_sub!(state, result, dst_val, src_val, data_size)
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# CMP - Compare (subtract without storing)
function execute!(
    state::MachineState,
    ::CmpHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :cmp)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    result = UInt32(dst_val - src_val)
    update_flags_sub!(state, result, dst_val, src_val, data_size)
    return events  # Don't store result for compare
end

# DADD - Decimal add (BCD addition)
# Performs: src + dst + C -> dst (decimal), where each nibble is a BCD digit (0-9)
function execute!(
    state::MachineState,
    ::DaddHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :dadd)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)

    # BCD addition: add nibble by nibble with carry correction
    carry = state.flags[:C] ? UInt32(1) : UInt32(0)
    result = UInt32(0)

    # Number of nibbles depends on data size: byte=2, word=4, address=5
    num_nibbles = data_size == :byte ? 2 : data_size == :word ? 4 : 5

    for i in 0:(num_nibbles - 1)
        shift = i * 4
        src_nibble = (src_val >> shift) & 0xF
        dst_nibble = (dst_val >> shift) & 0xF
        nibble_sum = src_nibble + dst_nibble + carry

        # BCD correction: if sum > 9, add 6 to correct
        if nibble_sum > 9
            nibble_sum += 6
        end

        # Extract the corrected nibble and carry for next iteration
        carry = nibble_sum > 0xF ? UInt32(1) : UInt32(0)
        result |= (nibble_sum & 0xF) << shift
    end

    # Update flags for DADD:
    # C = set if result > 99999 (address) or > 9999 (word) or > 99 (byte), i.e., carry out of highest nibble
    # Z = set if result is zero
    # N = set if MSB is set
    # V = undefined (we leave it unchanged)
    state.flags[:C] = carry != 0

    # Apply data size mask for Z and N flag calculation
    mask = data_size == :byte ? UInt32(0xFF) : data_size == :word ? UInt32(0xFFFF) : UInt32(0xFFFFF)
    msb_bit = data_size == :byte ? UInt32(0x80) : data_size == :word ? UInt32(0x8000) : UInt32(0x80000)

    masked_result = result & mask
    state.flags[:Z] = masked_result == 0
    state.flags[:N] = (masked_result & msb_bit) != 0

    result_events = set_operand_value!(
        state, ops[2], UInt32(result), data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# BIT - Test bits (AND without storing)
# Flag behavior for BIT: N=MSB of result, Z=1 if zero, C=NOT Z, V=0
function execute!(
    state::MachineState,
    ::BitHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :bit)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    result = UInt32(dst_val & src_val)

    # BIT has special flag behavior (different from SUB/CMP)
    msb_bit = get_data_size_msb(data_size)
    masked_result = apply_data_size_mask(result, data_size)

    state.flags[:N] = (masked_result & msb_bit) != 0
    state.flags[:Z] = masked_result == 0
    state.flags[:C] = masked_result != 0  # C = NOT Z for BIT
    state.flags[:V] = false  # V is always reset for BIT

    return events  # Don't store result for bit test
end

# BIC - Bit clear
function execute!(
    state::MachineState,
    ::BicHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :bic)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    result = UInt32(dst_val & (~src_val))
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# BIS - Bit set
function execute!(
    state::MachineState,
    ::BisHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :bis)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    result = UInt32(dst_val | src_val)
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# XOR - Exclusive OR
function execute!(
    state::MachineState,
    ::XorHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :xor)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    result = UInt32(dst_val ⊻ src_val)
    update_flags_sub!(state, result, dst_val, src_val, data_size)
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# AND - Logical AND
function execute!(
    state::MachineState,
    ::AndHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :and)
    events = ExecutionEvent[]
    src_val, src_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, src_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)
    result = UInt32(dst_val & src_val)
    update_flags_sub!(state, result, dst_val, src_val, data_size)
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end

# ----------------------------------------------------------------------------
# Single Operand Instructions
# ----------------------------------------------------------------------------

# RRC - Rotate right through carry
function execute!(
    state::MachineState,
    ::RrcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :rrc, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        new_carry = (operand_val & 0x0001) != 0
        result = UInt32((operand_val >> 1) | (state.flags[:C] ? 0x8000 : 0x0000))
        state.flags[:C] = new_carry
        update_flags_simple!(state, result, data_size)
        result
    end
end

# RRCM - Rotate right through carry multiple times
# Supports 16-bit (.w) and 20-bit (.a) operands
# RRCM.W clears bits 19:16 of the destination register
function execute!(
    state::MachineState,
    ::RrcmHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :rrcm)
    events = ExecutionEvent[]
    shift_count, shift_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, shift_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)

    # Determine the MSB position based on data size
    msb_mask = if data_size == :address
        0x80000  # 20-bit: bit 19
    else  # :word
        0x8000   # 16-bit: bit 15
    end

    result = dst_val
    for i in 1:shift_count
        new_carry = (result & 0x0001) != 0
        result = UInt32((result >> 1) | (state.flags[:C] ? msb_mask : 0x0000))
        state.flags[:C] = new_carry
    end

    update_flags_simple!(state, result, data_size)
    write_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, write_events)
    return events
end

# SWPB - Swap bytes
function execute!(
    state::MachineState,
    ::SwpbHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :swpb, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        # No flag updates for SWPB
        UInt32(((operand_val & 0x00FF) << 8) | ((operand_val & 0xFF00) >> 8))
    end
end

# RRA/RRAX - Arithmetic right shift (RRAX is 20-bit variant, data_size set by parser)
function execute!(
    state::MachineState,
    ::RraHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :rra, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        mask = get_data_size_mask(data_size)
        msb = get_data_size_msb(data_size)
        sign_bit = operand_val & msb
        result = ((operand_val >> 1) | sign_bit) & mask
        state.flags[:C] = (operand_val & 0x0001) != 0
        update_flags_simple!(state, result, data_size)
        result
    end
end

# RRUX - Logical right shift extended (MSP430X, no sign extension)
function execute!(
    state::MachineState,
    ::RruxHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :rrux, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        # Logical right shift (zero fill)
        result = operand_val >> 1
        state.flags[:C] = (operand_val & 0x0001) != 0
        update_flags_simple!(state, result, data_size)
        result
    end
end

# RRUM - Rotate right unsigned multiple times
# Supports 16-bit (.w) and 20-bit (.a) operands
# RRUM.W clears bits 19:16 of the destination register
# Performs logical right shifts (zero fill) multiple times
function execute!(
    state::MachineState,
    ::RrumHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :rrum)
    events = ExecutionEvent[]
    shift_count, shift_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, shift_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)

    # The carry flag is set to the bit that gets shifted out after n shifts
    # For n shifts, this is bit (n-1) of the original value
    # For n=1: bit 0, n=2: bit 1, n=3: bit 2, n=4: bit 3
    carry_bit_pos = shift_count - 1
    carry_bit_mask = UInt32(1) << carry_bit_pos
    state.flags[:C] = (dst_val & carry_bit_mask) != 0

    # Logical right shift (zero fill) multiple times
    result = dst_val >> shift_count

    # Mask to data size (clears bits 19:16 for .w operations)
    result = result & get_data_size_mask(data_size)

    update_flags_simple!(state, result, data_size)
    write_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, write_events)
    return events
end

# SXT - Sign extend byte to word
function execute!(
    state::MachineState,
    ::SxtHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :sxt, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        result = if (operand_val & 0x0080) != 0
            UInt32(operand_val | 0xFF00)
        else
            UInt32(operand_val & 0x00FF)
        end
        update_flags_simple!(state, result, data_size)
        result
    end
end

# INV - Bitwise invert
function execute!(
    state::MachineState,
    ::InvHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :inv, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        result = apply_data_size_mask(~operand_val, data_size)

        # INV sets C=1, clears V, and updates N/Z based on the masked result.
        state.flags[:C] = true
        state.flags[:V] = false

        msb_bit = get_data_size_msb(data_size)

        state.flags[:Z] = (result == 0)
        state.flags[:N] = (result & msb_bit) != 0

        state.registers[:SR] =
            (state.registers[:SR] & ~UInt32(0x0107)) |
            (state.flags[:V] ? 0x0100 : 0x0000) |
            (state.flags[:N] ? 0x0004 : 0x0000) |
            (state.flags[:Z] ? 0x0002 : 0x0000) |
            (state.flags[:C] ? 0x0001 : 0x0000)

        result
    end
end

# PUSH - Push to stack
function execute!(
    state::MachineState,
    ::PushHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 1, :push)
    events = ExecutionEvent[]
    operand_val, read_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, read_events)
    bytes_per_val = data_size == :address ? UInt32(4) : UInt32(2)
    state.registers[:SP] = UInt32(
        (state.registers[:SP] - bytes_per_val) & get_register_mask(:SP)
    )
    # Use write_memory! to track stack writes as events
    write_events = write_memory!(
        state, state.registers[:SP], operand_val, data_size, inst, should_track_memory_access
    )
    append!(events, write_events)
    return events
end

# CALL - Call subroutine
function execute!(
    state::MachineState,
    ::CallHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 1, :call)
    if current_idx >= length(address_info)
        error(
            "Call instruction at index $current_idx has no next instruction for return address",
        )
    end
    events = ExecutionEvent[]
    operand_val, read_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, read_events)
    return_addr = address_info[current_idx + 1][1]
    # CALL instruction only supports 16-bit return addresses
    if return_addr > 0xFFFF
        error(
            "CALL instruction cannot handle return address 0x$(string(return_addr, base=16)) > 0xFFFF. Use CALLA for 20-bit addresses.",
        )
    end
    state.registers[:SP] = UInt32(
        (state.registers[:SP] - UInt32(2)) & get_register_mask(:SP)
    )
    # Use write_memory! to track stack writes as events
    write_events = write_memory!(
        state, state.registers[:SP], UInt32(return_addr), :word, inst, should_track_memory_access
    )
    append!(events, write_events)
    state.registers[:PC] = operand_val
    return events
end

# RET - Return from subroutine
function execute!(
    state::MachineState,
    ::RetHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    # Use read_memory to track stack reads as events
    return_addr, read_events = read_memory(
        state, state.registers[:SP], :word, inst, should_track_memory_access
    )
    state.registers[:PC] = return_addr
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + UInt32(2)) & get_register_mask(:SP)
    )
    return read_events
end

# CALLA - Call subroutine with 20-bit address
# Similar to CALL but pushes 4-byte (20-bit) return address and supports 20-bit target
function execute!(
    state::MachineState,
    ::CallaHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    if length(ops) < 1
        return ExecutionEvent[]
    end
    if current_idx >= length(address_info)
        error(
            "CALLA instruction at index $current_idx has no next instruction for return address",
        )
    end
    events = ExecutionEvent[]
    # Get target address (20-bit)
    operand_val, read_events = get_operand_value(
        state, ops[1], :address, inst, should_track_memory_access
    )
    append!(events, read_events)
    return_addr = address_info[current_idx + 1][1]

    # CALLA pushes 4 bytes: decrement SP by 4, then push 20-bit address
    # Stack layout (little-endian): low 16 bits at SP, high 4 bits at SP+2
    state.registers[:SP] = UInt32(
        (state.registers[:SP] - UInt32(4)) & get_register_mask(:SP)
    )

    # Write low 16 bits to SP
    low_word = UInt32(return_addr & 0xFFFF)
    write_events_low = write_memory!(
        state, state.registers[:SP], low_word, :word, inst, should_track_memory_access
    )
    append!(events, write_events_low)

    # Write high 4 bits to SP+2
    high_word = UInt32((return_addr >> 16) & 0xF)
    write_events_high = write_memory!(
        state, state.registers[:SP] + UInt32(2), high_word, :word, inst, should_track_memory_access
    )
    append!(events, write_events_high)

    state.registers[:PC] = operand_val
    return events
end

# RETA - Return from subroutine with 20-bit address
# Similar to RET but pops 4-byte (20-bit) return address
function execute!(
    state::MachineState,
    ::RetaHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    events = ExecutionEvent[]

    # RETA pops 4 bytes: low 16 bits from SP, high 4 bits from SP+2
    # Read low 16 bits from SP
    low_word, read_events_low = read_memory(
        state, state.registers[:SP], :word, inst, should_track_memory_access
    )
    append!(events, read_events_low)

    # Read high 4 bits from SP+2
    high_word, read_events_high = read_memory(
        state, state.registers[:SP] + UInt32(2), :word, inst, should_track_memory_access
    )
    append!(events, read_events_high)

    # Combine into 20-bit return address
    return_addr = UInt32(low_word) | (UInt32(high_word & 0xF) << 16)
    state.registers[:PC] = return_addr

    # Increment SP by 4
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + UInt32(4)) & get_register_mask(:SP)
    )

    return events
end

# RETI - Return from interrupt
function execute!(
    state::MachineState,
    ::RetiHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    events = ExecutionEvent[]
    # Pop SR from stack using read_memory to track events
    sr_val, sr_events = read_memory(
        state, state.registers[:SP], :word, inst, should_track_memory_access
    )
    append!(events, sr_events)
    state.registers[:SR] = sr_val
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + UInt32(2)) & get_register_mask(:SP)
    )
    # Pop PC from stack using read_memory to track events
    pc_val, pc_events = read_memory(
        state, state.registers[:SP], :word, inst, should_track_memory_access
    )
    append!(events, pc_events)
    state.registers[:PC] = pc_val
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + UInt32(2)) & get_register_mask(:SP)
    )
    return events
end

# CLR - Clear (set to zero)
function execute!(
    state::MachineState,
    ::ClrHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 1, :clr)
    events = set_operand_value!(
        state, ops[1], UInt32(0), data_size, inst, should_track_memory_access
    )
    return events
end

# INC - Increment by 1
function execute!(
    state::MachineState,
    ::IncHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :inc, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        result = operand_val + UInt32(1)
        update_flags_add!(state, result, operand_val, UInt32(1), data_size)
        result
    end
end

# DEC - Decrement by 1
function execute!(
    state::MachineState,
    ::DecHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :dec, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        result = operand_val - UInt32(1)
        update_flags_sub!(state, result, operand_val, UInt32(1), data_size)
        result
    end
end

# DINT - Disable interrupt
function execute!(
    state::MachineState,
    ::DintHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    state.registers[:SR] = state.registers[:SR] & ~0x0008  # Clear GIE bit (bit 3)
    return ExecutionEvent[]
end

# EINT - Enable interrupt
function execute!(
    state::MachineState,
    ::EintHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    state.registers[:SR] = state.registers[:SR] | 0x0008  # Set GIE bit (bit 3)
    return ExecutionEvent[]
end

# SETC - Set carry flag
function execute!(
    state::MachineState,
    ::SetcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    state.flags[:C] = true
    state.registers[:SR] = state.registers[:SR] | 0x0001  # Set C bit (bit 0)
    return ExecutionEvent[]
end

# CLRC - Clear carry flag
function execute!(
    state::MachineState,
    ::ClrcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    state.flags[:C] = false
    state.registers[:SR] = state.registers[:SR] & ~0x0001  # Clear C bit (bit 0)
    return ExecutionEvent[]
end

# RLC - Rotate left through carry
function execute!(
    state::MachineState,
    ::RlcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    # RLC rotates left through carry: shifts left and inserts carry into LSB
    return execute_single_operand_rmw!(
        state, :rlc, inst, ops, data_size, should_track_memory_access
    ) do state, dst_val, data_size
        carry = (state.registers[:SR] & 0x0001) != 0 ? UInt32(1) : UInt32(0)

        # Shift left and add carry
        result = (dst_val << 1) | carry

        # Mask to data size
        msb_bit = get_data_size_msb(data_size)
        result = result & get_data_size_mask(data_size)

        # Update C flag with the bit that was shifted out
        old_msb = (dst_val & msb_bit) != 0
        state.flags[:C] = old_msb

        # Update Z and N flags based on result
        # V flag is NOT affected by RLC per MSP430 spec
        state.flags[:Z] = (result == 0)
        state.flags[:N] = (result & msb_bit) != 0

        # Update SR with flags (preserve V flag, update C/Z/N)
        state.registers[:SR] =
            (state.registers[:SR] & 0x0108) |  # Preserve V (bit 8) and GIE (bit 3)
            (state.flags[:N] ? 0x0004 : 0x0000) |
            (state.flags[:Z] ? 0x0002 : 0x0000) |
            (state.flags[:C] ? 0x0001 : 0x0000)

        result
    end
end

# NOP - No operation
function execute!(
    state::MachineState,
    ::NopHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return ExecutionEvent[]
end

# BR - Branch (indirect jump)
function execute!(
    state::MachineState,
    ::BrHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 1, :br)
    events = ExecutionEvent[]
    operand_val, read_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, read_events)
    state.registers[:PC] = operand_val
    return events
end

# DECD - Double decrement
function execute!(
    state::MachineState,
    ::DecdHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :decd, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        result = operand_val - UInt32(2)
        update_flags_sub!(state, result, operand_val, UInt32(2), data_size)
        result
    end
end

# INCD - Double increment
function execute!(
    state::MachineState,
    ::IncdHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :incd, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        result = operand_val + UInt32(2)
        update_flags_add!(state, result, operand_val, UInt32(2), data_size)
        result
    end
end

# RPT - Repeat next instruction N times (execute nested instruction directly)
function execute!(
    state::MachineState,
    ::RptHandler,
    inst::Instruction,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    nested_inst = inst.rpt_nested
    count_val, count_events = get_operand_value(
        state, inst.operands[1], inst.data_size, inst, should_track_memory_access
    )
    count = Int(count_val)

    all_events = ExecutionEvent[]
    append!(all_events, count_events)

    nested_idx = current_idx + 1
    nested_addr = address_info[nested_idx][1]
    after_nested_idx = nested_idx < length(address_info) ? nested_idx + 1 : nested_idx
    nested_handler = get_handler(nested_inst.opcode)

    for _ in 1:count
        state.registers[:PC] = nested_addr
        nested_events = execute!(
            state,
            nested_handler,
            nested_inst,
            nested_inst.operands,
            nested_inst.data_size,
            address_info,
            nested_idx,
            should_track_memory_access,
        )
        append!(all_events, nested_events)
    end

    if after_nested_idx <= length(address_info) && state.registers[:PC] == nested_addr
        state.registers[:PC] = address_info[after_nested_idx][1]
    end

    return all_events
end

# SBC - Subtract carry
function execute!(
    state::MachineState,
    ::SbcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :sbc, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        carry = state.flags[:C] ? UInt32(0) : UInt32(1)  # Inverted for subtraction
        result = UInt32(operand_val - carry)
        update_flags_sub!(state, result, operand_val, carry, data_size)
        result
    end
end

# ADC - Add carry
function execute!(
    state::MachineState,
    ::AdcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_single_operand_rmw!(
        state, :adc, inst, ops, data_size, should_track_memory_access
    ) do state, operand_val, data_size
        carry = state.flags[:C] ? UInt32(1) : UInt32(0)
        result = UInt32(operand_val + carry)
        update_flags_add!(state, result, operand_val, carry, data_size)
        result
    end
end

# RLA/RLAX - Rotate left arithmetic (RLAX is 20-bit variant, data_size set by parser)
function execute!(
    state::MachineState,
    ::RlaHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 1, :rla)
    events = ExecutionEvent[]
    operand_val, read_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, read_events)
    # MSB depends on data size: bit 7 for byte, bit 15 for word, bit 19 for address
    msb_mask = data_size == :byte ? UInt32(0x80) : data_size == :word ? UInt32(0x8000) : UInt32(0x80000)
    new_carry = (operand_val & msb_mask) != 0
    result = UInt32(operand_val << 1)
    state.flags[:C] = new_carry
    update_flags_simple!(state, result, data_size)
    write_events = set_operand_value!(
        state, ops[1], result, data_size, inst, should_track_memory_access
    )
    append!(events, write_events)
    return events
end

# RLAM - Rotate left arithmetic multiple
function execute!(
    state::MachineState,
    ::RlamHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :rlam)
    events = ExecutionEvent[]
    shift_count, shift_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, shift_events)
    dst_val, dst_events = get_operand_value(
        state, ops[2], data_size, inst, should_track_memory_access
    )
    append!(events, dst_events)

    # MSB depends on data size: bit 7 for byte, bit 15 for word, bit 19 for address
    msb_mask = data_size == :byte ? UInt32(0x80) : data_size == :word ? UInt32(0x8000) : UInt32(0x80000)
    result = dst_val
    for i in 1:shift_count
        new_carry = (result & msb_mask) != 0
        result = result << 1
        state.flags[:C] = new_carry
    end

    update_flags_simple!(state, result, data_size)
    write_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, write_events)
    return events
end

# PUSHM - Push multiple registers
function execute!(
    state::MachineState,
    ::PushmHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :pushm)
    events = ExecutionEvent[]
    n_val, n_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, n_events)
    n = Int(n_val)
    dst_reg = ops[2].value
    dst_num = Parser.reg_symbol_to_num(dst_reg)

    bytes_per_reg = if data_size == :address
        UInt32(4)  # 20-bit = 2 words = 4 bytes
    else
        UInt32(2)  # 16-bit = 1 word = 2 bytes
    end

    for i in (dst_num - n + 1):dst_num
        if i >= 0 && i <= 15
            reg_sym = Parser.reg_num_to_symbol(i)
            reg_val = get_register_value(state, reg_sym)

            state.registers[:SP] = UInt32(
                (state.registers[:SP] - bytes_per_reg) & get_register_mask(:SP)
            )

            # Use write_memory! to track stack writes as events
            write_events = write_memory!(
                state, state.registers[:SP], UInt32(reg_val), data_size, inst, should_track_memory_access
            )
            append!(events, write_events)
        end
    end
    return events
end

# POPM - Pop multiple registers
function execute!(
    state::MachineState,
    ::PopmHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 2, :popm)
    events = ExecutionEvent[]
    n_val, n_events = get_operand_value(
        state, ops[1], data_size, inst, should_track_memory_access
    )
    append!(events, n_events)
    n = Int(n_val)
    dst_reg = ops[2].value
    dst_num = Parser.reg_symbol_to_num(dst_reg)

    bytes_per_reg = if data_size == :address
        UInt32(4)  # 20-bit = 2 words = 4 bytes
    else
        UInt32(2)  # 16-bit = 1 word = 2 bytes
    end

    for i in dst_num:-1:(dst_num - n + 1)
        if i >= 0 && i <= 15
            reg_sym = Parser.reg_num_to_symbol(i)

            # Use read_memory to track stack reads as events
            reg_val, read_events = read_memory(
                state, state.registers[:SP], data_size, inst, should_track_memory_access
            )
            append!(events, read_events)

            set_register_value!(state, reg_sym, reg_val)
            state.registers[:SP] = UInt32(
                (state.registers[:SP] + bytes_per_reg) & get_register_mask(:SP)
            )
        end
    end
    return events
end

# pop dst - Pop value from stack to destination register
# Equivalent to: mov @SP+, dst
function execute!(
    state::MachineState,
    ::PopHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{Tuple{UInt32,UInt32}},
    ::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 1, :pop)
    events = ExecutionEvent[]

    bytes_per_val = if data_size == :address
        UInt32(4)  # 20-bit = 2 words = 4 bytes
    else
        UInt32(2)  # 16-bit = 1 word = 2 bytes
    end

    # Read value from stack using read_memory to track events
    reg_val, read_events = read_memory(
        state, state.registers[:SP], data_size, inst, should_track_memory_access
    )
    append!(events, read_events)

    # Store to destination register
    dst_reg = ops[1].value
    set_register_value!(state, dst_reg, reg_val)

    # Increment stack pointer
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + bytes_per_val) & get_register_mask(:SP)
    )

    return events
end

# ----------------------------------------------------------------------------
# Jump Instructions
# ----------------------------------------------------------------------------

# Helper function for all jump instructions
function execute_jump_helper!(
    state::MachineState,
    should_jump::Bool,
    ops::Vector{Operand},
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    require_operand_count(ops, 1, :jmp)

    # Extract jump offset from symbolic addressing
    @assert ops[1].mode == :symbolic "Jump instructions must use symbolic addressing mode"
    @assert isa(ops[1].value, Tuple) "Jump operand value must be Tuple"
    @assert length(ops[1].value) == 2 "Jump operand value must be (offset, :PC)"
    jump_offset, reg = ops[1].value
    @assert reg == :PC "Jump operand register must be :PC"
    @assert isa(jump_offset, Integer) "Jump offset must be Integer"

    offset = reinterpret(Int16, UInt16(jump_offset & 0xFFFF))

    if should_jump
        # Jump is relative to PC + 2
        state.registers[:PC] = UInt32(
            (Int32(state.registers[:PC]) + 2 + (Int32(offset) * 2)) & 0xFFFFF
        )
    else
        # Advance to next instruction
        if current_idx < length(address_info)
            state.registers[:PC] = address_info[current_idx + 1][1]
        end
    end
    return ExecutionEvent[]
end

# JMP - Unconditional jump
function execute!(
    state::MachineState,
    ::JmpHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_jump_helper!(
        state, true, ops, address_info, current_idx, should_track_memory_access
    )
end

# JNZ - Jump if not zero
function execute!(
    state::MachineState,
    ::JnzHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_jump_helper!(
        state, !state.flags[:Z], ops, address_info, current_idx, should_track_memory_access
    )
end

# JZ - Jump if zero
function execute!(
    state::MachineState,
    ::JzHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_jump_helper!(
        state, state.flags[:Z], ops, address_info, current_idx, should_track_memory_access
    )
end

# JNC - Jump if no carry
function execute!(
    state::MachineState,
    ::JncHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_jump_helper!(
        state, !state.flags[:C], ops, address_info, current_idx, should_track_memory_access
    )
end

# JC - Jump if carry
function execute!(
    state::MachineState,
    ::JcHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_jump_helper!(
        state, state.flags[:C], ops, address_info, current_idx, should_track_memory_access
    )
end

# JN - Jump if negative
function execute!(
    state::MachineState,
    ::JnHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_jump_helper!(
        state, state.flags[:N], ops, address_info, current_idx, should_track_memory_access
    )
end

# JGE - Jump if greater or equal (signed)
function execute!(
    state::MachineState,
    ::JgeHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_jump_helper!(
        state,
        !(state.flags[:N] ⊻ state.flags[:V]),
        ops,
        address_info,
        current_idx,
        should_track_memory_access,
    )
end

# JL - Jump if less (signed)
function execute!(
    state::MachineState,
    ::JlHandler,
    inst::Instruction,
    ops::Vector{Operand},
    data_size::Symbol,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    return execute_jump_helper!(
        state,
        (state.flags[:N] ⊻ state.flags[:V]),
        ops,
        address_info,
        current_idx,
        should_track_memory_access,
    )
end
