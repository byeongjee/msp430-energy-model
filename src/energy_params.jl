# energy_params.jl - Energy distribution parameters

"""
MSP430 energy parameters optimized for low-power operation
"""
const ENERGY_PARAMS = Dict{Symbol,Tuple{Float64,Float64}}(
    # Dual-operand instructions
    :mov => (1.2, 0.2),      # Register move - very low energy
    :add => (1.5, 0.3),      # Arithmetic - low energy
    :addc => (1.6, 0.35),    # Add with carry - slightly higher
    :sub => (1.5, 0.3),      # Subtraction
    :subc => (1.6, 0.35),    # Subtract with carry
    :cmp => (1.3, 0.25),     # Compare - no result storage
    :dadd => (2.0, 0.4),     # Decimal add - more complex
    :bit => (1.4, 0.3),      # Bit test
    :bic => (1.4, 0.3),      # Bit clear
    :bis => (1.4, 0.3),      # Bit set
    :xor => (1.5, 0.3),      # Exclusive OR
    :and => (1.4, 0.3),      # Logical AND

    # Single-operand instructions
    :rrc => (1.3, 0.25),     # Rotate right through carry
    :swpb => (1.2, 0.2),     # Swap bytes
    :rra => (1.3, 0.25),     # Arithmetic right shift
    :sxt => (1.3, 0.25),     # Sign extend
    :push => (2.0, 0.5),     # Stack operations - memory access
    :call => (2.5, 0.6),     # Function call - stack + jump
    :reti => (2.5, 0.6),     # Return from interrupt
    :clr => (1.1, 0.2),      # Clear register - very low energy
    :ret => (2.0, 0.4),      # Return from subroutine - stack pop
    :inc => (1.2, 0.25),     # Increment - low energy arithmetic

    # Jump instructions - generally low energy
    :jnz => (1.0, 0.2),      # Jump if not zero
    :jz => (1.0, 0.2),       # Jump if zero
    :jnc => (1.0, 0.2),      # Jump if no carry
    :jc => (1.0, 0.2),       # Jump if carry
    :jn => (1.0, 0.2),       # Jump if negative
    :jge => (1.0, 0.2),      # Jump if greater or equal
    :jl => (1.0, 0.2),       # Jump if less
    :jmp => (1.0, 0.2),      # Unconditional jump
)

"""
Add a new instruction type with its energy parameters
"""
function register_instruction!(opcode::Symbol, alpha::Float64, beta::Float64)::Nothing
    ENERGY_PARAMS[opcode] = (alpha, beta)
    return nothing
end

"""
Get energy parameters for an instruction
"""
function get_energy_params(opcode::Symbol)::Tuple{Float64,Float64}
    return get(MSP430_ENERGY_PARAMS, opcode, (2.0, 0.5))  # Default for unknown
end
