# rotate_shift.jl - Rotate and shift instruction handlers
#
# This file contains handlers for rotate and shift instructions:
# RRC, RRCM, SWPB, RRA, RRUX, RRUM, SXT, INV, RLC, RLA, RLAM

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
        # Save initial state for V flag computation
        initial_c = state.flags[:C]
        msb_mask = get_data_size_msb(data_size)
        initial_dst_positive = (operand_val & msb_mask) == 0

        new_carry = (operand_val & 0x0001) != 0
        result = UInt32((operand_val >> 1) | (initial_c ? msb_mask : 0x0000))
        state.flags[:C] = new_carry

        # V flag: set if initial dst positive AND initial C was set
        state.flags[:V] = initial_dst_positive && initial_c

        update_flags_simple!(state, result, data_size)

        # Update SR with V flag
        state.registers[:SR] =
            (state.registers[:SR] & ~UInt32(0x0100)) |
            (state.flags[:V] ? 0x0100 : 0x0000)

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
        state.flags[:V] = false  # RRA always clears V flag per MSP430 spec
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
        # SXT: V is always cleared, C is set to NOT Z
        state.flags[:V] = false
        state.flags[:C] = (result != 0)
        result
    end
end

# INV - Bitwise invert
# INV is emulated as XOR #-1,dst but has special flag behavior:
# - V is set if the original operand was negative (MSB=1)
# - C = NOT Z (C=1 if result != 0, C=0 if result == 0)
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
        msb_bit = get_data_size_msb(data_size)

        # V is set if the original operand was negative (MSB=1)
        original_negative = (operand_val & msb_bit) != 0

        result = apply_data_size_mask(~operand_val, data_size)

        state.flags[:Z] = (result == 0)
        state.flags[:N] = (result & msb_bit) != 0
        # V is set if original dst was negative
        state.flags[:V] = original_negative
        # C = NOT Z (C=1 if result != 0)
        state.flags[:C] = !state.flags[:Z]

        state.registers[:SR] =
            (state.registers[:SR] & ~UInt32(0x0107)) |
            (state.flags[:V] ? 0x0100 : 0x0000) |
            (state.flags[:N] ? 0x0004 : 0x0000) |
            (state.flags[:Z] ? 0x0002 : 0x0000) |
            (state.flags[:C] ? 0x0001 : 0x0000)

        result
    end
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
        state.flags[:Z] = (result == 0)
        state.flags[:N] = (result & msb_bit) != 0

        # V flag: Set if arithmetic overflow occurs (sign change)
        # RLC is emulated as ADDC dst,dst, so overflow occurs when bit 15 != bit 14
        # This is because doubling a value causes overflow when the two top bits differ
        second_msb_bit = msb_bit >> 1
        state.flags[:V] = ((dst_val & msb_bit) != 0) != ((dst_val & second_msb_bit) != 0)

        # Update SR with flags (update V/C/Z/N)
        state.registers[:SR] =
            (state.registers[:SR] & 0x0008) |  # Preserve GIE (bit 3)
            (state.flags[:V] ? 0x0100 : 0x0000) |
            (state.flags[:N] ? 0x0004 : 0x0000) |
            (state.flags[:Z] ? 0x0002 : 0x0000) |
            (state.flags[:C] ? 0x0001 : 0x0000)

        result
    end
end

# RLA/RLAX - Rotate left arithmetic (RLAX is 20-bit variant, data_size set by parser)
# RLA is emulated as ADD dst,dst, so V flag must be set on overflow (sign change)
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
    # Second-to-MSB mask for overflow detection
    second_msb_mask = msb_mask >> 1
    new_carry = (operand_val & msb_mask) != 0
    result = UInt32(operand_val << 1)
    state.flags[:C] = new_carry
    # V flag: set if MSB changes during shift (bit MSB XOR bit MSB-1 before shift)
    # This indicates arithmetic overflow (sign change)
    state.flags[:V] = ((operand_val & msb_mask) != 0) != ((operand_val & second_msb_mask) != 0)
    update_flags_simple!(state, result, data_size)
    # Update SR to include V flag
    state.registers[:SR] =
        (state.registers[:SR] & ~UInt32(0x0100)) |  # Clear V bit
        (state.flags[:V] ? 0x0100 : 0x0000)         # Set V if overflow
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
    overflow = false
    for i in 1:shift_count
        old_sign = (result & msb_mask) != 0
        new_carry = old_sign
        result = result << 1
        new_sign = (result & msb_mask) != 0
        # V=1 if sign changed during any shift (overflow)
        if old_sign != new_sign
            overflow = true
        end
        state.flags[:C] = new_carry
    end

    state.flags[:V] = overflow
    update_flags_simple!(state, result, data_size)
    # Update SR to include V flag
    state.registers[:SR] =
        (state.registers[:SR] & ~UInt32(0x0100)) |
        (state.flags[:V] ? 0x0100 : 0x0000)
    write_events = set_operand_value!(
        state, ops[2], result, data_size, inst, should_track_memory_access
    )
    append!(events, write_events)
    return events
end
