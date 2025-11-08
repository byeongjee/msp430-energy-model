# gamma_per_instruction.jl - Gamma model with per-instruction (opcode) granularity

"""
Gamma distribution model with per-instruction (opcode) granularity.
"""
function GammaPerInstruction()
    return GammaModel(PerOpcode)
end
