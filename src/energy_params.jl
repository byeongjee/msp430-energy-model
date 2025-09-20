# energy_params.jl - Energy distribution parameters

"""
Stateless energy parameters for each instruction type
Using Gamma distributions (shape α, scale β)
"""
const ARM_ENERGY_PARAMS = Dict{Symbol,Tuple{Float64,Float64}}(
    :add => (2.0, 0.5),      # Low energy - arithmetic
    :sub => (2.0, 0.5),
    :mul => (3.0, 0.8),      # Slightly higher for multiplication
    :ldr => (4.0, 1.2),      # Memory load - higher energy
    :str => (4.0, 1.2),      # Memory store
    :mov => (1.5, 0.3),      # Register move - very low energy
    :cmp => (1.8, 0.4),      # Comparison
    :b => (2.5, 0.6),        # Branch
    :nop => (0.5, 0.2),      # No operation - minimal energy
)

"""
MSP430 energy parameters optimized for low-power operation
Generally lower energy consumption than ARM due to 16-bit architecture
"""
const MSP430_ENERGY_PARAMS = Dict{Symbol,Tuple{Float64,Float64}}(
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
Combined energy parameters for both architectures
"""
const ENERGY_PARAMS = merge(ARM_ENERGY_PARAMS, MSP430_ENERGY_PARAMS)

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
    return get(ENERGY_PARAMS, opcode, (2.0, 0.5))  # Default for unknown
end

"""
Get energy parameters specifically for ARM instructions
"""
function get_arm_energy_params(opcode::Symbol)
    return get(ARM_ENERGY_PARAMS, opcode, (5.0, 1.5))  # Default for unknown ARM
end

"""
Get energy parameters specifically for MSP430 instructions
"""
function get_msp430_energy_params(opcode::Symbol)
    return get(MSP430_ENERGY_PARAMS, opcode, (2.0, 0.5))  # Default for unknown MSP430
end

"""
Register all MSP430 instructions with default parameters
"""
function register_msp430_defaults!()
    for (opcode, params) in MSP430_ENERGY_PARAMS
        ENERGY_PARAMS[opcode] = params
    end
end

"""
Get architecture-specific energy parameters
"""
function get_energy_params_for_architecture(opcode::Symbol, architecture::Symbol)
    if architecture == :ARM
        return get_arm_energy_params(opcode)
    elseif architecture == :MSP430
        return get_msp430_energy_params(opcode)
    else
        return get_energy_params(opcode)
    end
end