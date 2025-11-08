# gamma_per_addressing_mode.jl - Gamma model with per-addressing-mode granularity

"""
Gamma distribution model with per-addressing-mode granularity.
"""
function GammaPerAddressingMode()
    return GammaModel(PerAddressingMode, "gamma_per_addressing_mode")
end
