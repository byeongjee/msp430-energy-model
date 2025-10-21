# msp430_machine_state.jl - MSP430 machine state management and instruction execution

"""
Abstract type for MSP430 instruction execution
"""
abstract type InstructionExecutor end

"""
Dual-operand instruction executor
"""
struct DualOperandExecutor <: InstructionExecutor end

"""
Single-operand instruction executor
"""
struct SingleOperandExecutor <: InstructionExecutor end

"""
Jump instruction executor
"""
struct JumpExecutor <: InstructionExecutor end

# Cache executor instances
const DUAL_EXECUTOR = DualOperandExecutor()
const SINGLE_EXECUTOR = SingleOperandExecutor()
const JUMP_EXECUTOR = JumpExecutor()

# Pre-build executor lookup table for O(1) access
const EXECUTOR_MAP = Dict{Symbol,InstructionExecutor}(
    # Dual operand instructions
    :mov => DUAL_EXECUTOR,
    :add => DUAL_EXECUTOR,
    :addc => DUAL_EXECUTOR,
    :sub => DUAL_EXECUTOR,
    :subc => DUAL_EXECUTOR,
    :cmp => DUAL_EXECUTOR,
    :dadd => DUAL_EXECUTOR,
    :bit => DUAL_EXECUTOR,
    :bic => DUAL_EXECUTOR,
    :bis => DUAL_EXECUTOR,
    :xor => DUAL_EXECUTOR,
    :and => DUAL_EXECUTOR,
    # Single operand instructions
    :rrc => SINGLE_EXECUTOR,
    :swpb => SINGLE_EXECUTOR,
    :rra => SINGLE_EXECUTOR,
    :sxt => SINGLE_EXECUTOR,
    :push => SINGLE_EXECUTOR,
    :call => SINGLE_EXECUTOR,
    :reti => SINGLE_EXECUTOR,
    :clr => SINGLE_EXECUTOR,
    :ret => SINGLE_EXECUTOR,
    :inc => SINGLE_EXECUTOR,
    :dec => SINGLE_EXECUTOR,
    :dint => SINGLE_EXECUTOR,
    :nop => SINGLE_EXECUTOR,
    :pushm => SINGLE_EXECUTOR,
    :popm => SINGLE_EXECUTOR,
    :rla => SINGLE_EXECUTOR,
    :rlam => SINGLE_EXECUTOR,
    :sbc => SINGLE_EXECUTOR,
    # Jump instructions
    :jnz => JUMP_EXECUTOR,
    :jz => JUMP_EXECUTOR,
    :jnc => JUMP_EXECUTOR,
    :jc => JUMP_EXECUTOR,
    :jn => JUMP_EXECUTOR,
    :jge => JUMP_EXECUTOR,
    :jl => JUMP_EXECUTOR,
    :jmp => JUMP_EXECUTOR,
)

"""
Get the appropriate executor for an instruction opcode
"""
function get_executor(opcode::Symbol)::InstructionExecutor
    return get(EXECUTOR_MAP, opcode) do
        error("Unknown instruction opcode: $opcode")
    end
end

"""
Execute instruction using trait-based dispatch
"""
function execute!(
    executor::InstructionExecutor,
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Any},
    data_size::Symbol,
    addresses::Vector{UInt16},
    current_idx::Int,
)::Nothing
    error("execute! not implemented for $(typeof(executor))")
end

"""
Initialize a new MSP430 machine state
"""
function MachineState()::MachineState
    # Initialize registers using proper MSP430 names
    # PC (Program Counter), SP (Stack Pointer), SR (Status Register), R3-R15
    registers = Dict{Symbol,UInt16}(
        :PC => 0x0000,   # Program Counter (R0)
        :SP => 0xFFFF,   # Stack Pointer (R1) - start at top of RAM
        :SR => 0x0000,   # Status Register (R2)
        :R3 => 0x0000,   # Constant Generator
        :R4 => 0x0000,
        :R5 => 0x0000,
        :R6 => 0x0000,
        :R7 => 0x0000,
        :R8 => 0x0000,
        :R9 => 0x0000,
        :R10 => 0x0000,
        :R11 => 0x0000,
        :R12 => 0x0000,
        :R13 => 0x0000,
        :R14 => 0x0000,
        :R15 => 0x0000,
    )

    MachineState(
        registers,
        Dict{UInt16,UInt16}(),  # Empty memory
        Dict(:V => false, :N => false, :Z => false, :C => false),  # Status flags
    )
