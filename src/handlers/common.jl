# common.jl - Shared utilities for instruction handlers
#
# This file contains common patterns and helper functions used across
# multiple instruction handlers.

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
