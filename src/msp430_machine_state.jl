# msp430_machine_state.jl - MSP430 machine state management and instruction execution

"""
Abstract type for MSP430 instruction execution
"""
abstract type MSP430InstructionExecutor end

"""
Dual-operand instruction executor
"""
struct DualOperandExecutor <: MSP430InstructionExecutor end

"""
Single-operand instruction executor
"""
struct SingleOperandExecutor <: MSP430InstructionExecutor end

"""
Jump instruction executor
"""
struct JumpExecutor <: MSP430InstructionExecutor end

"""
Get the appropriate executor for an instruction opcode
"""
function get_executor(opcode::Symbol)
    if opcode in [:mov, :add, :addc, :sub, :subc, :cmp, :dadd, :bit, :bic, :bis, :xor, :and]
        return DualOperandExecutor()
    elseif opcode in [:rrc, :swpb, :rra, :sxt, :push, :call, :reti]
        return SingleOperandExecutor()
    elseif opcode in [:jnz, :jz, :jnc, :jc, :jn, :jge, :jl, :jmp]
        return JumpExecutor()
    else
        error("Unknown instruction opcode: $opcode")
    end
end

"""
Execute instruction using trait-based dispatch
"""
function execute!(executor::MSP430InstructionExecutor, state::MSP430MachineState, opcode::Symbol, ops)
    error("execute! not implemented for $(typeof(executor))")
end

"""
Initialize a new MSP430 machine state
"""
function MSP430MachineState()
    # Initialize 16 registers R0-R15
    registers = Dict(Symbol("R$i") => UInt16(0) for i in 0:15)

    # Special register initialization
    registers[:R0] = 0x0000  # Program Counter (PC)
    registers[:R1] = 0xFFFF  # Stack Pointer (SP) - start at top of RAM
    registers[:R2] = 0x0000  # Status Register (SR)
    registers[:R3] = 0x0000  # Constant Generator (CG2)

    # Alternative names for convenience
    registers[:PC] = registers[:R0]
    registers[:SP] = registers[:R1]
    registers[:SR] = registers[:R2]
    registers[:CG2] = registers[:R3]

    MSP430MachineState(
        registers,
        Dict{UInt16,UInt16}(),  # Empty memory
        UInt16(0),              # PC
        UInt16(0xFFFF),         # SP
        UInt16(0),              # SR
        Dict(:V => false, :N => false, :Z => false, :C => false)  # Status flags
    )
end

"""
Execute an MSP430 instruction and update machine state using trait-based dispatch
"""
function execute_msp430_instruction!(state::MSP430MachineState, inst::MSP430Instruction)
    opcode = inst.opcode
    ops = inst.operands

    # Get appropriate executor and execute instruction
    executor = get_executor(opcode)
    execute!(executor, state, opcode, ops)

    # Update PC (most instructions increment by 2 for 16-bit words)
    if opcode != :jmp && !startswith(string(opcode), "j")
        state.pc += 2
        state.registers[:R0] = state.pc
        state.registers[:PC] = state.pc
    end
end

"""
Execute dual-operand instructions using trait dispatch
"""
function execute!(executor::DualOperandExecutor, state::MSP430MachineState, opcode::Symbol, ops)
    execute_dual_operand!(state, opcode, ops)
end

"""
Execute single-operand instructions using trait dispatch
"""
function execute!(executor::SingleOperandExecutor, state::MSP430MachineState, opcode::Symbol, ops)
    execute_single_operand!(state, opcode, ops)
end

"""
Execute jump instructions using trait dispatch
"""
function execute!(executor::JumpExecutor, state::MSP430MachineState, opcode::Symbol, ops)
    execute_jump!(state, opcode, ops)
end

