# mean_per_addressing_mode.jl - Mean model with per-addressing-mode granularity

include("mean.jl")

using Main.Inference: PerAddressingMode

"""
Mean-based model with per-addressing-mode granularity.
"""
function MeanPerAddressingMode()
    return MeanModel(PerAddressingMode)
end
