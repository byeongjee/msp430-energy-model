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
struct MovaHandler <: DualOperandHandler end
struct AddHandler <: DualOperandHandler end
struct AddaHandler <: DualOperandHandler end
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
struct RraxHandler <: SingleOperandHandler end
struct RruxHandler <: SingleOperandHandler end
struct RrumHandler <: SingleOperandHandler end
struct SxtHandler <: SingleOperandHandler end
struct InvHandler <: SingleOperandHandler end
struct PushHandler <: SingleOperandHandler end
struct CallHandler <: SingleOperandHandler end
struct RetiHandler <: SingleOperandHandler end
struct ClrHandler <: SingleOperandHandler end
struct RetHandler <: SingleOperandHandler end
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
    :mova => MovaHandler(),
    :add => AddHandler(),
    :adda => AddaHandler(),
    :addc => AddcHandler(),
    :sub => SubHandler(),
    :subc => SubcHandler(),
    :cmp => CmpHandler(),
    :dadd => DaddHandler(),
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
    :rrax => RraxHandler(),
    :rrux => RruxHandler(),
    :rrum => RrumHandler(),
    :sxt => SxtHandler(),
    :inv => InvHandler(),
    :push => PushHandler(),
    :call => CallHandler(),
    :reti => RetiHandler(),
    :clr => ClrHandler(),
    :ret => RetHandler(),
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
    :rla => RlaHandler(),
    :rlam => RlamHandler(),
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
should_advance_pc(::RetiHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::BrHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::JumpHandler, state::MachineState, ops::Vector{Operand})::Bool = false
should_advance_pc(::RptHandler, state::MachineState, ops::Vector{Operand})::Bool = false

# MOV/MOVA to PC acts as a branch: don't advance if destination is PC
function should_advance_pc(
    ::Union{MovHandler,MovaHandler}, state::MachineState, ops::Vector{Operand}
)::Bool
    # Don't advance if destination operand is PC (R0)
    if length(ops) >= 2 && ops[2].mode == :register && ops[2].value == :PC
        return false
    end
    return true
end

# ============================================================================
# Instruction Execution Methods (using multiple dispatch)
# ============================================================================
# Each handler implements execute! with its specific logic.
# Helper functions (get_operand_value, set_operand_value!, etc.) are defined
# in machine_state.jl and used here.
# ============================================================================

# ----------------------------------------------------------------------------
# Dual Operand Instructions
# ----------------------------------------------------------------------------

