# instruction_handlers.jl - Instruction handler type hierarchy and dispatch system
#
# This file defines the instruction handler interface that makes adding new
# instructions easy. To add a new instruction:
#
# 1. Create a handler type (struct XxxHandler <: [Base handler type] end) in types.jl
# 2. Add it to INSTRUCTION_HANDLERS dict in dispatch.jl
# 3. Implement execute!(state, ::XxxHandler, ops, data_size, addresses, current_idx)
#    in the appropriate handler file
# 4. Optionally override should_advance_pc(::XxxHandler, state, ops) in dispatch.jl
#
# File organization:
# - handlers/types.jl: Abstract and concrete handler type definitions
# - handlers/common.jl: Shared utilities (validation, RMW helper, generic execute!)
# - handlers/dual_operand.jl: MOV, ADD, ADDC, SUB, SUBC, CMP, DADD, BIT, BIC, BIS, XOR, AND
# - handlers/single_operand/rotate_shift.jl: RRC, RRCM, SWPB, RRA, RRUX, RRUM, SXT, INV, RLC, RLA, RLAM
# - handlers/single_operand/stack_flow.jl: PUSH, PUSHM, POP, POPM, CALL, CALLA, RET, RETA, RETI, BR
# - handlers/single_operand/arithmetic.jl: CLR, INC, DEC, INCD, DECD, ADC, SBC
# - handlers/single_operand/control.jl: DINT, EINT, SETC, CLRC, NOP, RPT
# - handlers/jump.jl: JMP, JZ, JNZ, JC, JNC, JN, JGE, JL
# - handlers/dispatch.jl: INSTRUCTION_HANDLERS dict, get_handler(), should_advance_pc()

# Include handler files in dependency order
include("handlers/types.jl")
include("handlers/common.jl")
include("handlers/dual_operand.jl")
include("handlers/single_operand/rotate_shift.jl")
include("handlers/single_operand/stack_flow.jl")
include("handlers/single_operand/arithmetic.jl")
include("handlers/single_operand/control.jl")
include("handlers/jump.jl")
include("handlers/dispatch.jl")  # Last: references all handler types
