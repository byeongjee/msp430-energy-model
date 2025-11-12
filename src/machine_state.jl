"""
Initialize a new MSP430 machine state
"""
function MachineState()::MachineState
    # Initialize registers using proper MSP430 names
    # PC (Program Counter), SP (Stack Pointer), SR (Status Register), R3-R15
    registers = Dict{Symbol,UInt32}(
        :PC => 0x00000,   # Program Counter (R0)
        :SP => 0xFFFFF,   # Stack Pointer (R1) - start at top of RAM
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
        Dict{UInt32,UInt16}(),  # Empty memory. Each cell is 16 bits.
        Dict(:V => false, :N => false, :Z => false, :C => false),  # Status flags
    )
end

"""
Executor wrapper for dual-operand instructions (with PC advance)
"""
function dual_operand_executor!(
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_dual_operand!(state, opcode, ops, data_size)
    # Advance PC to next instruction, unless destination is PC (R0)
    # mov/mova to PC acts as a branch instruction
    if current_idx < length(addresses)
        # Check if destination operand is PC (R0 is normalized to :PC by parser)
        if length(ops) >= 2 && ops[2].mode == :register && ops[2].value == :PC
            # Destination is PC, don't advance (PC was set by the instruction)
            return nothing
        end
        state.registers[:PC] = addresses[current_idx + 1]
    end
    return nothing
end

"""
Executor wrapper for single-operand instructions (with conditional PC advance)
"""
function single_operand_executor!(
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_single_operand!(state, opcode, ops, data_size, addresses, current_idx)
    # call, ret, reti, br manage their own PC, others need to advance
    if opcode != :call &&
        opcode != :ret &&
        opcode != :reti &&
        opcode != :br &&
        current_idx < length(addresses)
        state.registers[:PC] = addresses[current_idx + 1]
    end
    return nothing
end

"""
Executor wrapper for jump instructions (PC managed by jump logic)
"""
function jump_executor!(
    state::MachineState,
    opcode::Symbol,
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    execute_jump!(state, opcode, ops, addresses, current_idx)
    return nothing
end

# Direct opcode-to-executor function mapping for O(1) dispatch
const EXECUTORS = Dict{Symbol,Function}(
    # Dual operand instructions
    :mov => dual_operand_executor!,
    :mova => dual_operand_executor!,  # Move address (20-bit) - same as mov, data_size set by parser
    :add => dual_operand_executor!,
    :addc => dual_operand_executor!,
    :sub => dual_operand_executor!,
    :subc => dual_operand_executor!,
    :cmp => dual_operand_executor!,
    :dadd => dual_operand_executor!,
    :bit => dual_operand_executor!,
    :bic => dual_operand_executor!,
    :bis => dual_operand_executor!,
    :xor => dual_operand_executor!,
    :and => dual_operand_executor!,
    # Single operand instructions
    :rrc => single_operand_executor!,
    :swpb => single_operand_executor!,
    :rra => single_operand_executor!,
    :sxt => single_operand_executor!,
    :push => single_operand_executor!,
    :call => single_operand_executor!,
    :reti => single_operand_executor!,
    :clr => single_operand_executor!,
    :ret => single_operand_executor!,
    :inc => single_operand_executor!,
    :dec => single_operand_executor!,
    :dint => single_operand_executor!,
    :nop => single_operand_executor!,
    :br => single_operand_executor!,  # Branch (mov src, PC)
    :pushm => single_operand_executor!,
    :popm => single_operand_executor!,
    :rla => single_operand_executor!,
    :rlam => single_operand_executor!,
    :sbc => single_operand_executor!,
    :adc => single_operand_executor!,
    :decd => single_operand_executor!,
    :incd => single_operand_executor!,
    # Jump instructions
    :jnz => jump_executor!,
    :jz => jump_executor!,
    :jnc => jump_executor!,
    :jc => jump_executor!,
    :jn => jump_executor!,
    :jge => jump_executor!,
    :jl => jump_executor!,
    :jmp => jump_executor!,
)

"""
Execute an MSP430 instruction with proper PC management using instruction addresses
"""
function execute_instruction!(
    state::MachineState, inst::Instruction, addresses::Vector{UInt32}, current_idx::Int
)::Nothing
    opcode = inst.opcode
    ops = inst.operands
    data_size = inst.data_size

    # Look up and call the appropriate executor function
    executor = get(EXECUTORS, opcode) do
        error("Unknown instruction opcode: $opcode")
    end
    executor(state, opcode, ops, data_size, addresses, current_idx)
    return nothing
end

"""
Execute dual-operand instructions (src, dst)
"""
function execute_dual_operand!(
    state::MachineState, opcode::Symbol, ops::Vector{Operand}, data_size::Symbol=:word
)::Nothing
    if length(ops) < 2
        return nothing
    end

    src_val = get_operand_value(state, ops[1], data_size)
    dst_val = get_operand_value(state, ops[2], data_size)

    result = UInt32(0)

    if opcode == :mov || opcode == :mova
        result = src_val
    elseif opcode == :add
        result = UInt32(dst_val + src_val)
        update_flags!(state, result, dst_val, src_val, true, data_size)
    elseif opcode == :addc
        carry = state.flags[:C] ? UInt32(1) : UInt32(0)
        result = UInt32(dst_val + src_val + carry)
        update_flags!(state, result, dst_val, src_val, true, data_size)
    elseif opcode == :sub
        result = UInt32(dst_val - src_val)
        update_flags!(state, result, dst_val, src_val, false, data_size)
    elseif opcode == :subc
        carry = state.flags[:C] ? UInt32(0) : UInt32(1)  # Inverted for subtraction
        result = UInt32(dst_val - src_val - carry)
        update_flags!(state, result, dst_val, src_val, false, data_size)
    elseif opcode == :cmp
        # Compare without storing result
        temp_result = UInt32(dst_val - src_val)
        update_flags!(state, temp_result, dst_val, src_val, false, data_size)
        return nothing  # Don't store result for compare
    elseif opcode == :bit
        # Test bits
        temp_result = UInt32(dst_val & src_val)
        update_flags!(state, temp_result, dst_val, src_val, false, data_size)
        return nothing  # Don't store result for bit test
    elseif opcode == :bic
        result = UInt32(dst_val & (~src_val))
    elseif opcode == :bis
        result = UInt32(dst_val | src_val)
    elseif opcode == :xor
        result = UInt32(dst_val ⊻ src_val)
        update_flags!(state, result, dst_val, src_val, false, data_size)
    elseif opcode == :and
        result = UInt32(dst_val & src_val)
        update_flags!(state, result, dst_val, src_val, false, data_size)
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
    ops::Vector{Operand},
    data_size::Symbol,
    addresses::Vector{UInt32},
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
    result = UInt32(0)

    if opcode == :rrc
        # Rotate right through carry
        new_carry = (operand_val & 0x0001) != 0
        result = UInt32((operand_val >> 1) | (state.flags[:C] ? 0x8000 : 0x0000))
        state.flags[:C] = new_carry
        update_flags_simple!(state, result, data_size)
    elseif opcode == :swpb
        # Swap bytes
        result = UInt32(((operand_val & 0x00FF) << 8) | ((operand_val & 0xFF00) >> 8))
    elseif opcode == :rra
        # Arithmetic right shift
        result = UInt32(Int32(operand_val) >> 1)
        state.flags[:C] = (operand_val & 0x0001) != 0
        update_flags_simple!(state, result, data_size)
    elseif opcode == :sxt
        # Sign extend byte to word
        if (operand_val & 0x0080) != 0
            result = UInt32(operand_val | 0xFF00)
        else
            result = UInt32(operand_val & 0x00FF)
        end
        update_flags_simple!(state, result, data_size)
    elseif opcode == :push
        # Push to stack
        state.registers[:SP] = state.registers[:SP] - 2
        state.memory[state.registers[:SP]] = UInt16(operand_val & 0xFFFF)
        return nothing  # Don't store result for push
    elseif opcode == :call
        # Call subroutine
        if current_idx >= length(addresses)
            error(
                "Call instruction at index $current_idx has no next instruction for return address",
            )
        end
        return_addr = addresses[current_idx + 1]
        # CALL instruction only supports 16-bit return addresses
        # For 20-bit addresses, MSP430X uses CALLA instead
        if return_addr > 0xFFFF
            error(
                "CALL instruction cannot handle return address 0x$(string(return_addr, base=16)) > 0xFFFF. Use CALLA for 20-bit addresses.",
            )
        end
        state.registers[:SP] = state.registers[:SP] - 2
        state.memory[state.registers[:SP]] = UInt16(return_addr)  # Return address (16-bit)
        state.registers[:PC] = operand_val
        return nothing
    elseif opcode == :br
        # Branch (indirect jump) - mov src, PC
        # Loads the operand value into PC to branch to that address
        state.registers[:PC] = operand_val
        return nothing
    elseif opcode == :clr
        # Clear (set to zero) - emulated as MOV #0, dst
        result = UInt32(0)
    elseif opcode == :inc
        # Increment operand by 1
        operand_val = get_operand_value(state, ops[1])
        result = UInt32(operand_val + 1)
        update_flags!(state, result, operand_val, UInt32(1), true, data_size)
    elseif opcode == :dec
        # Decrement operand by 1
        operand_val = get_operand_value(state, ops[1])
        result = UInt32(operand_val - 1)
        update_flags!(state, result, operand_val, UInt32(1), false, data_size)
    elseif opcode == :decd
        # Double decrement (emulated instruction: sub #2, dst)
        operand_val = get_operand_value(state, ops[1])
        result = UInt32(operand_val - 2)
        update_flags!(state, result, operand_val, UInt32(2), false, data_size)
    elseif opcode == :incd
        # Double increment (emulated instruction: add #2, dst)
        operand_val = get_operand_value(state, ops[1])
        result = UInt32(operand_val + 2)
        update_flags!(state, result, operand_val, UInt32(2), true, data_size)
    elseif opcode == :sbc
        # SBC is an emulated instruction: sbc dst == subc #0, dst
        # It subtracts the carry flag from the destination
        carry = state.flags[:C] ? UInt32(0) : UInt32(1)  # Inverted for subtraction
        result = UInt32(operand_val - carry)
        update_flags!(state, result, operand_val, UInt32(0), false, data_size)
    elseif opcode == :adc
        # ADC is an emulated instruction: adc dst == addc #0, dst
        # It adds the carry flag to the destination
        carry = state.flags[:C] ? UInt32(1) : UInt32(0)
        result = UInt32(operand_val + carry)
        update_flags!(state, result, operand_val, UInt32(0), true, data_size)
    elseif opcode == :rla
        # Rotate left arithmetic (shift left, carry gets MSB, LSB gets 0)
        operand_val = get_operand_value(state, ops[1])
        new_carry = (operand_val & 0x8000) != 0
        result = UInt32(operand_val << 1)
        state.flags[:C] = new_carry
        update_flags_simple!(state, result, data_size)
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
                result = result << 1
                state.flags[:C] = new_carry
            end

            update_flags_simple!(state, result, data_size)
            set_operand_value!(state, ops[2], result, data_size)
            return nothing
        end
    elseif opcode == :pushm
        # Push multiple registers: pushm[.w|.a] #n, Rdst
        # Pushes n registers from Rdst-n+1 to Rdst
        # .w (word): 16-bit values, 2 bytes per register
        # .a (address): 20-bit values, 4 bytes per register (2 words)
        if length(ops) >= 2
            n = get_operand_value(state, ops[1])
            dst_reg = ops[2].value  # Extract register symbol from Operand
            dst_num = Parser.reg_symbol_to_num(dst_reg)

            # Determine stack adjustment per register based on data_size
            bytes_per_reg = if data_size == :address
                4  # 20-bit = 2 words = 4 bytes
            else
                2  # 16-bit = 1 word = 2 bytes
            end

            for i in (dst_num - n + 1):dst_num
                if i >= 0 && i <= 15
                    reg_sym = Parser.reg_num_to_symbol(i)
                    reg_val = get_register_value(state, reg_sym)

                    # Adjust stack pointer before push
                    state.registers[:SP] = state.registers[:SP] - bytes_per_reg

                    # Store value based on data_size
                    if data_size == :address
                        set_memory_value!(state, state.registers[:SP], reg_val, :address)
                    else
                        state.memory[state.registers[:SP]] = UInt16(reg_val & 0xFFFF)
                    end
                end
            end
        end
        return nothing
    elseif opcode == :popm
        # Pop multiple registers: popm[.w|.a] #n, Rdst
        # Pops n registers from Rdst-n+1 to Rdst in REVERSE order (stack grows down)
        # .w (word): 16-bit values, 2 bytes per register
        # .a (address): 20-bit values, 4 bytes per register (2 words)
        if length(ops) >= 2
            n = get_operand_value(state, ops[1])
            dst_reg = ops[2].value  # Extract register symbol from Operand
            dst_num = Parser.reg_symbol_to_num(dst_reg)

            # Determine stack adjustment per register based on data_size
            bytes_per_reg = if data_size == :address
                4  # 20-bit = 2 words = 4 bytes
            else
                2  # 16-bit = 1 word = 2 bytes
            end

            # Pop in reverse order: from Rdst down to Rdst-n+1
            for i in dst_num:-1:(dst_num - n + 1)
                if i >= 0 && i <= 15
                    reg_sym = Parser.reg_num_to_symbol(i)

                    # Load value based on data_size
                    reg_val = if data_size == :address
                        get_memory_value(state, state.registers[:SP], :address)
                    else
                        UInt32(get(state.memory, state.registers[:SP], UInt16(0)))
                    end

                    set_register_value!(state, reg_sym, reg_val)

                    # Adjust stack pointer after pop
                    state.registers[:SP] = state.registers[:SP] + bytes_per_reg
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
    ops::Vector{Operand},
    addresses::Vector{UInt32},
    current_idx::Int,
)::Nothing
    if length(ops) < 1
        return nothing
    end

    # Get jump offset from symbolic addressing mode operand
    # Jumps use symbolic (PC-relative) addressing: operand.value is (offset, :PC)
    # Extract offset directly (don't read from memory like data instructions do)
    @assert ops[1].mode == :symbolic "Jump instructions must use symbolic addressing mode, got $(ops[1].mode)"
    @assert isa(ops[1].value, Tuple) "Jump operand value must be Tuple, got $(typeof(ops[1].value))"
    @assert length(ops[1].value) == 2 "Jump operand value must be (offset, :PC), got tuple of length $(length(ops[1].value))"
    jump_offset, reg = ops[1].value
    @assert reg == :PC "Jump operand register must be :PC, got $reg"
    @assert isa(jump_offset, Integer) "Jump offset must be Integer, got $(typeof(jump_offset))"
    offset = reinterpret(Int16, UInt16(jump_offset & 0xFFFF))
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

function get_register_mask(register::Symbol)::UInt32
    # PC (R0) and SP (R1) are always 20-bit
    if register == :PC || register == :SP
        return 0xFFFFF
        # SR (R2) is always 16-bit (status register)
    elseif register == :SR
        return 0xFFFF
        # R3 is constant generator, 16-bit
    elseif register == :R3
        return 0xFFFF
        # R4-R15 are general purpose registers, can hold 20-bit values in MSP430X
    else
        return 0xFFFFF
    end
end

function get_register_value(state::MachineState, register::Symbol)::UInt32
    value = UInt32(state.registers[register])
    @assert value <= get_register_mask(register) "Register $register value must be less than or equal to $(get_register_mask(register)), got $value"
    return value
end

function set_register_value!(state::MachineState, register::Symbol, value::UInt32)::Nothing
    @assert value <= get_register_mask(register) "Register $register value must be less than or equal to $(get_register_mask(register)), got $value"
    state.registers[register] = value
    return nothing
end

function apply_data_size_mask(value::UInt32, data_size::Symbol)::UInt32
    if data_size == :word
        return value & 0xFFFF
    elseif data_size == :byte
        return value & 0xFF
    elseif data_size == :address
        return value & 0xFFFFF
    else
        error("Unknown data size: $data_size")
    end
end

function get_memory_value(state::MachineState, addr::UInt32, data_size::Symbol)::UInt32
    if data_size == :word
        # Read 16-bit word from memory
        return UInt32(get(state.memory, addr, UInt16(0)))
    elseif data_size == :byte
        # Read byte from memory
        # For even addresses: read lower byte (mask 0xFF)
        # For odd addresses: read upper byte (mask 0xFF00)
        word = get(state.memory, addr & ~UInt32(1), UInt16(0))  # Align to even address
        if (addr & 1) == 0
            # Even address: lower byte
            return UInt32(word & 0xFF)
        else
            # Odd address: upper byte
            return UInt32((word & 0xFF00) >> 8)
        end
    elseif data_size == :address
        # Read 20-bit address (two words: lsw at addr, msw at addr+2)
        lsw = get(state.memory, addr, UInt16(0))
        msw = get(state.memory, addr + 2, UInt16(0))
        # Combine: lower 16 bits from lsw, upper 4 bits from msw
        return UInt32(lsw) | (UInt32(msw & 0xF) << 16)
    else
        error("Unknown data size: $data_size")
    end
end

function set_memory_value!(
    state::MachineState, addr::UInt32, value::UInt32, data_size::Symbol
)::Nothing
    if data_size == :word
        # Write 16-bit word to memory
        state.memory[addr] = UInt16(value & 0xFFFF)
    elseif data_size == :byte
        # Write byte to memory
        # For even addresses: write to lower byte
        # For odd addresses: write to upper byte
        aligned_addr = addr & ~UInt32(1)  # Align to even address
        old_word = get(state.memory, aligned_addr, UInt16(0))
        if (addr & 1) == 0
            # Even address: write to lower byte
            new_word = UInt16((old_word & 0xFF00) | (value & 0xFF))
        else
            # Odd address: write to upper byte
            new_word = UInt16((old_word & 0x00FF) | ((value & 0xFF) << 8))
        end
        state.memory[aligned_addr] = new_word
    elseif data_size == :address
        # Write 20-bit address (two words: lsw at addr, msw at addr+2)
        lsw = UInt16(value & 0xFFFF)
        msw = UInt16((value >> 16) & 0xF)
        state.memory[addr] = lsw
        state.memory[addr + 2] = msw
    else
        error("Unknown data size: $data_size")
    end
    return nothing
end

"""
Get value from operand (register, immediate, or memory)
"""
function get_operand_value(
    state::MachineState, operand::Operand, data_size::Symbol=:word
)::UInt32
    value = if operand.mode == :immediate
        # Immediate value
        @assert isa(operand.value, Integer) "Immediate mode: operand.value must be Integer, got $(typeof(operand.value))"
        UInt32(operand.value)
    elseif operand.mode == :register
        # Register
        @assert isa(operand.value, Symbol) "Register mode: operand.value must be Symbol, got $(typeof(operand.value))"
        get_register_value(state, operand.value)
    elseif operand.mode == :indirect
        # Indirect addressing: @R1 means "value at address contained in R1"
        @assert isa(operand.value, Symbol) "Indirect mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Remove @ prefix
        addr = get_register_value(state, reg_name)
        get_memory_value(state, addr, data_size)
    elseif operand.mode == :autoincrement
        # Autoincrement addressing: @R1+ means "value at address in R1, then increment R1"
        @assert isa(operand.value, Symbol) "Autoincrement mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Remove @ prefix
        addr = get_register_value(state, reg_name)
        val = get_memory_value(state, addr, data_size)
        # Increment register after reading (by 2 for word, 1 for byte)
        increment = data_size == :byte ? UInt32(1) : UInt32(2)
        state.registers[reg_name] = UInt32((addr + increment) & get_register_mask(reg_name))
        val
    elseif operand.mode == :indexed || operand.mode == :symbolic
        # Indexed addressing: X(Rn) -> (Rn + X) points to operand
        # Symbolic addressing: X(PC) -> (PC + X) points to operand
        # Both use same mechanism: (base_register + offset)
        @assert isa(operand.value, Tuple) "Indexed/Symbolic mode: operand.value must be Tuple, got $(typeof(operand.value))"
        @assert length(operand.value) == 2 "Indexed/Symbolic mode: operand.value must be (offset, register), got tuple of length $(length(operand.value))"
        offset, reg = operand.value
        @assert isa(offset, Integer) "Indexed/Symbolic mode: offset must be Integer, got $(typeof(offset))"
        @assert isa(reg, Symbol) "Indexed/Symbolic mode: register must be Symbol, got $(typeof(reg))"
        if operand.mode == :symbolic
            @assert reg == :PC "Symbolic mode: register must be :PC, got $reg"
        end
        base_addr = get_register_value(state, reg)
        # For symbolic mode, PC points to current instruction but the offset is in the next word
        # So we need to use PC+2 (after the opcode word is fetched)
        if operand.mode == :symbolic
            base_addr = UInt32((base_addr + 2) & get_register_mask(reg))
        end
        addr = UInt32((base_addr + offset) & get_register_mask(reg))
        get_memory_value(state, addr, data_size)
    elseif operand.mode == :absolute
        # Absolute addressing: &address
        @assert isa(operand.value, Integer) "Absolute mode: operand.value must be Integer, got $(typeof(operand.value))"
        get_memory_value(state, operand.value, data_size)
    else
        error("Unknown addressing mode: $(operand.mode)")
    end

    # Apply data size mask
    return apply_data_size_mask(value, data_size)
end

"""
Set value to operand (register or memory)
"""
function set_operand_value!(
    state::MachineState, operand::Operand, value::UInt32, data_size::Symbol=:word
)::Nothing
    # Apply data size mask to value
    masked_value = apply_data_size_mask(value, data_size)

    if operand.mode == :register
        # Register
        @assert isa(operand.value, Symbol) "Register mode: operand.value must be Symbol, got $(typeof(operand.value))"
        set_register_value!(state, operand.value, masked_value)
    elseif operand.mode == :indexed || operand.mode == :symbolic
        # Indexed addressing: X(Rn) -> (Rn + X) points to operand
        # Symbolic addressing: X(PC) -> (PC + X) points to operand
        @assert isa(operand.value, Tuple) "Indexed/Symbolic mode: operand.value must be Tuple, got $(typeof(operand.value))"
        @assert length(operand.value) == 2 "Indexed/Symbolic mode: operand.value must be (offset, register), got tuple of length $(length(operand.value))"
        offset, reg = operand.value
        @assert isa(offset, Integer) "Indexed/Symbolic mode: offset must be Integer, got $(typeof(offset))"
        @assert isa(reg, Symbol) "Indexed/Symbolic mode: register must be Symbol, got $(typeof(reg))"
        if operand.mode == :symbolic
            @assert reg == :PC "Symbolic mode: register must be :PC, got $reg"
        end
        base_addr = get_register_value(state, reg)
        # For symbolic mode, PC points to current instruction but the offset is in the next word
        # So we need to use PC+2 (after the opcode word is fetched)
        if operand.mode == :symbolic
            base_addr = UInt32((base_addr + 2) & get_register_mask(reg))
        end
        # FIXME: for implementation simplicity, we assume that the address is 16-bit aligned
        addr = UInt32((base_addr + offset) & get_register_mask(reg))

        set_memory_value!(state, addr, masked_value, data_size)
    elseif operand.mode == :absolute
        # Absolute addressing: &address
        @assert isa(operand.value, Integer) "Absolute mode: operand.value must be Integer, got $(typeof(operand.value))"
        set_memory_value!(state, operand.value, masked_value, data_size)
    else
        error("Cannot set value for addressing mode: $(operand.mode)")
    end
    return nothing
end

"""
Update status flags after arithmetic operations
"""
function update_flags!(
    state::MachineState,
    result::UInt32,
    dst::UInt32,
    src::UInt32,
    is_add::Bool,
    data_size::Symbol=:word,
)::Nothing
    # Get the appropriate mask and MSB bit for the data size
    max_val, msb_bit = if data_size == :byte
        (UInt32(0xFF), UInt32(0x80))
    elseif data_size == :word
        (UInt32(0xFFFF), UInt32(0x8000))
    elseif data_size == :address
        (UInt32(0xFFFFF), UInt32(0x80000))
    else
        error("Unknown data size: $data_size")
    end

    # Zero flag
    state.flags[:Z] = (result == 0)

    # Negative flag (MSB set)
    state.flags[:N] = (result & msb_bit) != 0

    if is_add
        # Carry flag for addition
        state.flags[:C] = (dst + src) > max_val

        # Overflow flag for addition (both operands same sign, result different sign)
        dst_sign = (dst & msb_bit) != 0
        src_sign = (src & msb_bit) != 0
        result_sign = (result & msb_bit) != 0
        state.flags[:V] = (dst_sign == src_sign) && (dst_sign != result_sign)
    else
        # Carry flag for subtraction (borrow)
        state.flags[:C] = dst >= src

        # Overflow flag for subtraction
        dst_sign = (dst & msb_bit) != 0
        src_sign = (src & msb_bit) != 0
        result_sign = (result & msb_bit) != 0
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
function update_flags_simple!(
    state::MachineState, result::UInt32, data_size::Symbol=:word
)::Nothing
    # Get the appropriate MSB bit for the data size
    msb_bit = if data_size == :byte
        UInt32(0x80)
    elseif data_size == :word
        UInt32(0x8000)
    elseif data_size == :address
        UInt32(0x80000)
    else
        error("Unknown data size: $data_size")
    end

    state.flags[:Z] = (result == 0)
    state.flags[:N] = (result & msb_bit) != 0

    # Update status register
    state.registers[:SR] =
        (state.registers[:SR] & 0xFEF9) |  # Clear N and Z bits
        (state.flags[:N] ? 0x0004 : 0x0000) |
        (state.flags[:Z] ? 0x0002 : 0x0000)

    return nothing
end
