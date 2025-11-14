# mean_per_addressing_mode_constant.jl - Mean model with per-addressing-mode-constant granularity

"""
Mean-based model with per-addressing-mode-constant granularity.
Includes compile-time constants in parameter keys for instructions like rlam, pushm, popm.
"""
function MeanPerAddressingModeConstant()
    return MeanModel(PerAddressingModeConstant, "mean_per_addressing_mode_constant")
end