# MOV - Move source to destination
function execute!(
    state::MachineState,
    ::MovHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    set_operand_value!(state, ops[2], src_val, data_size)
    return nothing
end

# MOVA - Move address (20-bit) - same as MOV, data_size set by parser
function execute!(
    state::MachineState,
    ::MovaHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    set_operand_value!(state, ops[2], src_val, data_size)
    return nothing
end

# ADD - Add source to destination
function execute!(
    state::MachineState,
    ::AddHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val + src_val)
    update_flags!(state, result, dst_val, src_val, true, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# ADDA - Add address-sized source to destination
function execute!(
    state::MachineState,
    ::AddaHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val + src_val)
    update_flags!(state, result, dst_val, src_val, true, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# ADDC - Add with carry
function execute!(
    state::MachineState,
    ::AddcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    carry = state.flags[:C] ? UInt32(1) : UInt32(0)
    result = UInt32(dst_val + src_val + carry)
    update_flags!(state, result, dst_val, src_val, true, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# SUB - Subtract source from destination
function execute!(
    state::MachineState,
    ::SubHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val - src_val)
    update_flags!(state, result, dst_val, src_val, false, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# SUBC - Subtract with carry
function execute!(
    state::MachineState,
    ::SubcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    carry = state.flags[:C] ? UInt32(0) : UInt32(1)  # Inverted for subtraction
    result = UInt32(dst_val - src_val - carry)
    update_flags!(state, result, dst_val, src_val, false, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# CMP - Compare (subtract without storing)
function execute!(
    state::MachineState,
    ::CmpHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val - src_val)
    update_flags!(state, result, dst_val, src_val, false, data_size)
    return nothing  # Don't store result for compare
end

# DADD - Decimal add (BCD addition)
function execute!(
    state::MachineState,
    ::DaddHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val + src_val)
    update_flags!(state, result, dst_val, src_val, true, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# BIT - Test bits (AND without storing)
function execute!(
    state::MachineState,
    ::BitHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val & src_val)
    update_flags!(state, result, dst_val, src_val, false, data_size)
    return nothing  # Don't store result for bit test
end

# BIC - Bit clear
function execute!(
    state::MachineState,
    ::BicHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val & (~src_val))
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# BIS - Bit set
function execute!(
    state::MachineState,
    ::BisHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val | src_val)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# XOR - Exclusive OR
function execute!(
    state::MachineState,
    ::XorHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val ⊻ src_val)
    update_flags!(state, result, dst_val, src_val, false, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# AND - Logical AND
function execute!(
    state::MachineState,
    ::AndHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)
    result = UInt32(dst_val & src_val)
    update_flags!(state, result, dst_val, src_val, false, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# ----------------------------------------------------------------------------
# Single Operand Instructions
# ----------------------------------------------------------------------------

# RRC - Rotate right through carry
function execute!(
    state::MachineState,
    ::RrcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    new_carry = (operand_val & 0x0001) != 0
    result = UInt32((operand_val >> 1) | (state.flags[:C] ? 0x8000 : 0x0000))
    state.flags[:C] = new_carry
    update_flags_simple!(state, result, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# RRCM - Rotate right through carry multiple times
# Supports 16-bit (.w) and 20-bit (.a) operands
# RRCM.W clears bits 19:16 of the destination register
function execute!(
    state::MachineState,
    ::RrcmHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    shift_count = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)

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
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# SWPB - Swap bytes
function execute!(
    state::MachineState,
    ::SwpbHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    result = UInt32(((operand_val & 0x00FF) << 8) | ((operand_val & 0xFF00) >> 8))
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# RRA - Arithmetic right shift
function execute!(
    state::MachineState,
    ::RraHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    result = UInt32(Int32(operand_val) >> 1)
    state.flags[:C] = (operand_val & 0x0001) != 0
    update_flags_simple!(state, result, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# RRAX - Arithmetic right shift extended (MSP430X, supports 20-bit addressing)
function execute!(
    state::MachineState,
    ::RraxHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)

    # Arithmetic right shift (sign-extended)
    # We need to handle sign extension carefully to avoid overflow
    if data_size == :byte
        # Sign extend from bit 7
        is_negative = (operand_val & 0x80) != 0
        result = operand_val >> 1
        if is_negative
            result = result | 0x80  # Set MSB (bit 7)
        end
        result = result & 0xFF
    elseif data_size == :address
        # 20-bit: sign extend from bit 19
        is_negative = (operand_val & 0x80000) != 0
        result = operand_val >> 1
        if is_negative
            result = result | 0x80000  # Set MSB (bit 19)
        end
        result = result & 0xFFFFF
    else  # :word
        # Sign extend from bit 15
        is_negative = (operand_val & 0x8000) != 0
        result = operand_val >> 1
        if is_negative
            result = result | 0x8000  # Set MSB (bit 15)
        end
        result = result & 0xFFFF
    end

    state.flags[:C] = (operand_val & 0x0001) != 0
    update_flags_simple!(state, result, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# RRUX - Logical right shift extended (MSP430X, no sign extension)
function execute!(
    state::MachineState,
    ::RruxHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)

    # Logical right shift (zero fill)
    result = operand_val >> 1

    state.flags[:C] = (operand_val & 0x0001) != 0
    update_flags_simple!(state, result, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# RRUM - Rotate right unsigned multiple times
# Supports 16-bit (.w) and 20-bit (.a) operands
# RRUM.W clears bits 19:16 of the destination register
# Performs logical right shifts (zero fill) multiple times
function execute!(
    state::MachineState,
    ::RrumHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    shift_count = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)

    # The carry flag is set to the bit that gets shifted out after n shifts
    # For n shifts, this is bit (n-1) of the original value
    # For n=1: bit 0, n=2: bit 1, n=3: bit 2, n=4: bit 3
    carry_bit_pos = shift_count - 1
    carry_bit_mask = UInt32(1) << carry_bit_pos
    state.flags[:C] = (dst_val & carry_bit_mask) != 0

    # Logical right shift (zero fill) multiple times
    result = dst_val >> shift_count

    # Mask to data size (clears bits 19:16 for .w operations)
    if data_size == :byte
        result = result & 0xFF
    elseif data_size == :word
        result = result & 0xFFFF  # Clears bits 19:16
    else  # :address
        result = result & 0xFFFFF
    end

    update_flags_simple!(state, result, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# SXT - Sign extend byte to word
function execute!(
    state::MachineState,
    ::SxtHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    result = if (operand_val & 0x0080) != 0
        UInt32(operand_val | 0xFF00)
    else
        UInt32(operand_val & 0x00FF)
    end
    update_flags_simple!(state, result, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# INV - Bitwise invert
function execute!(
    state::MachineState,
    ::InvHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    result = apply_data_size_mask(~operand_val, data_size)

    # INV sets C=1, clears V, and updates N/Z based on the masked result.
    state.flags[:C] = true
    state.flags[:V] = false

    msb_bit = if data_size == :byte
        UInt32(0x80)
    elseif data_size == :word
        UInt32(0x8000)
    else
        UInt32(0x80000)
    end

    state.flags[:Z] = (result == 0)
    state.flags[:N] = (result & msb_bit) != 0

    state.registers[:SR] =
        (state.registers[:SR] & ~UInt32(0x0107)) |
        (state.flags[:V] ? 0x0100 : 0x0000) |
        (state.flags[:N] ? 0x0004 : 0x0000) |
        (state.flags[:Z] ? 0x0002 : 0x0000) |
        (state.flags[:C] ? 0x0001 : 0x0000)

    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# PUSH - Push to stack
function execute!(
    state::MachineState,
    ::PushHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    bytes_per_val = data_size == :address ? UInt32(4) : UInt32(2)
    state.registers[:SP] = UInt32(
        (state.registers[:SP] - bytes_per_val) & get_register_mask(:SP)
    )
    if data_size == :address
        set_memory_value!(state, state.registers[:SP], operand_val, :address)
    else
        state.memory[state.registers[:SP]] = UInt16(operand_val & 0xFFFF)
    end
    return nothing
end

# CALL - Call subroutine
function execute!(
    state::MachineState,
    ::CallHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    if current_idx >= length(addresses)
        error(
            "Call instruction at index $current_idx has no next instruction for return address",
        )
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    return_addr = addresses[current_idx + 1]
    # CALL instruction only supports 16-bit return addresses
    if return_addr > 0xFFFF
        error(
            "CALL instruction cannot handle return address 0x$(string(return_addr, base=16)) > 0xFFFF. Use CALLA for 20-bit addresses.",
        )
    end
    state.registers[:SP] = UInt32(
        (state.registers[:SP] - UInt32(2)) & get_register_mask(:SP)
    )
    state.memory[state.registers[:SP]] = UInt16(return_addr)
    state.registers[:PC] = operand_val
    return nothing
end

# RET - Return from subroutine
function execute!(
    state::MachineState,
    ::RetHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    return_addr = get(state.memory, state.registers[:SP], UInt16(0))
    state.registers[:PC] = return_addr
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + UInt32(2)) & get_register_mask(:SP)
    )
    return nothing
end

# RETI - Return from interrupt
function execute!(
    state::MachineState,
    ::RetiHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    state.registers[:SR] = state.memory[state.registers[:SP]]
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + UInt32(2)) & get_register_mask(:SP)
    )
    state.registers[:PC] = state.memory[state.registers[:SP]]
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + UInt32(2)) & get_register_mask(:SP)
    )
    return nothing
end

# CLR - Clear (set to zero)
function execute!(
    state::MachineState,
    ::ClrHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    set_operand_value!(state, ops[1], UInt32(0), data_size)
    return nothing
end

# INC - Increment by 1
function execute!(
    state::MachineState,
    ::IncHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    result = operand_val + UInt32(1)
    update_flags!(state, result, operand_val, UInt32(1), true, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# DEC - Decrement by 1
function execute!(
    state::MachineState,
    ::DecHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    result = operand_val - UInt32(1)
    update_flags!(state, result, operand_val, UInt32(1), false, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# DINT - Disable interrupt
function execute!(
    state::MachineState,
    ::DintHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    state.registers[:SR] = state.registers[:SR] & ~0x0008  # Clear GIE bit (bit 3)
    return nothing
end

# EINT - Enable interrupt
function execute!(
    state::MachineState,
    ::EintHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    state.registers[:SR] = state.registers[:SR] | 0x0008  # Set GIE bit (bit 3)
    return nothing
end

# SETC - Set carry flag
function execute!(
    state::MachineState,
    ::SetcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    state.flags[:C] = true
    state.registers[:SR] = state.registers[:SR] | 0x0001  # Set C bit (bit 0)
    return nothing
end

# CLRC - Clear carry flag
function execute!(
    state::MachineState,
    ::ClrcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    state.flags[:C] = false
    state.registers[:SR] = state.registers[:SR] & ~0x0001  # Clear C bit (bit 0)
    return nothing
end

# RLC - Rotate left through carry
function execute!(
    state::MachineState,
    ::RlcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    # RLC rotates left through carry: shifts left and inserts carry into LSB
    dst_val = get_operand_value(state, ops[1], data_size)
    carry = (state.registers[:SR] & 0x0001) != 0 ? UInt32(1) : UInt32(0)

    # Shift left and add carry
    result = (dst_val << 1) | carry

    # Mask to data size
    if data_size == :byte
        result = result & 0xFF
    elseif data_size == :word
        result = result & 0xFFFF
    else  # :address
        result = result & 0xFFFFF
    end

    # Update C flag with the bit that was shifted out
    old_msb = if data_size == :byte
        (dst_val & 0x80) != 0
    elseif data_size == :word
        (dst_val & 0x8000) != 0
    else  # :address
        (dst_val & 0x80000) != 0
    end

    state.flags[:C] = old_msb

    # Update Z and N flags based on result
    # V flag is NOT affected by RLC per MSP430 spec
    msb_bit = if data_size == :byte
        UInt32(0x80)
    elseif data_size == :word
        UInt32(0x8000)
    else  # :address
        UInt32(0x80000)
    end

    state.flags[:Z] = (result == 0)
    state.flags[:N] = (result & msb_bit) != 0

    # Update SR with flags (preserve V flag, update C/Z/N)
    state.registers[:SR] =
        (state.registers[:SR] & 0x0108) |  # Preserve V (bit 8) and GIE (bit 3)
        (state.flags[:N] ? 0x0004 : 0x0000) |
        (state.flags[:Z] ? 0x0002 : 0x0000) |
        (state.flags[:C] ? 0x0001 : 0x0000)

    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# NOP - No operation
function execute!(
    state::MachineState,
    ::NopHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    return nothing
end

# BR - Branch (indirect jump)
function execute!(
    state::MachineState,
    ::BrHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    state.registers[:PC] = operand_val
    return nothing
end

# DECD - Double decrement
function execute!(
    state::MachineState,
    ::DecdHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    result = operand_val - UInt32(2)
    update_flags!(state, result, operand_val, UInt32(2), false, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# INCD - Double increment
function execute!(
    state::MachineState,
    ::IncdHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    result = operand_val + UInt32(2)
    update_flags!(state, result, operand_val, UInt32(2), true, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# RPT - Repeat next instruction N times (execute nested instruction directly)
function execute!(
    state::MachineState,
    ::RptHandler,
    inst::Instruction,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    nested_inst = inst.rpt_nested
    count = Int(get_operand_value(state, inst.operands[1], inst.data_size))

    nested_idx = current_idx + 1
    nested_addr = addresses[nested_idx]
    after_nested_idx = nested_idx < length(addresses) ? nested_idx + 1 : nested_idx
    nested_handler = get_handler(nested_inst.opcode)

    for _ in 1:count
        state.registers[:PC] = nested_addr
        execute!(state, nested_handler, nested_inst.operands, nested_inst.data_size, addresses, nested_idx)
    end

    if after_nested_idx <= length(addresses) && state.registers[:PC] == nested_addr
        state.registers[:PC] = addresses[after_nested_idx]
    end

    return nothing
end

# SBC - Subtract carry
function execute!(
    state::MachineState,
    ::SbcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    carry = state.flags[:C] ? UInt32(0) : UInt32(1)  # Inverted for subtraction
    result = UInt32(operand_val - carry)
    update_flags!(state, result, operand_val, carry, false, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# ADC - Add carry
function execute!(
    state::MachineState,
    ::AdcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    carry = state.flags[:C] ? UInt32(1) : UInt32(0)
    result = UInt32(operand_val + carry)
    update_flags!(state, result, operand_val, carry, true, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# RLA - Rotate left arithmetic
function execute!(
    state::MachineState,
    ::RlaHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end
    operand_val = get_operand_value(state, ops[1], data_size)
    new_carry = (operand_val & 0x8000) != 0
    result = UInt32(operand_val << 1)
    state.flags[:C] = new_carry
    update_flags_simple!(state, result, data_size)
    set_operand_value!(state, ops[1], result, data_size)
    return nothing
end

# RLAM - Rotate left arithmetic multiple
function execute!(
    state::MachineState,
    ::RlamHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    shift_count = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)

    result = dst_val
    for i in 1:shift_count
        new_carry = (result & 0x8000) != 0
        result = result << 1
        state.flags[:C] = new_carry
    end

    update_flags_simple!(state, result, data_size)
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

# PUSHM - Push multiple registers
function execute!(
    state::MachineState,
    ::PushmHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    n = Int(get_operand_value(state, ops[1], data_size))
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

            if data_size == :address
                set_memory_value!(state, state.registers[:SP], reg_val, :address)
            else
                state.memory[state.registers[:SP]] = UInt16(reg_val & 0xFFFF)
            end
        end
    end
    return nothing
end

# POPM - Pop multiple registers
function execute!(
    state::MachineState,
    ::PopmHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    ::Vector{UInt32},
    ::Int,
)::Nothing
    if length(ops) < 2
        return nothing
    end
    n = Int(get_operand_value(state, ops[1], data_size))
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

            reg_val = if data_size == :address
                get_memory_value(state, state.registers[:SP], :address)
            else
                UInt32(get(state.memory, state.registers[:SP], UInt16(0)))
            end

            set_register_value!(state, reg_sym, reg_val)
            state.registers[:SP] = UInt32(
                (state.registers[:SP] + bytes_per_reg) & get_register_mask(:SP)
            )
        end
    end
    return nothing
end

# ----------------------------------------------------------------------------
# Jump Instructions
# ----------------------------------------------------------------------------

# Helper function for all jump instructions
function execute_jump_helper!(
    state::MachineState,
    should_jump::Bool,
    ops::Vector{Operand},
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end

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
        if current_idx < length(addresses)
            state.registers[:PC] = addresses[current_idx + 1]
        end
    end
    return nothing
end

# JMP - Unconditional jump
function execute!(
    state::MachineState,
    ::JmpHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump_helper!(state, true, ops, addresses, current_idx)
end

# JNZ - Jump if not zero
function execute!(
    state::MachineState,
    ::JnzHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump_helper!(state, !state.flags[:Z], ops, addresses, current_idx)
end

# JZ - Jump if zero
function execute!(
    state::MachineState,
    ::JzHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump_helper!(state, state.flags[:Z], ops, addresses, current_idx)
end

# JNC - Jump if no carry
function execute!(
    state::MachineState,
    ::JncHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump_helper!(state, !state.flags[:C], ops, addresses, current_idx)
end

# JC - Jump if carry
function execute!(
    state::MachineState,
    ::JcHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump_helper!(state, state.flags[:C], ops, addresses, current_idx)
end

# JN - Jump if negative
function execute!(
    state::MachineState,
    ::JnHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump_helper!(state, state.flags[:N], ops, addresses, current_idx)
end

# JGE - Jump if greater or equal (signed)
function execute!(
    state::MachineState,
    ::JgeHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump_helper!(
        state, !(state.flags[:N] ⊻ state.flags[:V]), ops, addresses, current_idx
    )
end

# JL - Jump if less (signed)
function execute!(
    state::MachineState,
    ::JlHandler,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump_helper!(
        state, (state.flags[:N] ⊻ state.flags[:V]), ops, addresses, current_idx
    )
end
