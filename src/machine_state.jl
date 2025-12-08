# Include the instruction handler dispatch system
include("instruction_handlers.jl")

const FRAM_RANGES = [(0x4400, 0xFFFFF)]
const SRAM_RANGES = [(0x1C00, 0x3BFF)]

const CACHE_LINE_SIZE_BYTES = UInt32(8)  # 64-bit lines
const CACHE_NUM_LINES = 4
const CACHE_WAYS = 2
const CACHE_SETS = CACHE_NUM_LINES ÷ CACHE_WAYS
const CACHE_SET_STRIDE = CACHE_LINE_SIZE_BYTES * UInt32(CACHE_SETS)

"""
Create an empty cache with all lines invalidated.
"""
function _init_cache()::Vector{Vector{CacheLine}}
    invalid_line = CacheLine(
        false, UInt32(0), fill(UInt8(0), Int(CACHE_LINE_SIZE_BYTES)), 0
    )
    return [[deepcopy(invalid_line) for _ in 1:CACHE_WAYS] for _ in 1:CACHE_SETS]
end

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
        _init_cache(),          # Two-way set associative cache
        0,                      # cache_tick for LRU
        Dict(:V => false, :N => false, :Z => false, :C => false),  # Status flags
        0,  # repeat_counter initialized to 0
        nothing,  # memory_observer (set by interpreter when needed)
    )
end

_cache_set_index(addr::UInt32)::Int =
    Int((addr ÷ CACHE_LINE_SIZE_BYTES) % UInt32(CACHE_SETS)) + 1
_cache_tag(addr::UInt32)::UInt32 = UInt32(addr ÷ CACHE_SET_STRIDE)
_cache_offset(addr::UInt32)::Int = Int(addr % CACHE_LINE_SIZE_BYTES)

_is_fram_address(addr::UInt32)::Bool = any(r -> r[1] <= addr <= r[2], FRAM_RANGES)

"""
Increment the cache tick used for LRU ordering.
"""
function _bump_cache_tick!(state::MachineState)::UInt64
    state.cache_tick += 1
    return state.cache_tick
end

"""
Read a single byte from backing memory without touching the cache.
"""
function _read_byte_uncached(state::MachineState, addr::UInt32)::UInt8
    word = get(state.memory, addr & ~UInt32(1), UInt16(0))
    if (addr & 0x1) == 0
        return UInt8(word & 0xFF)
    else
        return UInt8((word >> 8) & 0xFF)
    end
end

function _read_bytes_uncached(state::MachineState, addr::UInt32, len::Int)::Vector{UInt8}
    bytes = Vector{UInt8}(undef, len)
    for i in 0:(len - 1)
        bytes[i + 1] = _read_byte_uncached(state, addr + UInt32(i))
    end
    return bytes
end

function _select_victim_line(lines::Vector{CacheLine})::CacheLine
    for line in lines
        if !line.valid
            return line
        end
    end
    # LRU: smallest last_used
    lru = lines[1]
    for line in lines
        if line.last_used < lru.last_used
            lru = line
        end
    end
    return lru
end

"""
Fill a cache line containing the given address and return the populated line.
"""
function _cache_fill!(state::MachineState, addr::UInt32)::CacheLine
    base_addr = addr - (addr % CACHE_LINE_SIZE_BYTES)
    line_data = Vector{UInt8}(undef, Int(CACHE_LINE_SIZE_BYTES))
    for i in 0:(Int(CACHE_LINE_SIZE_BYTES) - 1)
        line_data[i + 1] = _read_byte_uncached(state, base_addr + UInt32(i))
    end

    set_idx = _cache_set_index(addr)
    tag = _cache_tag(addr)
    victim = _select_victim_line(state.cache[set_idx])

    victim.valid = true
    victim.tag = tag
    victim.data .= line_data
    victim.last_used = _bump_cache_tick!(state)

    return victim
end

"""
Read a byte through the cache (fill on miss).
"""
function _cache_read_byte(state::MachineState, addr::UInt32)::UInt8
    if !_is_fram_address(addr)
        return _read_byte_uncached(state, addr)
    end

    set_idx = _cache_set_index(addr)
    tag = _cache_tag(addr)
    offset = _cache_offset(addr)

    for line in state.cache[set_idx]
        if line.valid && line.tag == tag
            line.last_used = _bump_cache_tick!(state)
            return line.data[offset + 1]
        end
    end

    filled_line = _cache_fill!(state, addr)
    return filled_line.data[offset + 1]
end

"""
Invalidate a cache line containing the address, if present.
"""
function _invalidate_cache_line!(state::MachineState, addr::UInt32)::Nothing
    if !_is_fram_address(addr)
        return nothing
    end
    set_idx = _cache_set_index(addr)
    tag = _cache_tag(addr)
    for line in state.cache[set_idx]
        if line.valid && line.tag == tag
            line.valid = false
        end
    end
    return nothing
