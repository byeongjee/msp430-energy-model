# jump.jl - Jump instruction handlers
#
# This file contains handlers for jump/conditional branch instructions:
# JMP, JZ, JNZ, JC, JNC, JN, JGE, JL

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
