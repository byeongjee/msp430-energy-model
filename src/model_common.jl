# model_common.jl - Common types and utilities for energy models

using ..Types: Instruction, Operand, TrainingData, Trace, Event, Inst, get_inst

"""
Type alias for parameter keys.
Keys can contain symbols (opcodes, addressing modes) and integers (compile-time constants).
"""
const ParamKey = Tuple{Vararg{Union{Symbol,Int}}}

const constant_aware_opcodes = [:rlam, :rrum, :pushm, :popm, :rpt]
# See table 9-65 of https://www.ti.com/lit/ds/symlink/msp430fr5994.pdf
const multiplier_address_modes = Dict(
    UInt32(0x04C0) => :MPY,
    UInt32(0x04C8) => :OP2,
    UInt32(0x04CA) => :RESLO,
    UInt32(0x04D0) => :MPY32L,
    UInt32(0x04D2) => :MPY32H,
    UInt32(0x04E0) => :OP2L,
    UInt32(0x04E2) => :OP2H,
    UInt32(0x04E4) => :RES0,
    UInt32(0x04E6) => :RES1,
)

instruction_events(program::Trace)::Vector{Event} = filter(evt -> evt.type == Inst, program)

"""
Granularity level for energy model parameters
"""
@enum ModelGranularity begin
    PerOpcode = 1                    # One parameter per opcode (e.g., mov, add, sub)
    PerAddressingMode = 2            # One parameter per (opcode, addressing_mode) combination
    PerAddressingModeConstant = 3    # Like PerAddressingMode but includes compile-time constants
end

"""
Check if an (opcode, addressing_mode) combination is meaningful for energy modeling.
Some combinations are meaningless because:
- No-operand instructions (ret, nop) don't use addressing modes
- Jump instructions only use symbolic (PC-relative) addressing
"""
function is_meaningful_combination(opcode::Symbol, mode::Symbol)::Bool
    # No-operand instructions - addressing mode is meaningless
    no_operand_instructions = [:ret, :nop, :reti, :dint]
    if opcode in no_operand_instructions
        return false
    end

    # Jump instructions only use symbolic (PC-relative) addressing
    jump_instructions = [:jnz, :jz, :jnc, :jc, :jn, :jge, :jl, :jmp]
    if opcode in jump_instructions
        return mode == :symbolic
    end

    # All other combinations are valid
    return true
end

"""
Get instruction key for parameter lookup based on granularity level.
For dual-operand instructions with PerAddressingMode, uses source and destination modes.
For PerAddressingModeConstant, also includes compile-time constant values for specific instructions.
"""
function get_instruction_key(inst::Instruction, granularity::ModelGranularity)::ParamKey
    # Treat RPT blocks as a single instruction keyed by the nested instruction
    if inst.opcode == :rpt && inst.rpt_nested !== nothing
        repeat_count = length(inst.operands) >= 1 ? Int(inst.operands[1].value) : 0
        nested_key = get_instruction_key(inst.rpt_nested, granularity)
        return (:rpt, repeat_count, nested_key...)
    end

    # Remap absolute accesses to multiplier-mapped addresses into distinct modes
    remap_mode(op::Operand)::Symbol = begin
        if op.mode == :absolute && op.value isa Integer
            addr = UInt32(op.value)
            return get(multiplier_address_modes, addr, op.mode)
        end
        return op.mode
    end

    if granularity == PerOpcode
        # Simple: just the opcode
        return (inst.opcode,)
    elseif granularity == PerAddressingMode
        # Addressing mode aware, but no constant differentiation
        if length(inst.operands) == 0
            # No operands (e.g., ret, nop)
            return (inst.opcode,)
        elseif length(inst.operands) == 1
            # Single operand (e.g., push R5, call, jmp)
            return (inst.opcode, remap_mode(inst.operands[1]))
        else
            # Dual operand (e.g., mov, add) - use src and dst modes
            src_mode = remap_mode(inst.operands[1])
            dst_mode = remap_mode(inst.operands[2])
            return (inst.opcode, src_mode, dst_mode)
        end
    else  # PerAddressingModeConstant
        # Like PerAddressingMode but includes compile-time constants
        if length(inst.operands) == 0
            # No operands (e.g., ret, nop)
            return (inst.opcode,)
        elseif length(inst.operands) == 1
            # Single operand (e.g., push R5, call, jmp)
            src_mode = remap_mode(inst.operands[1])

            if inst.opcode in constant_aware_opcodes && src_mode == :immediate
                constant_value = Int(inst.operands[1].value)
                return (inst.opcode, src_mode, constant_value)
            end

            return (inst.opcode, src_mode)
        else
            # Dual operand (e.g., mov, add) - use src and dst modes
            src_mode = remap_mode(inst.operands[1])
            dst_mode = remap_mode(inst.operands[2])

            # Special handling for instructions with compile-time constants
            # These instructions have immediate values that significantly affect energy
            if inst.opcode in constant_aware_opcodes && src_mode == :immediate
                # Include the constant value in the key (convert to Int for type consistency)
                constant_value = Int(inst.operands[1].value)
                return (inst.opcode, src_mode, constant_value, dst_mode)
            end

            return (inst.opcode, src_mode, dst_mode)
        end
    end
end

# Allow trace entries in addition to bare instructions.
get_instruction_key(event::Event, granularity::ModelGranularity)::ParamKey =
    if event.type == Inst
        get_instruction_key(get_inst(event), granularity)
    else
        error("Event type $event.type is not supported")
    end

"""
Extract all valid parameter keys from training data based on granularity level.
Only includes meaningful combinations.
"""
function get_valid_param_keys(
    training_data::TrainingData, granularity::ModelGranularity
)::Set{ParamKey}
    valid_keys = Set{ParamKey}()

    for program in training_data.programs
        for trace in program
            key = get_instruction_key(trace, granularity)

            # For PerAddressingMode and PerAddressingModeConstant, filter out meaningless combinations
            if (
                granularity == PerAddressingMode || granularity == PerAddressingModeConstant
            ) && length(key) >= 2
                # key is (opcode, mode) or (opcode, src_mode, dst_mode)
                # or (opcode, src_mode, constant, dst_mode) for constant-aware instructions
                if length(key) == 2
                    # Single operand: check if meaningful
                    if is_meaningful_combination(key[1], key[2])
                        push!(valid_keys, key)
                    end
                else
                    # Dual operand: both modes should be meaningful separately
                    # (we don't filter dual-op combos, just make sure they're valid)
                    push!(valid_keys, key)
                end
            else
                # PerOpcode or already validated
                push!(valid_keys, key)
            end
        end
    end

    return valid_keys
end