end

"""
Execute an MSP430 instruction with proper PC management using instruction addresses
"""
function execute_instruction!(
    state::MachineState, inst::Instruction, addresses::Vector{UInt16}, current_idx::Int
)::Nothing
    opcode = inst.opcode
    ops = inst.operands
    data_size = inst.data_size

    # Get appropriate executor and execute instruction
    executor = get_executor(opcode)
    execute!(executor, state, opcode, ops, data_size, addresses, current_idx)
    return nothing
end

"""
Execute dual-operand instructions using trait dispatch
"""
function execute!(
    executor::DualOperandExecutor,
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Any},
    data_size::Symbol,
    addresses::Vector{UInt16},
    current_idx::Int,
)::Nothing
    execute_dual_operand!(state, opcode, ops, data_size)
    # Advance PC to next instruction
    if current_idx < length(addresses)
        state.registers[:PC] = addresses[current_idx + 1]
    end
    return nothing
end

"""
Execute single-operand instructions using trait dispatch
"""
function execute!(
    executor::SingleOperandExecutor,
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Any},
    data_size::Symbol,
    addresses::Vector{UInt16},
    current_idx::Int,
)::Nothing
    execute_single_operand!(state, opcode, ops, data_size, addresses, current_idx)
    # call, ret, reti manage their own PC, others need to advance
    if opcode != :call &&
        opcode != :ret &&
        opcode != :reti &&
        current_idx < length(addresses)
        state.registers[:PC] = addresses[current_idx + 1]
    end
    return nothing
end

"""
Execute jump instructions using trait dispatch
"""
function execute!(
    executor::JumpExecutor,
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Any},
    data_size::Symbol,
    addresses::Vector{UInt16},
    current_idx::Int,
)::Nothing
    execute_jump!(state, opcode, ops, addresses, current_idx)
    return nothing
end

"""
Execute dual-operand instructions (src, dst)
"""
function execute_dual_operand!(
    state::MachineState, opcode::Symbol, ops::Vector{Any}, data_size::Symbol=:word
)::Nothing
    if length(ops) < 2
        return nothing
    end

    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)

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
        return nothing  # Don't store result for compare
    elseif opcode == :bit
        # Test bits
        temp_result = dst_val & src_val
        update_flags!(state, temp_result, dst_val, src_val, false)
        return nothing  # Don't store result for bit test
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
    set_operand_value!(state, ops[2], result, data_size)
    return nothing
end

