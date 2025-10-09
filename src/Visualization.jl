# Visualization.jl - Plotting and visualization module

module Visualization

using Plots

export plot_cost_distribution

"""
Plot cost distribution (separated from business logic)
Uses Plots.jl to create a histogram with statistics overlay
"""
function plot_cost_distribution(
    stats::NamedTuple{
        (:mean, :std, :min, :max, :samples),
        Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
    },
    output_file::Union{String,Nothing}=nothing,
)::Nothing
    @info "Plotting cost distribution"

    # Calculate optimal number of bins using Sturges' rule or sqrt rule
    n_samples = length(stats.samples)
    n_bins = min(100, max(30, Int(ceil(sqrt(n_samples)))))

    # Create histogram with improved styling
    p = histogram(
        stats.samples;
        bins=n_bins,
        normalize=:probability,  # Show probability density instead of raw counts
        xlabel="Cost (nanojoules)",
        ylabel="Probability Density",
        title="Energy Cost Distribution",
        legend=:topright,
        color=:steelblue,
        alpha=0.6,
        linecolor=:steelblue,
        linewidth=1,
        label="Samples",
        size=(800, 500),
        dpi=150,
        margins=5Plots.mm,
    )

    # Add vertical line for mean
    vline!(
        [stats.mean];
        color=:red,
        linewidth=2.5,
        linestyle=:solid,
        label="Mean: $(round(stats.mean, digits=2)) nJ",
    )

    # Add vertical lines for ±1 std
    vline!(
        [stats.mean - stats.std];
        color=:orange,
        linewidth=2,
        linestyle=:dash,
        label="-1σ: $(round(stats.mean - stats.std, digits=2)) nJ",
    )
    vline!(
        [stats.mean + stats.std];
        color=:orange,
        linewidth=2,
        linestyle=:dash,
        label="+1σ: $(round(stats.mean + stats.std, digits=2)) nJ",
    )

    # Add text box with statistics in corner
    stats_text = """
    Statistics:
    Mean: $(round(stats.mean, digits=2)) nJ
    Std:  $(round(stats.std, digits=2)) nJ
    Min:  $(round(stats.min, digits=2)) nJ
    Max:  $(round(stats.max, digits=2)) nJ
    """

    annotate!(
        stats.min + (stats.max - stats.min) * 0.02,
        maximum(p.series_list[1][:y]) * 0.95,
        text(stats_text, :left, 7, :gray20),
    )

    # Save or display
    if !isnothing(output_file)
        savefig(p, output_file)
        @info "Plot saved" path = output_file
    else
        display(p)
    end

    return nothing
end

end # module
