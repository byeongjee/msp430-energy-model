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
    PerOpcodeWithMemAccess,
    PerAddressingModeWithMemAccess,
    PerAddressingModeConstantWithMemAccess,
    get_should_track_memory_access,
    get_instruction_key,
    SPECIAL_CALL_FUNCTIONS
using ..Interpreter: FEATURE_FUNCTIONS

const FEATURE_FUNCTION_KEY_SYMBOLS = Set(first(spec) for spec in values(FEATURE_FUNCTIONS))

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
Extract all valid parameter keys from training data based on model_granularity level.
Only includes meaningful combinations.
"""
function get_valid_param_keys(
    training_data::TrainingData, model_granularity::ModelGranularity
)::Set{Key}
    valid_keys = Set{Key}()

    for execution_trace in training_data.execution_traces
        for execution_event in execution_trace
            key = execution_event.key

            # For PerAddressingMode and PerAddressingModeConstant, filter out meaningless combinations
            if (
                model_granularity == PerAddressingMode ||
                model_granularity == PerAddressingModeConstant
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

"""
Return true when a key should be treated as baseline behavior rather than a
separately learned feature for the given model granularity.

For *_with_mem_access models, FRAM read hits are absorbed into the base
instruction/addressing-mode terms. Only miss and non-FRAM access events are
learned as explicit additive penalties.
"""
function is_baseline_mem_event_key(
    key::Key, model_granularity::Union{ModelGranularity,Nothing}
)::Bool
    isnothing(model_granularity) && return false
    return get_should_track_memory_access(model_granularity) && key == (:FRAMReadHit,)
end

"""
Parse a key string (e.g., "mov_immediate_register") back to a tuple key.
Handles special function call keys like "call___mspabi_divu" which contain
underscores in the function name, making naive split("_") incorrect.
"""
function parse_key_string(key_str::String)::Key
    # Check for feature-function keys that serialize as a single symbol, e.g.
    # (:call_memcpy,) -> "call_memcpy" and (:call_memcpy, :bytes) -> "call_memcpy_bytes".
    for key_sym in FEATURE_FUNCTION_KEY_SYMBOLS
        base_key = string(key_sym)
        if key_str == base_key
            return (key_sym,)
        end
        if key_str == base_key * "_bytes"
            return (key_sym, :bytes)
        end
    end

    # Check for special function call keys first (use canonical names only)
    for canonical_sym in unique(values(SPECIAL_CALL_FUNCTIONS))
        func_name = string(canonical_sym)
        prefix = "call_" * func_name  # e.g., "call___mspabi_divu"
        if key_str == prefix
            return (:call, canonical_sym)
        end
        # Also handle calla variant
        calla_prefix = "calla_" * func_name
        if key_str == calla_prefix
            return (:calla, canonical_sym)
        end
    end

    # Normal parsing: split by underscore, convert integers
    key_parts = split(key_str, "_")
    return tuple(
        [
            let parsed = tryparse(Int, string(p))
                parsed !== nothing ? parsed : Symbol(p)
            end for p in key_parts
        ]...,
    )
end
