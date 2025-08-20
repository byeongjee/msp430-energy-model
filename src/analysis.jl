# analysis.jl - Statistical analysis functions

using Statistics
using Gen

"""
Analyze energy distribution by sampling from the program multiple times
"""
function analyze_energy_distribution(program::Vector{ARMInstruction}, n_samples::Int=1000)
    model = interpret_arm_program

    energies = Float64[]
    for _ in 1:n_samples
        trace = simulate(model, (program,))
        push!(energies, get_retval(trace))
    end

    return EnergyStats(
        mean(energies),
        std(energies),
        minimum(energies),
        maximum(energies),
        energies
    )
end

"""
Get per-instruction energy statistics
"""
function analyze_instruction_energies(program::Vector{ARMInstruction}, n_samples::Int=1000)
    instruction_stats = Dict{Int,EnergyStats}()
    instruction_energies = Dict{Int,Vector{Float64}}()

    # Collect samples
    for _ in 1:n_samples
        trace = simulate(interpret_arm_program, (program,))
        for i in 1:length(program)
            if !haskey(instruction_energies, i)
                instruction_energies[i] = Float64[]
            end
            push!(instruction_energies[i], trace[:energy=>i])
        end
    end

    # Calculate statistics
    for i in 1:length(program)
        energies = instruction_energies[i]
        instruction_stats[i] = EnergyStats(
            mean(energies),
            std(energies),
            minimum(energies),
            maximum(energies),
            energies
        )
    end

    return instruction_stats
end

"""
Compare two programs' energy efficiency
"""
function compare_programs(program1::Vector{ARMInstruction},
    program2::Vector{ARMInstruction},
    n_samples::Int=1000)
    stats1 = analyze_energy_distribution(program1, n_samples)
    stats2 = analyze_energy_distribution(program2, n_samples)

    return (
        program1_stats=stats1,
        program2_stats=stats2,
        mean_difference=stats2.mean - stats1.mean,
        relative_difference=(stats2.mean - stats1.mean) / stats1.mean * 100
    )
end