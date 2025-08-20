# demo.jl - Demonstration and examples

push!(LOAD_PATH, "../src")
using ARMEnergyModel

function demo()
    println("ARM Energy Model Demo")
    println("="^50)

    # Example program
    asm_code = [
        "mov r0, #10",
        "mov r1, #20",
        "add r2, r0, r1",
        "mul r3, r2, r0",
        "str r3, [sp]",
        "ldr r4, [sp]",
        "cmp r4, r3",
        "nop"
    ]

    # Parse and analyze
    program = parse_arm_assembly(asm_code)
    println("\\nParsed $(length(program)) instructions")

    # Get statistics
    stats = analyze_energy_distribution(program, 1000)
    println("\\nEnergy Statistics:")
    println("  Mean: $(round(stats.mean, digits=2)) mJ")
    println("  Std:  $(round(stats.std, digits=2)) mJ")
    println("  Min:  $(round(stats.min, digits=2)) mJ")
    println("  Max:  $(round(stats.max, digits=2)) mJ")

    # Generate visualizations
    println("\\nGenerating visualizations...")
    p = comprehensive_energy_analysis(program, 2000)
    display(p)

    return stats
end

function example_comparison()
    println("\\nComparing two implementations...")

    # Implementation 1: Using multiplication
    prog1 = parse_arm_assembly([
        "mov r0, #10",
        "mov r1, #20",
        "mul r2, r0, r1"
    ])

    # Implementation 2: Using repeated addition
    prog2 = parse_arm_assembly([
        "mov r0, #10",
        "mov r1, #20",
        "mov r2, #0",
        "add r2, r2, r0",
        "add r2, r2, r0"
    ])

    comparison = compare_programs(prog1, prog2, 1000)

    println("Program 1 mean energy: $(round(comparison.program1_stats.mean, digits=2)) mJ")
    println("Program 2 mean energy: $(round(comparison.program2_stats.mean, digits=2)) mJ")
    println("Difference: $(round(comparison.mean_difference, digits=2)) mJ ($(round(comparison.relative_difference, digits=1))%)")

    return comparison
end

# Run if called directly
if abspath(PROGRAM_FILE) == @__FILE__
    demo()
    example_comparison()
end