"""
Execute dual-operand instructions (src, dst)
"""
function execute_dual_operand!(state::MSP430MachineState, opcode::Symbol, ops)
    if length(ops) < 2
        return
    end

    src_val = get_operand_value(state, ops[1])
    dst_val = get_operand_value(state, ops[2])

    result = UInt16(0)

    if opcode == :mov
        result = src_val
    elseif opcode == :add
        result = dst_val + src_val
        update_flags!(state, result, dst_val, src_val, true)
    elseif opcode == :addc
        carry = state.flags[:C] ? UInt16(1) : UInt16(0)
        result = dst_val + src_val + carry
        update_flags!(state, result, dst_val, src_val, true)
    elseif opcode == :sub
        result = dst_val - src_val
        update_flags!(state, result, dst_val, src_val, false)
    elseif opcode == :subc
        carry = state.flags[:C] ? UInt16(0) : UInt16(1)  # Inverted for subtraction
        result = dst_val - src_val - carry
        update_flags!(state, result, dst_val, src_val, false)
    elseif opcode == :cmp
        # Compare without storing result
        temp_result = dst_val - src_val
        update_flags!(state, temp_result, dst_val, src_val, false)
        return  # Don't store result for compare
    elseif opcode == :bit
        # Test bits
        temp_result = dst_val & src_val
        update_flags!(state, temp_result, dst_val, src_val, false)
        return  # Don't store result for bit test
    elseif opcode == :bic
        result = dst_val & (~src_val)  # Bit clear
    elseif opcode == :bis
        result = dst_val | src_val     # Bit set
    elseif opcode == :xor
        result = dst_val ⊻ src_val
        update_flags!(state, result, dst_val, src_val, false)
    elseif opcode == :and
        result = dst_val & src_val
        update_flags!(state, result, dst_val, src_val, false)
    end

    # Store result in destination
    set_operand_value!(state, ops[2], result)
end

"""
Execute single-operand instructions
"""
function execute_single_operand!(state::MSP430MachineState, opcode::Symbol, ops)
    if length(ops) < 1
        return
    end

    operand_val = get_operand_value(state, ops[1])
    result = UInt16(0)

    if opcode == :rrc
        # Rotate right through carry
        new_carry = (operand_val & 0x0001) != 0
        result = (operand_val >> 1) | (state.flags[:C] ? 0x8000 : 0x0000)
        state.flags[:C] = new_carry
        update_flags_simple!(state, result)
    elseif opcode == :swpb
        # Swap bytes
        result = ((operand_val & 0x00FF) << 8) | ((operand_val & 0xFF00) >> 8)
    elseif opcode == :rra
        # Arithmetic right shift
        result = UInt16((Int16(operand_val) >> 1) & 0xFFFF)
        state.flags[:C] = (operand_val & 0x0001) != 0
        update_flags_simple!(state, result)
    elseif opcode == :sxt
        # Sign extend byte to word
        if (operand_val & 0x0080) != 0
            result = operand_val | 0xFF00
        else
            result = operand_val & 0x00FF
        end
        update_flags_simple!(state, result)
    elseif opcode == :push
        # Push to stack
        state.sp -= 2
        state.registers[:R1] = state.sp
        state.registers[:SP] = state.sp
        state.memory[state.sp] = operand_val
        return  # Don't store result for push
    elseif opcode == :call
        # Call subroutine
        state.sp -= 2
        state.registers[:R1] = state.sp
        state.registers[:SP] = state.sp
        state.memory[state.sp] = state.pc + 2  # Return address
        state.pc = operand_val
        state.registers[:R0] = state.pc
        state.registers[:PC] = state.pc
        return
    elseif opcode == :reti
        # Return from interrupt
        state.sr = state.memory[state.sp]
        state.sp += 2
        state.pc = state.memory[state.sp]
        state.sp += 2
        state.registers[:R1] = state.sp
        state.registers[:SP] = state.sp
        state.registers[:R0] = state.pc
        state.registers[:PC] = state.pc
        state.registers[:R2] = state.sr
        state.registers[:SR] = state.sr
        return
    end

    # Store result for most single-operand instructions
    if opcode != :push && opcode != :call && opcode != :reti
        set_operand_value!(state, ops[1], result)
    end
end

