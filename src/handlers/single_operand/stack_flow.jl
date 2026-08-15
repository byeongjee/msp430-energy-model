# stack_flow.jl - Stack and control flow instruction handlers
#
# This file contains handlers for stack operations and control flow:
# PUSH, PUSHM, POP, POPM, CALL, CALLA, RET, RETA, RETI, BR

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
        state,
        state.registers[:SP],
        operand_val,
        data_size,
        inst,
        should_track_memory_access,
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
        state,
        state.registers[:SP],
        UInt32(return_addr),
        :word,
        inst,
        should_track_memory_access,
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
        state,
        state.registers[:SP] + UInt32(2),
        high_word,
        :word,
        inst,
        should_track_memory_access,
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
                state,
                state.registers[:SP],
                UInt32(reg_val),
                data_size,
                inst,
                should_track_memory_access,
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

# pop dst - Pop value from stack to destination
# Equivalent to: mov @SP+, dst (supports all addressing modes)
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
    value, read_events = read_memory(
        state, state.registers[:SP], data_size, inst, should_track_memory_access
    )
    append!(events, read_events)

    # Store to destination (supports all addressing modes like MOV)
    dst = ops[1]
    write_events = set_operand_value!(
        state, dst, value, data_size, inst, should_track_memory_access
    )
    append!(events, write_events)

    # Increment stack pointer
    state.registers[:SP] = UInt32(
        (state.registers[:SP] + bytes_per_val) & get_register_mask(:SP)
    )

    return events
end
