# Visualization.jl - Plotting and visualization module

module Visualization

using Plots
using Distributions
using Main.Inference: ModelGranularity

export plot_cost_distribution, plot_cost_distributions_grid, visualize_instruction_params

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

"""
Plot multiple cost distributions in a grid layout
Accepts a vector of stats and plots each as a subplot in a grid
"""
function plot_cost_distributions_grid(
    all_stats::Vector{
        NamedTuple{
            (:mean, :std, :min, :max, :samples),
            Tuple{Float64,Float64,Float64,Float64,Vector{Float64}},
        },
    },
    output_file::Union{String,Nothing}=nothing,
)::Nothing
    @info "Plotting cost distributions in grid" num_distributions = length(all_stats)

    n_distributions = length(all_stats)

    # Calculate grid dimensions (try to make it roughly square)
    n_cols = Int(ceil(sqrt(n_distributions)))
    n_rows = Int(ceil(n_distributions / n_cols))

    # Create subplots
    plots_array = []

    for (idx, stats) in enumerate(all_stats)
        # Calculate optimal number of bins
        n_samples = length(stats.samples)
        n_bins = min(100, max(30, Int(ceil(sqrt(n_samples)))))

        # Create histogram
        p = histogram(
            stats.samples;
            bins=n_bins,
            normalize=:probability,
            xlabel="Cost (nJ)",
            ylabel="Probability",
            title="Event Sequence $idx",
            legend=:topright,
            color=:steelblue,
            alpha=0.6,
            linecolor=:steelblue,
            linewidth=1,
            titlefontsize=10,
            guidefontsize=8,
            tickfontsize=7,
        )

        # Add vertical line for mean
        vline!(
            [stats.mean];
            color=:red,
            linewidth=2,
            linestyle=:solid,
            label="Mean: $(round(stats.mean, digits=2))",
        )

        # Add vertical lines for ±1 std
        vline!(
            [stats.mean - stats.std, stats.mean + stats.std];
            color=:orange,
            linewidth=1.5,
            linestyle=:dash,
            label="±1σ",
        )

        push!(plots_array, p)
    end

    @info "Creating grid with $(length(plots_array)) plots"

    # Combine into grid
    combined_plot = plot(
        plots_array...;
        layout=(n_rows, n_cols),
        size=(n_cols * 400, n_rows * 300),
        dpi=150,
        margins=3Plots.mm,
        plot_title="Energy Cost Distributions",
        plot_titlefontsize=14,
    )

    # Save or display
    if !isnothing(output_file)
        savefig(combined_plot, output_file)
        @info "Plot saved" path = output_file
    else
        display(combined_plot)
    end

    return nothing
end

"""
Visualize instruction parameter distributions in a grid
Creates subplots showing the Gamma distribution for each instruction type
"""
function visualize_instruction_params(
    params::Dict{Tuple{Vararg{Symbol}},Tuple{Float64,Float64}},
    granularity::ModelGranularity,
    output_file::Union{String,Nothing}=nothing,
)::Nothing
    @info "Visualizing instruction parameters" num_parameters = length(params) granularity

    # Sort parameter keys by string representation for consistent ordering
    sorted_param_keys = sort(collect(keys(params)); by=k -> join(string.(k), "_"))
    n_parameters = length(sorted_param_keys)

    # Calculate grid dimensions (try to make it roughly square)
    n_cols = Int(ceil(sqrt(n_parameters)))
    n_rows = Int(ceil(n_parameters / n_cols))

    # Create subplots
    plots_array = []

    for param_key in sorted_param_keys
        # Convert parameter key tuple to readable string
        param_key_str = join(string.(param_key), "_")
        @info "Visualizing parameter" key = param_key_str
        alpha, beta = params[param_key]

        # Create Gamma distribution
        dist = Gamma(alpha, beta)

        # Generate x values (0 to 99.5th percentile)
        x_max = quantile(dist, 0.995)
        x = range(0, x_max; length=200)
        y = pdf.(dist, x)

        # Calculate mean for annotation
        mean_val = alpha * beta

        # Create subplot
        p = plot(
            x,
            y;
            xlabel="Cost (nJ)",
            ylabel="Density",
            title="$(param_key_str)",
            legend=false,
            color=:steelblue,
            linewidth=2,
            fillrange=0,
            fillalpha=0.3,
            fillcolor=:steelblue,
            titlefontsize=10,
            guidefontsize=8,
            tickfontsize=7,
        )

        # Add mean line
        vline!([mean_val]; color=:red, linewidth=1.5, linestyle=:dash)

        # Add mean annotation
        annotate!(
            x_max * 0.6,
            maximum(y) * 0.9,
            text("μ=$(round(mean_val, digits=2))", 7, :gray20),
        )

        push!(plots_array, p)
    end

    @info "Visualizing $(length(plots_array)) parameters"

    # Combine into grid
    combined_plot = plot(
        plots_array...;
        layout=(n_rows, n_cols),
        size=(n_cols * 300, n_rows * 250),
        dpi=150,
        margins=3Plots.mm,
        plot_title="Instruction Energy Cost Distributions ($(granularity))",
        plot_titlefontsize=14,
    )

    # Save or display
    if !isnothing(output_file)
        savefig(combined_plot, output_file)
        @info "Visualization saved" path = output_file
    else
        display(combined_plot)
    end

    return nothing
end

end # module
