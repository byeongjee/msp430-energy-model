# control.jl - Control and status register instruction handlers
#
# This file contains handlers for control instructions:
# DINT, EINT, SETC, CLRC, NOP, RPT

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
