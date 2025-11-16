# mean_per_pair_addressing_mode_constant.jl - Mean pair model with per-addressing-mode-constant granularity

"""
Mean-based model for consecutive instruction pairs with per-addressing-mode-constant granularity.
Assigns a cost to each consecutive pair of instructions instead of individual instructions.
Includes compile-time constants in parameter keys for instructions like rlam, pushm, popm.
"""
function MeanPerPairAddressingModeConstant()
    return MeanPairModel(PerAddressingModeConstant, "mean_per_pair_addressing_mode_constant")
end
