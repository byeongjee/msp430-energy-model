# dispatch.jl - Opcode to handler mapping and PC update logic
#
# This file contains the INSTRUCTION_HANDLERS dictionary that maps opcodes
# to handler instances, along with PC update predicates.

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
function should_advance_pc(::MovHandler, state::MachineState, ops::Vector{Operand})::Bool
    # Don't advance if destination operand is PC (R0)
    if length(ops) >= 2 && ops[2].mode == :register && ops[2].value == :PC
        return false
    end
    return true
end
