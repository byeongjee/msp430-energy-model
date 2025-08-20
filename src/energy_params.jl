# energy_params.jl - Energy distribution parameters

"""
Stateless energy parameters for each instruction type
Using Gamma distributions (shape α, scale β)
"""
const ENERGY_PARAMS = Dict{Symbol,Tuple{Float64,Float64}}(
    :add => (2.0, 0.5),      # Low energy - arithmetic
    :sub => (2.0, 0.5),
    :mul => (3.0, 0.8),      # Slightly higher for multiplication
    :ldr => (4.0, 1.2),      # Memory load - higher energy
    :str => (4.0, 1.2),      # Memory store
    :mov => (1.5, 0.3),      # Register move - very low energy
    :cmp => (1.8, 0.4),      # Comparison
    :b => (2.5, 0.6),      # Branch
    :nop => (0.5, 0.2),      # No operation - minimal energy
)

"""
Add a new instruction type with its energy parameters
"""
function register_instruction!(opcode::Symbol, alpha::Float64, beta::Float64)
    ENERGY_PARAMS[opcode] = (alpha, beta)
end

"""
Get energy parameters for an instruction
"""
function get_energy_params(opcode::Symbol)
    return get(ENERGY_PARAMS, opcode, (5.0, 1.5))  # Default for unknown
end