"""
Execute single-operand instructions
"""
function execute_single_operand!(
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Any},
    data_size::Symbol,
    addresses::Vector{UInt16},
    current_idx::Int,
)::Nothing
    # Handle instructions that don't need operands first
    if opcode == :ret
        # Return from subroutine (pop PC from stack)
        return_addr = get(state.memory, state.registers[:SP], UInt16(0))
        state.registers[:PC] = return_addr
        state.registers[:SP] = state.registers[:SP] + 2
        return nothing
    elseif opcode == :nop
        # No operation - do nothing
        return nothing
    elseif opcode == :dint
        # Disable interrupt - clear Global Interrupt Enable bit in SR
        state.registers[:SR] = state.registers[:SR] & ~0x0008  # Clear GIE bit (bit 3)
        return nothing
    elseif opcode == :reti
        # Return from interrupt
        state.registers[:SR] = state.memory[state.registers[:SP]]
        state.registers[:SP] = state.registers[:SP] + 2
        state.registers[:PC] = state.memory[state.registers[:SP]]
        state.registers[:SP] = state.registers[:SP] + 2
        return nothing
    end

    if length(ops) < 1
        return nothing
    end

    operand_val = get_operand_value(state, ops[1], data_size)
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
        state.registers[:SP] = state.registers[:SP] - 2
        state.memory[state.registers[:SP]] = operand_val
        return nothing  # Don't store result for push
    elseif opcode == :call
        # Call subroutine
        if current_idx >= length(addresses)
            error(
                "Call instruction at index $current_idx has no next instruction for return address",
            )
        end
        return_addr = addresses[current_idx + 1]
        state.registers[:SP] = state.registers[:SP] - 2
        state.memory[state.registers[:SP]] = return_addr  # Return address
        state.registers[:PC] = operand_val
        return nothing
    elseif opcode == :clr
        # Clear (set to zero)
        result = UInt16(0)
        update_flags_simple!(state, result)
    elseif opcode == :inc
        # Increment operand by 1
        operand_val = get_operand_value(state, ops[1])
        result = UInt16((operand_val + 1) & 0xFFFF)
        update_flags_simple!(state, result)
    elseif opcode == :dec
        # Decrement operand by 1
        operand_val = get_operand_value(state, ops[1])
        result = UInt16((operand_val - 1) & 0xFFFF)
        update_flags_simple!(state, result)
    elseif opcode == :sbc
        # SBC is an emulated instruction: sbc dst == subc #0, dst
        # It subtracts the carry flag from the destination
        carry = state.flags[:C] ? UInt16(0) : UInt16(1)  # Inverted for subtraction
        result = UInt16((operand_val - carry) & 0xFFFF)
        update_flags!(state, result, operand_val, UInt16(0), false)
    elseif opcode == :rla
        # Rotate left arithmetic (shift left, carry gets MSB, LSB gets 0)
        operand_val = get_operand_value(state, ops[1])
        new_carry = (operand_val & 0x8000) != 0
        result = UInt16((operand_val << 1) & 0xFFFF)
        state.flags[:C] = new_carry
        update_flags_simple!(state, result)
    elseif opcode == :rlam
        # Rotate left arithmetic multiple times
        # Format: rlam #n, Rdst where n is 1-4
        if length(ops) >= 2
            shift_count = get_operand_value(state, ops[1])
            dst_val = get_operand_value(state, ops[2])

            # Perform the rotation shift_count times
            result = dst_val
            for i in 1:shift_count
                new_carry = (result & 0x8000) != 0
                result = UInt16((result << 1) & 0xFFFF)
                state.flags[:C] = new_carry
            end

            update_flags_simple!(state, result)
            set_operand_value!(state, ops[2], result, data_size)
            return nothing
        end
    elseif opcode == :pushm
        # Push multiple registers: pushm #n, Rdst
        # Pushes n registers from Rdst-n+1 to Rdst
        if length(ops) >= 2
            n = get_operand_value(state, ops[1])
            dst_reg = ops[2]
            dst_num = reg_symbol_to_num(dst_reg)

            for i in (dst_num - n + 1):dst_num
                if i >= 0 && i <= 15
                    reg_sym = reg_num_to_symbol(i)
                    reg_val = get(state.registers, reg_sym, UInt16(0))
                    state.registers[:SP] = state.registers[:SP] - 2
                    state.memory[state.registers[:SP]] = reg_val
                end
            end
        end
        return nothing
    elseif opcode == :popm
        # Pop multiple registers: popm #n, Rdst
        # Pops n registers from Rdst-n+1 to Rdst
        if length(ops) >= 2
            n = get_operand_value(state, ops[1])
            dst_reg = ops[2]
            dst_num = reg_symbol_to_num(dst_reg)

            for i in (dst_num - n + 1):dst_num
                if i >= 0 && i <= 15
                    reg_sym = reg_num_to_symbol(i)
                    reg_val = get(state.memory, state.registers[:SP], UInt16(0))
                    state.registers[reg_sym] = reg_val
                    state.registers[:SP] = state.registers[:SP] + 2
                end
            end
        end
        return nothing
    end

    # Store result for single-operand instructions that modify their operand
    # Instructions that handle their own logic and don't need to store result here:
    # - push, pushm, popm: stack operations
    # - call, ret, reti: control flow
    # - nop, dint: no side effects on operands
    instructions_that_dont_store_result = [
        :push, :call, :reti, :ret, :nop, :dint, :pushm, :popm
    ]
    if opcode ∉ instructions_that_dont_store_result
        set_operand_value!(state, ops[1], result, data_size)
    end
    return nothing
