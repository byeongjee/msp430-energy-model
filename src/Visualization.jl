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

    # Create histogram
    p = histogram(
        stats.samples;
        bins=50,
        xlabel="Cost (nanojoules)",
        ylabel="Frequency",
        title="Cost Distribution",
        legend=false,
        color=:steelblue,
        alpha=0.7,
    )

    # Add vertical lines for mean and std
    vline!([stats.mean]; color=:red, linewidth=2, label="Mean")
    vline!(
        [stats.mean - stats.std, stats.mean + stats.std];
        color=:orange,
        linewidth=1.5,
        linestyle=:dash,
        label="±1 Std",
    )

    # Add text annotation with statistics
    annotate!(
        stats.mean,
        maximum(p.series_list[1][:y]) * 0.9,
        text(
            "Mean: $(round(stats.mean, digits=2))\nStd: $(round(stats.std, digits=2))",
            :left,
            8,
        ),
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
