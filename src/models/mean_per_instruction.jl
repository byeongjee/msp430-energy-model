# mean_per_instruction.jl - Mean model with per-instruction (opcode) granularity

include("mean.jl")

"""
Mean-based model with per-instruction (opcode) granularity.
"""
function MeanPerInstruction()
    return MeanModel(PerOpcode)
end
