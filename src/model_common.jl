# model_common.jl - Common types and utilities for energy models

using ..Types:
    Instruction,
    Operand,
    TrainingData,
    ExecutionTrace,
    ExecutionEvent,
    Inst,
    get_inst,
    Key,
    ModelGranularity,
    PerOpcode,
    PerAddressingMode,
    PerAddressingModeConstant,
    get_instruction_key

instruction_events(program::ExecutionTrace)::Vector{ExecutionEvent} =
    filter(evt -> evt.type == Inst, program)

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
Extract all valid parameter keys from training data based on granularity level.
Only includes meaningful combinations.
"""
function get_valid_param_keys(
    training_data::TrainingData, granularity::ModelGranularity
)::Set{Key}
    valid_keys = Set{Key}()

    for program in training_data.programs
        for trace in program
            key = trace.key

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
