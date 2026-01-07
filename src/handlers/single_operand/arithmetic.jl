# arithmetic.jl - Arithmetic instruction handlers
#
# This file contains handlers for simple arithmetic instructions:
# CLR, INC, DEC, INCD, DECD, ADC, SBC

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
