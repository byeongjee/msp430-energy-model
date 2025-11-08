# mean_per_instruction.jl - Mean model with per-instruction (opcode) granularity

include("mean.jl")

using Main.Inference: PerOpcode

"""
Mean-based model with per-instruction (opcode) granularity.
"""
function MeanPerInstruction()
    return MeanModel(PerOpcode)
end
