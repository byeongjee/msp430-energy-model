# mean_per_instruction.jl - Mean model with per-instruction (opcode) granularity

"""
Mean-based model with per-instruction (opcode) granularity.
"""
function MeanPerInstruction()
    return MeanModel(PerOpcode)
end
