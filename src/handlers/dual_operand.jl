# dual_operand.jl - Dual-operand instruction handlers
#
# This file contains handlers for dual-operand instructions:
# MOV, ADD, ADDC, SUB, SUBC, CMP, DADD, BIT, BIC, BIS, XOR, AND

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
    # Fix C flag to include carry-in (update_flags_add! only considers dst + src)
    max_val = get_data_size_mask(data_size)
    masked_dst = apply_data_size_mask(dst_val, data_size)
    masked_src = apply_data_size_mask(src_val, data_size)
    state.flags[:C] =
        (UInt64(masked_dst) + UInt64(masked_src) + UInt64(carry)) > UInt64(max_val)
    _sync_sr_with_flags!(state)
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
    borrow = state.flags[:C] ? UInt32(0) : UInt32(1)  # Borrow = NOT C for subtraction
    result = UInt32(dst_val - src_val - borrow)
    update_flags_sub!(state, result, dst_val, src_val, data_size)
    # Fix C flag to include borrow-in (update_flags_sub! only considers dst >= src)
    # C = 1 if no borrow needed: dst >= (src + borrow_in)
    masked_dst = apply_data_size_mask(dst_val, data_size)
    masked_src = apply_data_size_mask(src_val, data_size)
    state.flags[:C] = UInt64(masked_dst) >= (UInt64(masked_src) + UInt64(borrow))
    _sync_sr_with_flags!(state)
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
    num_nibbles = if data_size == :byte
        2
    elseif data_size == :word
        4
    else
        5
    end

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
    mask = if data_size == :byte
        UInt32(0xFF)
    elseif data_size == :word
        UInt32(0xFFFF)
    else
        UInt32(0xFFFFF)
    end
    msb_bit = if data_size == :byte
        UInt32(0x80)
    elseif data_size == :word
        UInt32(0x8000)
    else
        UInt32(0x80000)
    end

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
    # XOR flag behavior per MSP430 spec:
    # N: Set if MSB of result is set
    # Z: Set if result is zero
    # C: Set if result is NOT zero (C = NOT Z)
    # V: Set if both operands are negative (both MSB=1)
    masked_result = apply_data_size_mask(result, data_size)
    masked_dst = apply_data_size_mask(dst_val, data_size)
    masked_src = apply_data_size_mask(src_val, data_size)
    msb_bit = get_data_size_msb(data_size)
    state.flags[:N] = (masked_result & msb_bit) != 0
    state.flags[:Z] = (masked_result == 0)
    state.flags[:C] = (masked_result != 0)  # C = NOT Z
    state.flags[:V] = ((masked_dst & msb_bit) != 0) && ((masked_src & msb_bit) != 0)  # Both negative
    _sync_sr_with_flags!(state)
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
    # AND flag behavior per MSP430 spec (same as BIT):
    # N: Set if MSB of result is set
    # Z: Set if result is zero
    # C: Set if result is NOT zero (C = NOT Z)
    # V: Always 0
    msb_bit = get_data_size_msb(data_size)
    masked_result = apply_data_size_mask(result, data_size)
    state.flags[:N] = (masked_result & msb_bit) != 0
    state.flags[:Z] = masked_result == 0
    state.flags[:C] = masked_result != 0  # C = NOT Z
    state.flags[:V] = false  # V is always reset for AND
    _sync_sr_with_flags!(state)
    result_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, result_events)
    return events
end
