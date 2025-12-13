# mean_per_addressing_mode_with_mem_access.jl - Mean model with per-addressing-mode granularity and memory access events

"""
Mean-based model with per-addressing-mode granularity and memory access event tracking.
"""
function MeanPerAddressingModeWithMemAccess()
    return MeanModel(PerAddressingModeWithMemAccess, "mean_per_addressing_mode_with_mem_access")
end