end

"""
Execute jump instructions
"""
function execute_jump!(
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Any},
    addresses::Vector{UInt16},
    current_idx::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end

    # Get jump offset (keep as signed for relative jumps)
    offset = if isa(ops[1], Integer)
        Int16(ops[1])  # Keep as signed integer
    else
        Int16(get_operand_value(state, ops[1]))  # Convert from other types
    end
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
        state.registers[:PC] = UInt16(
            (Int32(state.registers[:PC]) + 2 + (Int32(offset) * 2)) & 0xFFFF
        )
    else
        # Advance to next instruction
        if current_idx < length(addresses)
            state.registers[:PC] = addresses[current_idx + 1]
        end
    end
    return nothing
end

"""
Get value from operand (register, immediate, or memory)
"""
function get_operand_value(
    state::MachineState, operand::Any, data_size::Symbol=:word
)::UInt16
    if isa(operand, Integer)
        # Immediate value - most common case first
        value = UInt16(operand & 0xFFFF)
    elseif isa(operand, Symbol)
        # Check if it's indirect addressing (@register)
        operand_str = string(operand)
        if !isempty(operand_str) && operand_str[1] == '@'
            # Indirect addressing: @R1 means "value at address contained in R1"
            reg_name = Symbol(operand_str[2:end])  # Remove @ prefix
            addr = get(state.registers, reg_name, UInt16(0))
            value = get(state.memory, addr, UInt16(0))
        else
            # Regular register
            value = get(state.registers, operand, UInt16(0))
        end
    elseif isa(operand, Tuple)
        # Indexed addressing: (offset, register) -> offset(register)
        offset, reg = operand
        base_addr = get(state.registers, reg, UInt16(0))
        addr = UInt16((base_addr + offset) & 0xFFFF)
        value = get(state.memory, addr, UInt16(0))
    else
        value = UInt16(0)
    end

    # Apply data size mask
    return data_size == :byte ? UInt16(value & 0xFF) : value
end

"""
Set value to operand (register or memory)
"""
function set_operand_value!(
    state::MachineState, operand::Any, value::UInt16, data_size::Symbol=:word
)::Nothing
    # Apply data size mask to value
    masked_value = if data_size == :byte
        UInt16(value & 0xFF)  # Keep only lower 8 bits
    else
        value  # Full 16-bit word
    end

    if isa(operand, Symbol)
        # Register
        state.registers[operand] = masked_value
    elseif isa(operand, Tuple) && length(operand) == 2
        # Indexed addressing: (offset, register) -> offset(register)
        offset, reg = operand
        base_addr = get(state.registers, reg, UInt16(0))
        addr = UInt16((base_addr + offset) & 0xFFFF)

        if data_size == :byte
            # For byte operations to memory, only modify lower 8 bits
            old_value = get(state.memory, addr, UInt16(0))
            new_value = UInt16((old_value & 0xFF00) | masked_value)
            state.memory[addr] = new_value
        else
            state.memory[addr] = masked_value
        end
    end
    return nothing
end

"""
Update status flags after arithmetic operations
"""
function update_flags!(
    state::MachineState, result::UInt16, dst::UInt16, src::UInt16, is_add::Bool
)::Nothing
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
    state.registers[:SR] =
        (state.registers[:SR] & 0xFFF0) |
        (state.flags[:V] ? 0x0100 : 0x0000) |
        (state.flags[:N] ? 0x0004 : 0x0000) |
        (state.flags[:Z] ? 0x0002 : 0x0000) |
        (state.flags[:C] ? 0x0001 : 0x0000)

    return nothing
end

"""
Update status flags for simple operations (no carry/overflow calculation)
"""
function update_flags_simple!(state::MachineState, result::UInt16)::Nothing
    state.flags[:Z] = (result == 0)
    state.flags[:N] = (result & 0x8000) != 0

    # Update status register
    state.registers[:SR] =
        (state.registers[:SR] & 0xFEF9) |  # Clear N and Z bits
        (state.flags[:N] ? 0x0004 : 0x0000) |
        (state.flags[:Z] ? 0x0002 : 0x0000)

    return nothing
end
