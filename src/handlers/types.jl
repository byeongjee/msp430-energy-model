# types.jl - Instruction handler type hierarchy
#
# This file defines the abstract and concrete handler types for MSP430 instructions.
# Each handler type corresponds to one or more related instructions.

# ============================================================================
# Abstract Type Hierarchy
# ============================================================================

"""
Abstract base type for all instruction handlers.
Each handler implements:
- execute!(state, handler, ops, data_size, addresses, current_idx)
- optionally: should_advance_pc(handler, state, ops) [default: true]
"""
abstract type AbstractInstructionHandler end

"""
Handler for dual-operand instructions (src, dst)
"""
abstract type DualOperandHandler <: AbstractInstructionHandler end

"""
Handler for single-operand instructions
"""
abstract type SingleOperandHandler <: AbstractInstructionHandler end

"""
Handler for jump/conditional branch instructions
"""
abstract type JumpHandler <: AbstractInstructionHandler end

# ============================================================================
# Concrete Handler Types (one per instruction or group of similar instructions)
# ============================================================================

# Dual operand handlers
struct MovHandler <: DualOperandHandler end
struct AddHandler <: DualOperandHandler end
struct AddcHandler <: DualOperandHandler end
struct SubHandler <: DualOperandHandler end
struct SubcHandler <: DualOperandHandler end
struct CmpHandler <: DualOperandHandler end
struct DaddHandler <: DualOperandHandler end
struct BitHandler <: DualOperandHandler end
struct BicHandler <: DualOperandHandler end
struct BisHandler <: DualOperandHandler end
struct XorHandler <: DualOperandHandler end
struct AndHandler <: DualOperandHandler end

# Single operand handlers
struct RrcHandler <: SingleOperandHandler end
struct RrcmHandler <: SingleOperandHandler end
struct SwpbHandler <: SingleOperandHandler end
struct RraHandler <: SingleOperandHandler end
struct RruxHandler <: SingleOperandHandler end
struct RrumHandler <: SingleOperandHandler end
struct SxtHandler <: SingleOperandHandler end
struct InvHandler <: SingleOperandHandler end
struct PushHandler <: SingleOperandHandler end
struct CallHandler <: SingleOperandHandler end
struct RetiHandler <: SingleOperandHandler end
struct ClrHandler <: SingleOperandHandler end
struct RetHandler <: SingleOperandHandler end
struct CallaHandler <: SingleOperandHandler end
struct RetaHandler <: SingleOperandHandler end
struct IncHandler <: SingleOperandHandler end
struct DecHandler <: SingleOperandHandler end
struct DintHandler <: SingleOperandHandler end
struct EintHandler <: SingleOperandHandler end
struct SetcHandler <: SingleOperandHandler end
struct ClrcHandler <: SingleOperandHandler end
struct RlcHandler <: SingleOperandHandler end
struct NopHandler <: SingleOperandHandler end
struct BrHandler <: SingleOperandHandler end
struct PushmHandler <: SingleOperandHandler end
struct PopmHandler <: SingleOperandHandler end
struct PopHandler <: SingleOperandHandler end
struct RlaHandler <: SingleOperandHandler end
struct RlamHandler <: SingleOperandHandler end
struct SbcHandler <: SingleOperandHandler end
struct AdcHandler <: SingleOperandHandler end
struct DecdHandler <: SingleOperandHandler end
struct IncdHandler <: SingleOperandHandler end
struct RptHandler <: SingleOperandHandler end

# Jump handlers
struct JnzHandler <: JumpHandler end
struct JzHandler <: JumpHandler end
struct JncHandler <: JumpHandler end
struct JcHandler <: JumpHandler end
struct JnHandler <: JumpHandler end
struct JgeHandler <: JumpHandler end
struct JlHandler <: JumpHandler end
struct JmpHandler <: JumpHandler end
