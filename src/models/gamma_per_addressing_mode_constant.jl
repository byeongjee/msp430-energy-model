# gamma_per_addressing_mode_constant.jl - Gamma model with per-addressing-mode-constant granularity

"""
Gamma distribution model with per-addressing-mode-constant granularity.
Includes compile-time constants in parameter keys for instructions like rlam, pushm, popm.
"""
function GammaPerAddressingModeConstant()
    return GammaModel(PerAddressingModeConstant, "gamma_per_addressing_mode_constant")
end
