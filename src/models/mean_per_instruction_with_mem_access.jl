# mean_per_instruction_with_mem_access.jl - Mean model with per-instruction granularity and memory access events

"""
Mean-based model with per-instruction (opcode) granularity and memory access event tracking.
"""
function MeanPerInstructionWithMemAccess()
    return MeanModel(PerOpcodeWithMemAccess, "mean_per_instruction_with_mem_access")
end
