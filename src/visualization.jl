# visualization.jl - Plotting and visualization functions

using Plots
using StatsPlots
using Distributions

"""
Visualize energy distribution for individual instructions
"""
function plot_instruction_energy_distributions(n_samples::Int=10000)
    plots = []

    for (opcode, (alpha, beta)) in ENERGY_PARAMS
        samples = rand(Gamma(alpha, beta), n_samples)
        println("Generating visualizations for $opcode")

        p = histogram(samples,
            bins=50,
            normalize=:pdf,
            label="Samples",
            title=String(opcode),
            xlabel="Energy (mJ)",
            ylabel="Probability Density",
            fillalpha=0.6,
            color=:skyblue)

        x_range = range(0, maximum(samples) * 1.1, length=200)
        y_pdf = pdf.(Gamma(alpha, beta), x_range)
        plot!(p, x_range, y_pdf,
            linewidth=2,
            color=:red,
            label="Gamma($(alpha), $(beta))")

        push!(plots, p)
    end

    final_plot = plot(plots...,
        layout=(3, 3),
        size=(1200, 900),
        plot_title="Energy Distributions by Instruction Type")

    return final_plot
end

"""
Visualize energy distribution for a complete program
"""
function plot_program_energy_distribution(program::Vector{ARMInstruction},
    n_samples::Int=5000)
    stats = analyze_energy_distribution(program, n_samples)
    energies = stats.samples

    p = histogram(energies,
        bins=50,
        normalize=:pdf,
        label="Program Energy",
        title="Total Program Energy Distribution",
        xlabel="Total Energy (mJ)",
        ylabel="Probability Density",
        fillalpha=0.7,
        color=:green)

    vline!(p, [stats.mean],
        linewidth=2,
        color=:red,
        label="Mean: $(round(stats.mean, digits=2)) mJ",
        linestyle=:dash)

    vline!(p, [stats.mean - stats.std, stats.mean + stats.std],
        linewidth=1.5,
        color=:orange,
        label="±1 std: $(round(stats.std, digits=2)) mJ",
        linestyle=:dot)

    return p
end

"""
Visualize per-instruction energy breakdown
"""
function plot_instruction_breakdown(program::Vector{ARMInstruction}, n_samples::Int=1000)
    stats = analyze_instruction_energies(program, n_samples)

    data = []
    labels = String[]

    for i in 1:length(program)
        push!(data, stats[i].samples)
        push!(labels, "$(i). $(program[i].opcode)")
    end

    p = boxplot(data,
        label=reshape(labels, 1, :),
        title="Energy Distribution by Instruction",
        ylabel="Energy (mJ)",
        xlabel="Instruction",
        legend=false,
        color=:auto,
        fillalpha=0.7)

    plot!(p, xrotation=45)

    return p
end

"""
Plot cumulative energy consumption
"""
function plot_cumulative_energy(program::Vector{ARMInstruction}, n_traces::Int=100)
    cumulative_energies = []

    for _ in 1:n_traces
        trace = simulate(interpret_arm_program, (program,))
        cumulative = Float64[0.0]

        for i in 1:length(program)
            push!(cumulative, cumulative[end] + trace[:energy=>i])
        end

        push!(cumulative_energies, cumulative)
    end

    p = plot(title="Cumulative Energy Consumption",
        xlabel="Instruction Number",
        ylabel="Cumulative Energy (mJ)",
        legend=:topleft)

    for (i, cum_energy) in enumerate(cumulative_energies)
        plot!(p, 0:length(program), cum_energy,
            alpha=0.1,
            color=:blue,
            label=(i == 1 ? "Individual traces" : ""))
    end

    mean_cumulative = [mean([c[i] for c in cumulative_energies]) for i in 1:length(cumulative_energies[1])]
    plot!(p, 0:length(program), mean_cumulative,
        linewidth=3,
        color=:red,
        label="Mean")

    return p
end

"""
Create comprehensive analysis visualization
"""
function comprehensive_energy_analysis(program::Vector{ARMInstruction}, n_samples::Int=5000)
    p1 = plot_program_energy_distribution(program, n_samples)
    p2 = plot_instruction_breakdown(program, min(n_samples, 1000))
    p3 = plot_cumulative_energy(program, 100)

    combined = plot(p1, p2, p3,
        layout=(2, 2),
        size=(1400, 1000),
        plot_title="Comprehensive Energy Analysis")

    return combined
end