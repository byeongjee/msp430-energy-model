# BaselineEstimation.jl - Simple mean-based energy estimation baseline

module BaselineEstimation

using Statistics
using Logging

# Include core types
include("types.jl")

using Main.Inference: TrainingData, ModelGranularity, get_instruction_key

export learn_mean_parameters, estimate_energy_baseline

"""
Learn simple mean energy per instruction from training data.
For each program: finds dominant instruction key, then accumulates total energy and
instruction count for that key across all programs. Computes weighted average by
dividing total energy by total instruction count for each key.

# Arguments
- `energies`: Vector of total energy measurements (one per program)
- `programs`: Vector of instruction sequences (one per program)
- `granularity`: Model granularity level

# Returns
Dictionary mapping instruction keys to mean energy per instruction (Float64)
"""
function learn_mean_parameters(
    energies::Vector{Float64},
    programs::Vector{Vector{Instruction}},
    granularity::ModelGranularity,
)::Dict{Tuple{Vararg{Symbol}},Float64}
    @info "Learning baseline mean parameters"
    @info "Training data" num_programs = length(energies) granularity

    if length(energies) != length(programs)
        error(
            "Number of energies ($(length(energies))) must match number of programs ($(length(programs)))",
        )
    end

    start_time = time()

    # Accumulate total energy and instruction count for each dominant key
    total_energy = Dict{Tuple{Vararg{Symbol}},Float64}()
    total_instructions = Dict{Tuple{Vararg{Symbol}},Int}()

    for (energy, program) in zip(energies, programs)
        dominant_key = get_dominant_key(program, granularity)

        # Accumulate for this key
        num_instructions = length(program)
        total_energy[dominant_key] = get(total_energy, dominant_key, 0.0) + energy
        total_instructions[dominant_key] =
            get(total_instructions, dominant_key, 0) + num_instructions
    end

    # Compute mean energy per instruction (weighted average)
    mean_params = Dict{Tuple{Vararg{Symbol}},Float64}()

    for key in keys(total_energy)
        mean_energy = total_energy[key] / total_instructions[key]
        mean_params[key] = mean_energy

        @info "Learned mean energy per instruction" param_key = key mean_energy = round(
            mean_energy; digits=6
        ) total_insts = total_instructions[key]
    end

    learning_time = time() - start_time
    @info "Baseline learning complete" time = learning_time num_params = length(mean_params)

    return mean_params
end

"""
Estimate total energy for a program using mean-based parameters.
Sums up mean energies for each instruction in the program.

# Arguments
- `program`: Sequence of instructions
- `mean_params`: Dictionary mapping instruction keys to mean energy
- `granularity`: Model granularity level

# Returns
Estimated total energy (Float64)
"""
function estimate_energy_baseline(
    program::Vector{Instruction},
    mean_params::Dict{Tuple{Vararg{Symbol}},Float64},
    granularity::ModelGranularity,
)::Float64
    total_energy = 0.0
    unknown_keys = Set{Tuple{Vararg{Symbol}}}()

    for inst in program
        key = get_instruction_key(inst, granularity)

        if haskey(mean_params, key)
            total_energy += mean_params[key]
        else
            # Use default if not found
            push!(unknown_keys, key)
            total_energy += 1.0  # Default 1nJ per instruction
        end
    end

    if !isempty(unknown_keys)
        @warn "Unknown instruction keys in estimation" keys = unknown_keys using_default =
            1.0
    end

    return total_energy
end

end # module