end

"""
Invalidate all cache lines touched by the byte range [addr, addr+len).
"""
function _invalidate_cache_range!(state::MachineState, addr::UInt32, len::Int)::Nothing
    end_addr = addr + UInt32(len - 1)
    current = addr - (addr % CACHE_LINE_SIZE_BYTES)
    while current <= end_addr
        _invalidate_cache_line!(state, current)
        current += CACHE_LINE_SIZE_BYTES
    end
    return nothing
end

"""
Read N bytes via the cache.
"""
function _read_bytes_cached(state::MachineState, addr::UInt32, len::Int)::Vector{UInt8}
    bytes = Vector{UInt8}(undef, len)
    for i in 0:(len - 1)
        bytes[i + 1] = _cache_read_byte(state, addr + UInt32(i))
    end
    return bytes
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

    # Execute instruction using multiple dispatch (RPT has a custom overload)
    execute!(state, handler, inst, addresses, current_idx)

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

function read_memory(state::MachineState, addr::UInt32, data_size::Symbol)::UInt32
    # Notify observers of the memory access
    record_memory_access!(state, addr, :read, data_size)

    use_cache = _is_fram_address(addr)

    if data_size == :byte
        return UInt32(
            use_cache ? _cache_read_byte(state, addr) : _read_byte_uncached(state, addr)
        )
    elseif data_size == :word
        bytes =
            use_cache ? _read_bytes_cached(state, addr, 2) :
            _read_bytes_uncached(state, addr, 2)
        return UInt32(bytes[1]) | (UInt32(bytes[2]) << 8)
    elseif data_size == :address
        bytes =
            use_cache ? _read_bytes_cached(state, addr, 4) :
            _read_bytes_uncached(state, addr, 4)
        lsw = UInt16(bytes[1]) | (UInt16(bytes[2]) << 8)
        msw = UInt16(bytes[3]) | (UInt16(bytes[4]) << 8)
        return UInt32(lsw) | (UInt32(msw & 0xF) << 16)
    else
        error("Unknown data size: $data_size")
    end
end

const DEBUG_CHAR_BUFFER = IOBuffer()

"""
Read a null-terminated C string from memory starting at `addr`.
"""
function read_c_string(state::MachineState, addr::UInt32)::String
    io = IOBuffer()
    current = addr
    while true
        byte_val = UInt8(read_memory(state, current, :byte) & 0xFF)
        if byte_val == 0x00
            break
        end
        write(io, Char(byte_val))
        current += UInt32(1)
    end
    return String(take!(io))
end

"""
Handle interpreter-visible debug function calls (DEBUG=2).
These functions are no-ops on-device; the interpreter reads arguments from
calling-convention registers and emits debug output when enabled.
"""
function handle_debug_function_call!(
    state::MachineState, func_name::Symbol, pc::UInt32
)::Nothing
    sp = state.registers[:SP]
    if func_name == :debug_out_u16
        val = get_register_value(state, :R12) & 0xFFFF
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        println(
            stderr,
            "u16 call pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $val",
        )
    elseif func_name == :debug_out_i16
        unsigned_val = UInt16(get_register_value(state, :R12) & 0xFFFF)
        signed_val = reinterpret(Int16, unsigned_val)
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        println(
            stderr,
            "i16 call pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $signed_val",
        )
    elseif func_name == :debug_out_hex
        val = get_register_value(state, :R12) & 0xFFFF
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        println(
            stderr,
            "hex call pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): 0x$(string(val, base=16, pad=4))",
        )
    elseif func_name == :debug_out_char
        char_val = Char(get_register_value(state, :R12) & 0xFF)
        if char_val == '\n'
            buffered = String(take!(DEBUG_CHAR_BUFFER))
            printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
            println(
                stderr,
                "char call pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $buffered",
            )
        else
            print(DEBUG_CHAR_BUFFER, char_val)
        end
    elseif func_name == :debug_out_u32
        lsw = get_register_value(state, :R12) & 0xFFFF
        msw = get_register_value(state, :R13) & 0xFFFF
        full_value = UInt32(lsw) | (UInt32(msw) << 16)
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        println(
            stderr,
            "u32 call pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $full_value",
        )
    elseif func_name == :debug_out_str
        ptr = get_register_value(state, :R12) & 0xFFFFF
        text = read_c_string(state, ptr)
        printstyled(stderr, "[DEBUG] "; color=:green, bold=true)
        println(
            stderr,
            "str call pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $text",
        )
    end

    return nothing
end

