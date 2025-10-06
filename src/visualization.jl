# visualization.jl - Plotting and visualization functions

using Plots
using StatsPlots
using Distributions
using Logging

"""
Visualize energy distribution for individual instructions
"""
function plot_instruction_energy_distributions(n_samples::Int=10000)
    plots = []

    for (opcode, (alpha, beta)) in ENERGY_PARAMS
        samples = rand(Gamma(alpha, beta), n_samples)
        @debug "Generating visualization" opcode

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

"""
Visualize comparison between original and learned parameters
"""
function plot_parameter_comparison(learned_params::Dict{Symbol,Tuple{Float64,Float64}}, 
                                 n_samples::Int=10000)
    opcodes = sort(collect(keys(learned_params)))
    plots = []
    
    for opcode in opcodes
        # Original parameters
        orig_alpha, orig_beta = get_energy_params(opcode)
        orig_samples = rand(Gamma(orig_alpha, orig_beta), n_samples)
        
        # Learned parameters  
        learned_alpha, learned_beta = learned_params[opcode]
        learned_samples = rand(Gamma(learned_alpha, learned_beta), n_samples)
        
        # Create comparison plot
        p = histogram(orig_samples,
            bins=50,
            normalize=:pdf,
            alpha=0.6,
            color=:blue,
            label="Original Γ($(round(orig_alpha,digits=2)), $(round(orig_beta,digits=2)))",
            title=String(opcode),
            xlabel="Energy (mJ)",
            ylabel="PDF")
            
        histogram!(p, learned_samples,
            bins=50, 
            normalize=:pdf,
            alpha=0.6,
            color=:red,
            label="Learned Γ($(round(learned_alpha,digits=2)), $(round(learned_beta,digits=2)))")
            
        push!(plots, p)
    end
    
    final_plot = plot(plots...,
        layout=(length(plots) > 6 ? (3, 3) : (2, 3)),
        size=(1200, 800),
        plot_title="Original vs Learned Parameter Distributions")
        
    return final_plot
end

"""
Visualize prediction comparison for a test program
"""
function plot_prediction_comparison(program::Vector{ARMInstruction},
                                  learned_params::Dict{Symbol,Tuple{Float64,Float64}},
                                  n_samples::Int=5000)
    # Get predictions from original model
    original_stats = analyze_energy_distribution(program, n_samples)
    
    # Get predictions from learned model
    learned_stats = predict_energy(program, learned_params, n_samples=n_samples)
    
    # Create comparison plot
    p = histogram(original_stats.samples,
        bins=50,
        normalize=:pdf,
        alpha=0.6,
        color=:blue,
        label="Original Model",
        title="Energy Prediction Comparison",
        xlabel="Total Energy (mJ)",
        ylabel="PDF")
        
    histogram!(p, learned_stats.samples,
        bins=50,
        normalize=:pdf, 
        alpha=0.6,
        color=:red,
        label="Learned Model")
        
    # Add mean lines
    vline!(p, [original_stats.mean],
        color=:blue,
        linewidth=2,
        linestyle=:dash,
        label="Original Mean: $(round(original_stats.mean, digits=2))")
        
    vline!(p, [learned_stats.mean],
        color=:red,
        linewidth=2, 
        linestyle=:dash,
        label="Learned Mean: $(round(learned_stats.mean, digits=2))")
        
    return p
end

"""
Visualize training vs prediction accuracy
"""
function plot_training_evaluation(learned_params::Dict{Symbol,Tuple{Float64,Float64}},
                                training_data::TrainingData,
                                n_samples::Int=1000)
    evaluation = evaluate_parameters(learned_params, training_data, n_samples=n_samples)
    
    p = scatter(evaluation.actual, evaluation.predictions,
        xlabel="Actual Energy (mJ)",
        ylabel="Predicted Energy (mJ)", 
        title="Training Data: Actual vs Predicted Energy",
        label="Programs",
        color=:blue,
        markersize=8,
        alpha=0.7)
        
    # Add perfect prediction line
    min_val = min(minimum(evaluation.actual), minimum(evaluation.predictions))
    max_val = max(maximum(evaluation.actual), maximum(evaluation.predictions))
    plot!(p, [min_val, max_val], [min_val, max_val],
        color=:red,
        linewidth=2,
        linestyle=:dash,
        label="Perfect Prediction")
        
    # Add correlation info
    corr_text = "Correlation: $(round(evaluation.correlation, digits=3))\nMSE: $(round(evaluation.mse, digits=4))"
    annotate!(p, [(max_val * 0.1, max_val * 0.9, text(corr_text, 10, :left))])
    
    return p
end