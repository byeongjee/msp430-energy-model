# gamma_per_addressing_mode.jl - Gamma model with per-addressing-mode granularity

include("gamma.jl")

using Main.Inference: PerAddressingMode

"""
Gamma distribution model with per-addressing-mode granularity.
"""
function GammaPerAddressingMode()
    return GammaModel(PerAddressingMode)
end