function write_memory!(
    state::MachineState, addr::UInt32, value::UInt32, data_size::Symbol
)::Nothing
    record_memory_access!(state, addr, :write, data_size)
    byte_len = if data_size == :byte
        1
    elseif data_size == :word
        2
    elseif data_size == :address
        4
    else
        0
    end
    if byte_len == 0
        error("Unknown data size: $data_size")
    end
    if _is_fram_address(addr)
        _invalidate_cache_range!(state, addr, byte_len)
    end
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
Invoke the optional memory observer to record a memory access.
"""
function record_memory_access!(
    state::MachineState, addr::UInt32, access_type::Symbol, data_size::Symbol
)::Nothing
    if state.memory_observer !== nothing
        state.memory_observer(addr, access_type, data_size)
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
        read_memory(state, addr, data_size)
    elseif operand.mode == :autoincrement
        # Autoincrement addressing: @R1+ means "value at address in R1, then increment R1"
        @assert isa(operand.value, Symbol) "Autoincrement mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Remove @ prefix
        addr = get_register_value(state, reg_name)
        val = read_memory(state, addr, data_size)
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
        @debug "Autoincrement" reg = reg_name addr = string(addr; base=16, pad=4) increment mask = string(
            mask; base=16, pad=5
        ) data_size = data_size new_val = string(new_val; base=16, pad=4)
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
        read_memory(state, addr, data_size)
    elseif operand.mode == :absolute
        # Absolute addressing: &address
        @assert isa(operand.value, Integer) "Absolute mode: operand.value must be Integer, got $(typeof(operand.value))"
        read_memory(state, operand.value, data_size)
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

        write_memory!(state, addr, masked_value, data_size)
    elseif operand.mode == :absolute
        # Absolute addressing: &address
        @assert isa(operand.value, Integer) "Absolute mode: operand.value must be Integer, got $(typeof(operand.value))"
        write_memory!(state, operand.value, masked_value, data_size)
    elseif operand.mode == :indirect
        # Indirect register mode: @Rn -> store to address in Rn
        @assert isa(operand.value, Symbol) "Indirect mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Strip leading @
        addr = get_register_value(state, reg_name)
        write_memory!(state, addr, masked_value, data_size)
    elseif operand.mode == :autoincrement
        # Autoincrement store: write then increment pointer register
        @assert isa(operand.value, Symbol) "Autoincrement mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Strip leading @
        addr = get_register_value(state, reg_name)
        write_memory!(state, addr, masked_value, data_size)

        increment = if data_size == :byte
            UInt32(1)
        elseif data_size == :address
            UInt32(4)  # 20-bit spans two words
        else
            UInt32(2)
        end

        mask = reg_name in (:PC, :SP) ? get_register_mask(reg_name) : UInt32(0xFFFF)
        new_val = UInt32((addr + increment) & mask)
        state.registers[reg_name] = new_val
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
    # Mask operands/results to the active data size so flag math matches
    # architectural overflow/underflow (e.g., 16-bit and 20-bit wraparound).
    masked_result = apply_data_size_mask(result, data_size)
    masked_dst = apply_data_size_mask(dst, data_size)
    masked_src = apply_data_size_mask(src, data_size)

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
    state.flags[:Z] = (masked_result == 0)

    # Negative flag (MSB set)
    state.flags[:N] = (masked_result & msb_bit) != 0

    if is_add
        # Carry flag for addition
        state.flags[:C] = (masked_dst + masked_src) > max_val

        # Overflow flag for addition (both operands same sign, result different sign)
        dst_sign = (masked_dst & msb_bit) != 0
        src_sign = (masked_src & msb_bit) != 0
        result_sign = (masked_result & msb_bit) != 0
        state.flags[:V] = (dst_sign == src_sign) && (dst_sign != result_sign)
    else
        # Carry flag for subtraction (borrow)
        state.flags[:C] = masked_dst >= masked_src

        # Overflow flag for subtraction
        dst_sign = (masked_dst & msb_bit) != 0
        src_sign = (masked_src & msb_bit) != 0
        result_sign = (masked_result & msb_bit) != 0
        state.flags[:V] = (dst_sign != src_sign) && (dst_sign != result_sign)
    end

    # Update status register
    state.registers[:SR] =
        (state.registers[:SR] & ~UInt32(0x0107)) |  # Preserve GIE/CPU mode bits
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
        (state.registers[:SR] & ~UInt32(0x0007)) |  # Preserve V/GIE/CPU mode bits, clear C/N/Z
        (state.flags[:N] ? 0x0004 : 0x0000) |
        (state.flags[:Z] ? 0x0002 : 0x0000) |
        (state.flags[:C] ? 0x0001 : 0x0000)

    return nothing
end
