# mean_per_addressing_mode_constant_with_mem_access.jl - Mean model with per-addressing-mode-constant granularity and memory access events

"""
Mean-based model with per-addressing-mode-constant granularity and memory access event tracking.
"""
function MeanPerAddressingModeConstantWithMemAccess()
    return MeanModel(
        PerAddressingModeConstantWithMemAccess,
        "mean_per_addressing_mode_constant_with_mem_access",
    )
end
