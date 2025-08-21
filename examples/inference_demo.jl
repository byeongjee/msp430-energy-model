# inference_demo.jl - Demonstration of parameter inference system

using ARMEnergyModel
using Distributions
using Plots

# Create some example training programs
function create_training_data()
    # Program 1: Simple arithmetic
    program1 = [
        ARMInstruction(:mov, [:r1, 10]),
        ARMInstruction(:mov, [:r2, 20]),
        ARMInstruction(:add, [:r3, :r1, :r2]),
    ]

    # Program 2: Memory operations
    program2 = [
        ARMInstruction(:mov, [:r1, 100]),
        ARMInstruction(:mov, [:r4, 0x1000]),  # Load address into register
        ARMInstruction(:str, [:r1, :r4]),     # Store r1 to address in r4
        ARMInstruction(:ldr, [:r2, :r4]),     # Load from address in r4 to r2
        ARMInstruction(:add, [:r3, :r1, :r2]),
    ]

    # Program 3: Loop-like structure
    program3 = [
        ARMInstruction(:mov, [:r1, 0]),
        ARMInstruction(:mov, [:r2, 5]),
        ARMInstruction(:cmp, [:r1, :r2]),
        ARMInstruction(:add, [:r1, :r1, 1]),
        ARMInstruction(:b, [-3]),  # Simple branch back
    ]

    # Program 4: Multiplication heavy
    program4 = [
        ARMInstruction(:mov, [:r1, 3]),
        ARMInstruction(:mov, [:r2, 7]),
        ARMInstruction(:mul, [:r3, :r1, :r2]),
        ARMInstruction(:mul, [:r4, :r3, :r3]),
    ]

    programs = [program1, program2, program3, program4]

    # Simulate "observed" energy consumption for these programs
    # In a real scenario, these would come from actual measurements
    println("Generating simulated training data...")

    observed_energies = Float64[]
    for program in programs
        # Use current model to generate "realistic" observations with some noise
        stats = analyze_energy_distribution(program, 100)
        # Add some measurement noise
        noisy_energy = stats.mean + randn() * stats.std * 0.1
        push!(observed_energies, max(0.1, noisy_energy))  # Ensure positive
    end

    return TrainingData(programs, observed_energies)
end

