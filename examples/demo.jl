# demo.jl - Demonstration and examples

push!(LOAD_PATH, "../src")
using ARMEnergyModel
using Logging

function demo()::EnergyStats
    @info "ARM Energy Model Demo"
    @info "="^50

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
    @info "Parsed instructions" count=length(program)

    # Get statistics
    stats = analyze_energy_distribution(program, 1000)
    @info "Energy Statistics:"
    @info "Mean" value=round(stats.mean, digits=2) unit="mJ"
    @info "Std" value=round(stats.std, digits=2) unit="mJ"
    @info "Min" value=round(stats.min, digits=2) unit="mJ"
    @info "Max" value=round(stats.max, digits=2) unit="mJ"

    # Generate visualizations
    @info "Generating visualizations"
    p = comprehensive_energy_analysis(program, 2000)
    display(p)

    return stats
end

function example_comparison()::NamedTuple{(:program1_stats, :program2_stats, :mean_difference, :relative_difference), Tuple{EnergyStats, EnergyStats, Float64, Float64}}
    @info "Comparing two implementations"

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

    @info "Program 1 mean energy" value=round(comparison.program1_stats.mean, digits=2) unit="mJ"
    @info "Program 2 mean energy" value=round(comparison.program2_stats.mean, digits=2) unit="mJ"
    @info "Difference" absolute=round(comparison.mean_difference, digits=2) relative=round(comparison.relative_difference, digits=1) unit="mJ (%)"

    return comparison
end

# Run if called directly
if abspath(PROGRAM_FILE) == @__FILE__
    demo()
    example_comparison()
end