"""
Execute jump instructions
"""
function execute_jump!(state::MSP430MachineState, opcode::Symbol, ops)
    if length(ops) < 1
        return
    end

    # Get jump offset (signed)
    offset = get_operand_value(state, ops[1])
    should_jump = false

    if opcode == :jmp
        should_jump = true
    elseif opcode == :jnz
        should_jump = !state.flags[:Z]
    elseif opcode == :jz
        should_jump = state.flags[:Z]
    elseif opcode == :jnc
        should_jump = !state.flags[:C]
    elseif opcode == :jc
        should_jump = state.flags[:C]
    elseif opcode == :jn
        should_jump = state.flags[:N]
    elseif opcode == :jge
        should_jump = !(state.flags[:N] ⊻ state.flags[:V])  # N XOR V == 0
    elseif opcode == :jl
        should_jump = (state.flags[:N] ⊻ state.flags[:V])   # N XOR V == 1
    end

    if should_jump
        # Jump is relative to PC + 2
        state.pc = UInt16((Int32(state.pc) + 2 + (Int16(offset) * 2)) & 0xFFFF)
        state.registers[:R0] = state.pc
        state.registers[:PC] = state.pc
    end
end

"""
Get value from operand (register, immediate, or memory)
"""
function get_operand_value(state::MSP430MachineState, operand)
    if isa(operand, Symbol)
        # Register
        return get(state.registers, operand, UInt16(0))
    elseif isa(operand, Integer)
        # Immediate value
        return UInt16(operand & 0xFFFF)
    else
        # Default
        return UInt16(0)
    end
end

"""
Set value to operand (register or memory)
"""
function set_operand_value!(state::MSP430MachineState, operand, value::UInt16)
    if isa(operand, Symbol)
        # Register
        state.registers[operand] = value
        # Update special register aliases
        if operand == :R0 || operand == :PC
            state.pc = value
            state.registers[:R0] = value
            state.registers[:PC] = value
        elseif operand == :R1 || operand == :SP
            state.sp = value
            state.registers[:R1] = value
            state.registers[:SP] = value
        elseif operand == :R2 || operand == :SR
            state.sr = value
            state.registers[:R2] = value
            state.registers[:SR] = value
        end
    end
end

"""
Update status flags after arithmetic operations
"""
function update_flags!(state::MSP430MachineState, result::UInt16, dst::UInt16, src::UInt16, is_add::Bool)
    # Zero flag
    state.flags[:Z] = (result == 0)

    # Negative flag (MSB set)
    state.flags[:N] = (result & 0x8000) != 0

    if is_add
        # Carry flag for addition
        state.flags[:C] = (UInt32(dst) + UInt32(src)) > 0xFFFF

        # Overflow flag for addition (both operands same sign, result different sign)
        dst_sign = (dst & 0x8000) != 0
        src_sign = (src & 0x8000) != 0
        result_sign = (result & 0x8000) != 0
        state.flags[:V] = (dst_sign == src_sign) && (dst_sign != result_sign)
    else
        # Carry flag for subtraction (borrow)
        state.flags[:C] = UInt32(dst) >= UInt32(src)

        # Overflow flag for subtraction
        dst_sign = (dst & 0x8000) != 0
        src_sign = (src & 0x8000) != 0
        result_sign = (result & 0x8000) != 0
        state.flags[:V] = (dst_sign != src_sign) && (dst_sign != result_sign)
    end

    # Update status register
    state.sr = (state.sr & 0xFFF0) |
               (state.flags[:V] ? 0x0100 : 0x0000) |
               (state.flags[:N] ? 0x0004 : 0x0000) |
               (state.flags[:Z] ? 0x0002 : 0x0000) |
               (state.flags[:C] ? 0x0001 : 0x0000)

    state.registers[:R2] = state.sr
    state.registers[:SR] = state.sr
end

"""
Update status flags for simple operations (no carry/overflow calculation)
"""
function update_flags_simple!(state::MSP430MachineState, result::UInt16)
    state.flags[:Z] = (result == 0)
    state.flags[:N] = (result & 0x8000) != 0

    # Update status register
    state.sr = (state.sr & 0xFEF9) |  # Clear N and Z bits
               (state.flags[:N] ? 0x0004 : 0x0000) |
               (state.flags[:Z] ? 0x0002 : 0x0000)

    state.registers[:R2] = state.sr
    state.registers[:SR] = state.sr
end