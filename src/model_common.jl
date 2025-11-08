# model_common.jl - Common types and utilities for energy models

include("types.jl")

"""
Granularity level for energy model parameters
"""
@enum ModelGranularity begin
    PerOpcode = 1              # One parameter per opcode (e.g., mov, add, sub)
    PerAddressingMode = 2      # One parameter per (opcode, addressing_mode) combination
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
"""
function get_instruction_key(
    inst::Instruction, granularity::ModelGranularity
)::Tuple{Vararg{Symbol}}
    if granularity == PerOpcode
        # Simple: just the opcode
        return (inst.opcode,)
    else  # PerAddressingMode
        if length(inst.operands) == 0
            # No operands (e.g., ret, nop)
            return (inst.opcode,)
        elseif length(inst.operands) == 1
            # Single operand (e.g., push R5, call, jmp)
            return (inst.opcode, inst.operands[1].mode)
        else
            # Dual operand (e.g., mov, add) - use src and dst modes
            src_mode = inst.operands[1].mode
            dst_mode = inst.operands[2].mode
            return (inst.opcode, src_mode, dst_mode)
        end
    end
end

"""
Extract all valid parameter keys from training data based on granularity level.
Only includes meaningful combinations.
"""
function get_valid_param_keys(
    training_data::TrainingData, granularity::ModelGranularity
)::Set{Tuple{Vararg{Symbol}}}
    valid_keys = Set{Tuple{Vararg{Symbol}}}()

    for program in training_data.programs
        for inst in program
            key = get_instruction_key(inst, granularity)

            # For PerAddressingMode, filter out meaningless combinations
            if granularity == PerAddressingMode && length(key) >= 2
                # key is (opcode, mode) or (opcode, src_mode, dst_mode)
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