function demo_parameter_learning()
    println("=== Parameter Inference Demo ===\n")

    # Create training data
    training_data = create_training_data()

    println("Training Programs:")
    for (i, (program, energy)) in enumerate(zip(training_data.programs, training_data.energies))
        println("Program $i (observed energy: $(round(energy, digits=3))):")
        for inst in program
            println("  $(inst.opcode) $(inst.operands)")
        end
        println()
    end

    # Show original parameters
    println("Original (fixed) parameters:")
    all_opcodes = Set{Symbol}()
    for program in training_data.programs
        for inst in program
            push!(all_opcodes, inst.opcode)
        end
    end

    for opcode in sort(collect(all_opcodes))
        alpha, beta = get_energy_params(opcode)
        println("  $opcode: α=$alpha, β=$beta (mean=$(round(alpha*beta, digits=3)))")
    end
    println()

    # Learn parameters using MLE approach (faster for demo)
    println("Learning parameters from training data...")
    learned_params = learn_parameters_mle(training_data)

    println("Learned parameters:")
    for opcode in sort(collect(keys(learned_params)))
        alpha, beta = learned_params[opcode]
        println("  $opcode: α=$(round(alpha, digits=3)), β=$(round(beta, digits=3)) (mean=$(round(alpha*beta, digits=3)))")
    end
    println()

    # Test prediction on new programs
    println("Testing prediction on new programs...")

    # New test program
    test_program = [
        ARMInstruction(:mov, [:r1, 42]),
        ARMInstruction(:mov, [:r5, 0x2000]),
        ARMInstruction(:ldr, [:r2, :r5]),
        ARMInstruction(:add, [:r3, :r1, :r2]),
        ARMInstruction(:mov, [:r6, 0x3000]),
        ARMInstruction(:str, [:r3, :r6]),
    ]

    println("Test program:")
    for inst in test_program
        println("  $(inst.opcode) $(inst.operands)")
    end

    # Predict with original parameters
    original_stats = analyze_energy_distribution(test_program, 1000)

    # Predict with learned parameters
    learned_stats = predict_energy(test_program, learned_params, n_samples=1000)

    println("\nPrediction Results:")
    println("Original model: mean=$(round(original_stats.mean, digits=3)), std=$(round(original_stats.std, digits=3))")
    println("Learned model:  mean=$(round(learned_stats.mean, digits=3)), std=$(round(learned_stats.std, digits=3))")

    # Evaluate on training data
    println("\nEvaluation on training data:")
    evaluation = evaluate_parameters(learned_params, training_data)
    println("MSE: $(round(evaluation.mse, digits=4))")
    println("MAE: $(round(evaluation.mae, digits=4))")
    println("Correlation: $(round(evaluation.correlation, digits=4))")

    # Create visualizations
    println("\nGenerating visualizations...")

    # 1. Parameter comparison plot
    println("Creating parameter comparison plot...")
    param_plot = plot_parameter_comparison(learned_params)

    # 2. Training evaluation plot  
    println("Creating training evaluation plot...")
    eval_plot = plot_training_evaluation(learned_params, training_data)

    # 3. Test program prediction comparison
    println("Creating test program prediction comparison...")
    pred_plot = plot_prediction_comparison(test_program, learned_params)

    # 4. Show individual instruction distributions for learned parameters
    println("Creating learned instruction distributions...")
    learned_instruction_plots = []
    for opcode in sort(collect(keys(learned_params)))
        alpha, beta = learned_params[opcode]
        samples = rand(Gamma(alpha, beta), 5000)

        p = histogram(samples,
            bins=30,
            normalize=:pdf,
            alpha=0.7,
            color=:red,
            title="$opcode - Learned Distribution",
            xlabel="Energy (mJ)",
            ylabel="PDF",
            label="Γ($(round(alpha,digits=2)), $(round(beta,digits=2)))")

        # Add mean line
        vline!(p, [alpha * beta],
            color=:black,
            linewidth=2,
            linestyle=:dash,
            label="Mean: $(round(alpha*beta, digits=2))")

        push!(learned_instruction_plots, p)
    end

    # Determine layout based on number of plots
    n_plots = length(learned_instruction_plots)
    if n_plots <= 6
        layout_dims = (2, 3)
        plot_size = (1200, 600)
    else
        layout_dims = (3, 3)  # Can accommodate up to 9 plots
        plot_size = (1200, 900)
    end
    
    learned_dist_plot = plot(learned_instruction_plots...,
        layout=layout_dims,
        size=plot_size,
        plot_title="Learned Energy Distributions by Instruction Type")
    
    # Save individual plots
    println("Saving plots to files...")
    savefig(param_plot, "parameter_comparison.png")
    savefig(eval_plot, "training_evaluation.png") 
    savefig(pred_plot, "prediction_comparison.png")
    savefig(learned_dist_plot, "learned_distributions.png")
    
    # Create comprehensive summary plot
    println("Creating comprehensive summary...")
    summary_plot = plot(param_plot, eval_plot, pred_plot, learned_dist_plot,
        layout=(2, 2),
        size=(1600, 1200),
        plot_title="Inference Demo - Complete Analysis")
    
    savefig(summary_plot, "inference_summary.png")
    display(summary_plot)
    
    println("\nPlots saved:")
    println("  - parameter_comparison.png: Original vs learned parameters")
    println("  - training_evaluation.png: Training data fit quality") 
    println("  - prediction_comparison.png: Test program predictions")
    println("  - learned_distributions.png: Individual instruction distributions")
    println("  - inference_summary.png: All plots combined")

    return learned_params
end

# Run the demo
if abspath(PROGRAM_FILE) == @__FILE__
    learned_params = demo_parameter_learning()
end