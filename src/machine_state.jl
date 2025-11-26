# Include the instruction handler dispatch system
include("instruction_handlers.jl")

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
        0,  # repeat_counter initialized to 0
    )
end

"""
Execute an MSP430 instruction with proper PC management using instruction addresses.

This function uses the instruction handler dispatch system to:
1. Get the appropriate handler for the instruction opcode
2. Execute the instruction using multiple dispatch
3. Centrally manage PC updates based on the handler's should_advance_pc predicate
"""
function execute_instruction!(
    state::MachineState, inst::Instruction, addresses::Vector{UInt32}, current_idx::Int
)::Nothing
    # Get handler for this instruction
    handler = get_handler(inst.opcode)

    # Execute instruction using multiple dispatch
    execute!(state, handler, inst.operands, inst.data_size, addresses, current_idx)

    # Handle RPT instruction: if repeat_counter > 0, decrement and don't advance PC
    # unless it's the RPT instruction itself (which sets the counter)
    if state.repeat_counter > 0 && inst.opcode != :rpt
        state.repeat_counter -= 1
        # Don't advance PC - re-execute same instruction
        return nothing
    end

    # Centralized PC update logic
    if should_advance_pc(handler, state, inst.operands) && current_idx < length(addresses)
        state.registers[:PC] = addresses[current_idx + 1]
    end

    return nothing
end

# ============================================================================
# Instruction execution logic has been moved to instruction_handlers.jl
# Each instruction now has its own execute! method using multiple dispatch.
# This makes adding new instructions much easier - see instruction_handlers.jl
# for details.
# ============================================================================

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

"""
Debug output memory-mapped addresses for interpreter visibility.
Programs can write to these addresses to output debug information.
Using 0x1BF0 region: reserved space between peripherals and RAM on MSP430FR5994.
"""
const DEBUG_OUT_U16 = UInt32(0x1BF0)  # Write 16-bit unsigned value
const DEBUG_OUT_I16 = UInt32(0x1BF2)  # Write 16-bit signed value
const DEBUG_OUT_HEX = UInt32(0x1BF4)  # Write 16-bit hex value
const DEBUG_OUT_CHAR = UInt32(0x1BF6) # Write single character
const DEBUG_OUT_U32 = UInt32(0x1BF8)  # Write 32-bit unsigned (write LSW then MSW)

# Global state to track partial 32-bit writes
mutable struct DebugState
    u32_lsw::Union{Nothing,UInt16}
    u32_write_count::Int
end
const DEBUG_STATE = DebugState(nothing, 0)

function handle_debug_memory_write!(addr::UInt32, value::UInt32)::Nothing
    # Check for debug output addresses
    if addr == DEBUG_OUT_U16
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        println(stderr, "u16: $(value & 0xFFFF)")
        return nothing
    elseif addr == DEBUG_OUT_I16
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        # Convert to signed 16-bit (handle two's complement)
        unsigned_val = UInt16(value & 0xFFFF)
        signed_val = reinterpret(Int16, unsigned_val)
        println(stderr, "i16: $signed_val")
        return nothing
    elseif addr == DEBUG_OUT_HEX
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        println(stderr, "hex: 0x$(string(value & 0xFFFF, base=16, pad=4))")
        return nothing
    elseif addr == DEBUG_OUT_CHAR
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        char_val = Char(value & 0xFF)
        if char_val == '\n'
            println(stderr)
        else
            print(stderr, "char: '$char_val'\n")
        end
        return nothing
    elseif addr == DEBUG_OUT_U32
        # 32-bit writes require two 16-bit operations: LSW then MSW
        if DEBUG_STATE.u32_write_count == 0
            # First write: store LSW
            DEBUG_STATE.u32_lsw = UInt16(value & 0xFFFF)
            DEBUG_STATE.u32_write_count = 1
        else
            # Second write: combine MSW with stored LSW
            lsw = DEBUG_STATE.u32_lsw
            msw = UInt16(value & 0xFFFF)
            full_value = UInt32(lsw) | (UInt32(msw) << 16)
            printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
            println(stderr, "u32: $full_value")
            # Reset for next 32-bit write
            DEBUG_STATE.u32_lsw = nothing
            DEBUG_STATE.u32_write_count = 0
        end
        return nothing
    end
    return nothing
end

function set_memory_value!(
    state::MachineState, addr::UInt32, value::UInt32, data_size::Symbol
)::Nothing
    handle_debug_memory_write!(addr, value)

    # Normal memory write
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
        increment = if data_size == :byte
            UInt32(1)
        elseif data_size == :address
            UInt32(4)  # 20-bit values span two words
        else
            UInt32(2)
        end

        # For byte/word operations, MSP430 updates only the lower 16 bits and
        # does not carry into the upper extension bits. Keep full width for
        # PC/SP and address-sized operations.
        mask = if data_size == :address || reg_name in (:PC, :SP)
            get_register_mask(reg_name)
        else
            UInt32(0xFFFF)
        end
        new_val = UInt32((addr + increment) & mask)
        @debug "Autoincrement" reg = reg_name addr = string(addr; base=16, pad=4) increment mask =
            string(mask; base=16, pad=5) data_size = data_size new_val = string(
                new_val; base=16, pad=4
            )
        state.registers[reg_name] = new_val
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
