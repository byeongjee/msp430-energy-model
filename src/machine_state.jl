# Include the instruction handler dispatch system
include("instruction_handlers.jl")

const CACHE_LINE_SIZE_BYTES = UInt32(8)  # 64-bit lines
const CACHE_NUM_LINES = 4
const CACHE_WAYS = 2
const CACHE_SETS = CACHE_NUM_LINES ÷ CACHE_WAYS
const CACHE_SET_STRIDE = CACHE_LINE_SIZE_BYTES * UInt32(CACHE_SETS)

# Hardware multiplier register addresses (MSP430FR5994 datasheet Table 9-65)
const MPY_ADDR = UInt32(0x04C0)       # 16-bit unsigned multiply operand 1
const MPYS_ADDR = UInt32(0x04C2)      # 16-bit signed multiply operand 1
const MAC_ADDR = UInt32(0x04C4)       # 16-bit unsigned MAC operand 1
const MACS_ADDR = UInt32(0x04C6)      # 16-bit signed MAC operand 1
const OP2_ADDR = UInt32(0x04C8)       # 16-bit operand 2 (triggers 16-bit op)
const RESLO_ADDR = UInt32(0x04CA)     # 16-bit result low word
const RESHI_ADDR = UInt32(0x04CC)     # 16-bit result high word
const SUMEXT_ADDR = UInt32(0x04CE)    # Sum extension register
const MPY32L_ADDR = UInt32(0x04D0)    # 32-bit unsigned multiply op1 low
const MPY32H_ADDR = UInt32(0x04D2)    # 32-bit unsigned multiply op1 high
const MPYS32L_ADDR = UInt32(0x04D4)   # 32-bit signed multiply op1 low
const MPYS32H_ADDR = UInt32(0x04D6)   # 32-bit signed multiply op1 high
const MAC32L_ADDR = UInt32(0x04D8)    # 32-bit unsigned MAC op1 low
const MAC32H_ADDR = UInt32(0x04DA)    # 32-bit unsigned MAC op1 high
const MACS32L_ADDR = UInt32(0x04DC)   # 32-bit signed MAC op1 low
const MACS32H_ADDR = UInt32(0x04DE)   # 32-bit signed MAC op1 high
const OP2L_ADDR = UInt32(0x04E0)      # 32-bit operand 2 low
const OP2H_ADDR = UInt32(0x04E2)      # 32-bit operand 2 high (triggers 32-bit op)
const RES0_ADDR = UInt32(0x04E4)      # 32-bit result word 0 (lowest)
const RES1_ADDR = UInt32(0x04E6)      # 32-bit result word 1
const RES2_ADDR = UInt32(0x04E8)      # 32-bit result word 2
const RES3_ADDR = UInt32(0x04EA)      # 32-bit result word 3 (highest)

# Dispatch tables for multiplier write operations
# 16-bit mode: writing sets mode and captures operand 1
const MULTIPLIER_16BIT_MODE = Dict{UInt32,Symbol}(
    MPY_ADDR  => :mpy,
    MPYS_ADDR => :mpys,
    MAC_ADDR  => :mac,
    MACS_ADDR => :macs,
)

# 32-bit mode (low word): writing sets mode and captures low 16 bits of operand 1
const MULTIPLIER_32BIT_LOW_MODE = Dict{UInt32,Symbol}(
    MPY32L_ADDR  => :mpy32,
    MPYS32L_ADDR => :mpys32,
    MAC32L_ADDR  => :mac32,
    MACS32L_ADDR => :macs32,
)

# 32-bit high word addresses: writing only updates high 16 bits (mode already set by low write)
const MULTIPLIER_32BIT_HIGH_ADDRS = Set([MPY32H_ADDR, MPYS32H_ADDR, MAC32H_ADDR, MACS32H_ADDR])

# Dispatch tables for multiplier read operations
# Result registers: map address to bit shift for extracting from 64-bit result
const MULTIPLIER_RESULT_SHIFT = Dict{UInt32,Int}(
    RESLO_ADDR => 0,
    RES0_ADDR  => 0,
    RESHI_ADDR => 16,
    RES1_ADDR  => 16,
    RES2_ADDR  => 32,
    RES3_ADDR  => 48,
)

# All operand 1 low addresses (for reading low 16 bits of op1_value)
const MULTIPLIER_OP1_LOW_ADDRS = Set([
    MPY_ADDR, MPYS_ADDR, MAC_ADDR, MACS_ADDR,
    MPY32L_ADDR, MPYS32L_ADDR, MAC32L_ADDR, MACS32L_ADDR,
])

# All operand 1 high addresses (for reading high 16 bits of op1_value)
const MULTIPLIER_OP1_HIGH_ADDRS = Set([MPY32H_ADDR, MPYS32H_ADDR, MAC32H_ADDR, MACS32H_ADDR])

const DEBUG_MAGIC_U16 = UInt32(0x0010)
const DEBUG_MAGIC_I16 = UInt32(0x0012)
const DEBUG_MAGIC_HEX = UInt32(0x0014)
const DEBUG_MAGIC_CHR = UInt32(0x0016)
const DEBUG_MAGIC_U32_LO = UInt32(0x0018)
const DEBUG_MAGIC_U32_HI = UInt32(0x001A)
const DEBUG_MAGIC_STR = UInt32(0x001C)

_is_debug_magic_addr(addr::UInt32)::Bool = addr >= 0x0010 && addr <= 0x001C

# ============================================================================
# Data Size Constants
# ============================================================================
# Centralized constants for data size properties to avoid duplication and
# ensure consistency across the codebase.

"""
Data size information for MSP430 operations.
- mask: Value mask for the data size
- msb: Most significant bit position
- bytes: Number of bytes for the data size
"""
const DATA_SIZE_INFO = (
    byte    = (mask = UInt32(0xFF),    msb = UInt32(0x80),    bytes = 1),
    word    = (mask = UInt32(0xFFFF),  msb = UInt32(0x8000),  bytes = 2),
    address = (mask = UInt32(0xFFFFF), msb = UInt32(0x80000), bytes = 4),
)

"""
    get_data_size_mask(data_size::Symbol) -> UInt32

Returns the value mask for the given data size.
"""
function get_data_size_mask(data_size::Symbol)::UInt32
    if data_size == :byte
        return DATA_SIZE_INFO.byte.mask
    elseif data_size == :word
        return DATA_SIZE_INFO.word.mask
    elseif data_size == :address
        return DATA_SIZE_INFO.address.mask
    else
        throw(ArgumentError("Unknown data size: $data_size"))
    end
end

"""
    get_data_size_msb(data_size::Symbol) -> UInt32

Returns the MSB bit position for the given data size.
"""
function get_data_size_msb(data_size::Symbol)::UInt32
    if data_size == :byte
        return DATA_SIZE_INFO.byte.msb
    elseif data_size == :word
        return DATA_SIZE_INFO.word.msb
    elseif data_size == :address
        return DATA_SIZE_INFO.address.msb
    else
        throw(ArgumentError("Unknown data size: $data_size"))
    end
end

"""
    get_data_size_bytes(data_size::Symbol) -> Int

Returns the number of bytes for the given data size.
"""
function get_data_size_bytes(data_size::Symbol)::Int
    if data_size == :byte
        return DATA_SIZE_INFO.byte.bytes
    elseif data_size == :word
        return DATA_SIZE_INFO.word.bytes
    elseif data_size == :address
        return DATA_SIZE_INFO.address.bytes
    else
        throw(ArgumentError("Unknown data size: $data_size"))
    end
end

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
        MultiplierState(),  # Hardware multiplier peripheral
        UInt16(0),  # debug_u32_buffer
        IOBuffer(),  # debug_char_buffer
    )
end

"""
Check if address is in the hardware multiplier register range.
"""
_is_multiplier_address(addr::UInt32)::Bool = addr >= 0x04C0 && addr <= 0x04EA

_cache_set_index(addr::UInt32)::Int =
    Int((addr ÷ CACHE_LINE_SIZE_BYTES) % UInt32(CACHE_SETS)) + 1
_cache_tag(addr::UInt32)::UInt32 = UInt32(addr ÷ CACHE_SET_STRIDE)
_cache_offset(addr::UInt32)::Int = Int(addr % CACHE_LINE_SIZE_BYTES)

_is_fram_address(addr::UInt32)::Bool = any(r -> r[1] <= addr <= r[2], FRAM_RANGES)
_is_sram_address(addr::UInt32)::Bool = any(r -> r[1] <= addr <= r[2], SRAM_RANGES)

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

"""
Read an aligned 16-bit word from backing memory without touching the cache.
Assumes addr is aligned (even address).
"""
function _read_word_uncached(state::MachineState, addr::UInt32)::UInt16
    @assert (addr & 0x1) == 0 "Word read must be aligned, got 0x$(string(addr, base=16))"
    return get(state.memory, addr, UInt16(0))
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
function _cache_read_byte(state::MachineState, addr::UInt32)::Tuple{UInt8,Bool}
    if !_is_fram_address(addr)
        return _read_byte_uncached(state, addr), false
    end

    set_idx = _cache_set_index(addr)
    tag = _cache_tag(addr)
    offset = _cache_offset(addr)

    for line in state.cache[set_idx]
        if line.valid && line.tag == tag
            line.last_used = _bump_cache_tick!(state)
            return line.data[offset + 1], true
        end
    end

    filled_line = _cache_fill!(state, addr)
    return filled_line.data[offset + 1], false
end

"""
Read an aligned 16-bit word through the cache (fill on miss).
This represents the MSP430's 16-bit memory bus - a single aligned word access
should result in exactly one cache hit or miss, not two.
Assumes addr is aligned (even address).
"""
function _cache_read_word(state::MachineState, addr::UInt32)::Tuple{UInt16,Bool}
    @assert (addr & 0x1) == 0 "Word read must be aligned, got 0x$(string(addr, base=16))"

    if !_is_fram_address(addr)
        return _read_word_uncached(state, addr), false
    end

    set_idx = _cache_set_index(addr)
    tag = _cache_tag(addr)
    offset = _cache_offset(addr)

    for line in state.cache[set_idx]
        if line.valid && line.tag == tag
            line.last_used = _bump_cache_tick!(state)
            # Read two consecutive bytes from the cache line as a word
            low_byte = line.data[offset + 1]
            high_byte = line.data[offset + 2]
            return UInt16(low_byte) | (UInt16(high_byte) << 8), true
        end
    end

    # Cache miss - fill the line and read the word
    filled_line = _cache_fill!(state, addr)
    low_byte = filled_line.data[offset + 1]
    high_byte = filled_line.data[offset + 2]
    return UInt16(low_byte) | (UInt16(high_byte) << 8), false
end

"""
Check whether the cache currently contains the line for the address without
mutating cache metadata.
"""
function _cache_has_line(state::MachineState, addr::UInt32)::Bool
    set_idx = _cache_set_index(addr)
    tag = _cache_tag(addr)
    for line in state.cache[set_idx]
        if line.valid && line.tag == tag
            return true
        end
    end
    return false
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
Simulate instruction fetches through the cache. Instructions typically reside in FRAM,
so fetches leverage the same cache logic and record FRAM reads.
MSP430 instructions are 16-bit aligned and fetched via the 16-bit bus.

For code executing from SRAM (e.g., .text_sram section), no cache events are
generated since SRAM does not use the FRAM cache. This allows energy benchmarks
to isolate FRAM data access costs from instruction fetch costs.
"""
function fetch_instruction_bytes!(
    state::MachineState,
    addr::UInt32,
    len::UInt32,
    inst::Instruction,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    # Skip cache events for SRAM instruction fetch - SRAM doesn't use FRAM cache
    if _is_sram_address(addr)
        return ExecutionEvent[]
    end

    # Ensure at least one word is fetched even if size is unknown
    len_bytes = max(len, UInt32(2))
    # Round up to word boundary for total fetch size
    num_words = (len_bytes + UInt32(1)) ÷ UInt32(2)

    events = ExecutionEvent[]
    for i in UInt32(0):(num_words - UInt32(1))
        word_addr = addr + (i * UInt32(2))
        # Record memory access for the word (as :word to reflect 16-bit bus access)
        if should_track_memory_access
            append!(events, record_memory_access(state, word_addr, :read, :word, inst))
        end
        _cache_read_word(state, word_addr)
    end
    return events
end

"""
Execute an MSP430 instruction with proper PC management using instruction addresses.

This function uses the instruction handler dispatch system to:
1. Get the appropriate handler for the instruction opcode
2. Execute the instruction using multiple dispatch
3. Centrally manage PC updates based on the handler's should_advance_pc predicate
"""
function execute_instruction!(
    state::MachineState,
    inst::Instruction,
    address_info::Vector{Tuple{UInt32,UInt32}},
    current_idx::Int,
    model_granularity::ModelGranularity,
)::Vector{ExecutionEvent}
    execution_events = ExecutionEvent[]

    # Always include the instruction itself.
    push!(execution_events, ExecutionEvent(Val{Inst}, inst, model_granularity))

    should_track_memory_access = get_should_track_memory_access(model_granularity)

    # Instruction fetch from FRAM goes through cache simulation
    # Use the actual instruction length from the disassembly
    _, instr_len = address_info[current_idx]
    fetch_events = fetch_instruction_bytes!(
        state, state.registers[:PC], instr_len, inst, should_track_memory_access
    )
    append!(execution_events, fetch_events)

    # Get handler for this instruction
    handler = get_handler(inst.opcode)

    # Execute instruction using multiple dispatch (RPT has a custom overload)
    exec_events = execute!(
        state, handler, inst, address_info, current_idx, should_track_memory_access
    )
    append!(execution_events, exec_events)

    # Handle RPT instruction: if repeat_counter > 0, decrement and don't advance PC
    # unless it's the RPT instruction itself (which sets the counter)
    if state.repeat_counter > 0 && inst.opcode != :rpt
        state.repeat_counter -= 1
    elseif should_advance_pc(handler, state, inst.operands) &&
        current_idx < length(address_info)
        state.registers[:PC] = address_info[current_idx + 1][1]
    end

    return execution_events
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
    return value & get_data_size_mask(data_size)
end

function read_memory(
    state::MachineState,
    addr::UInt32,
    data_size::Symbol,
    inst::Union{Nothing,Instruction},
    should_track_memory_access::Bool,
)::WithEvent{UInt32}
    # MSP430 automatically aligns word accesses to even addresses
    aligned_addr = addr & ~UInt32(1)

    # Handle hardware multiplier reads (no cache events for peripheral registers)
    if _is_multiplier_address(aligned_addr)
        result_val = _handle_multiplier_read(state, aligned_addr)
        return (UInt32(result_val), ExecutionEvent[])
    end

    # Record the memory access as an event (only if inst is provided)
    if should_track_memory_access
        events = record_memory_access(state, addr, :read, data_size, inst)
    else
        events = ExecutionEvent[]
    end

    use_cache = _is_fram_address(aligned_addr)

    # Helper to read a word from aligned address
    read_word = (a) -> use_cache ? _cache_read_word(state, a) : (_read_word_uncached(state, a), false)

    if data_size == :byte
        word, _ = read_word(aligned_addr)
        # Extract the correct byte based on original address alignment
        byte = (addr & 1) == 0 ? UInt8(word & 0xFF) : UInt8((word >> 8) & 0xFF)
        return (UInt32(byte), events)
    elseif data_size == :word
        word, _ = read_word(aligned_addr)
        return (UInt32(word), events)
    elseif data_size == :address
        # 20-bit address = two 16-bit words
        lsw, _ = read_word(aligned_addr)
        msw, _ = read_word(aligned_addr + UInt32(2))
        return (UInt32(lsw) | (UInt32(msw & 0xF) << 16), events)
    else
        error("Unknown data size: $data_size")
    end
end

"""
Read a null-terminated C string from memory starting at `addr`.
"""
function read_c_string(state::MachineState, addr::UInt32)::WithEvent{String}
    io = IOBuffer()
    current = addr
    events = ExecutionEvent[]
    while true
        # do not track memory access for c string reads
        byte_val, byte_events = read_memory(state, current, :byte, nothing, false)
        append!(events, byte_events)
        if UInt8(byte_val & 0xFF) == 0x00
            break
        end
        write(io, Char(UInt8(byte_val & 0xFF)))
        current += UInt32(1)
    end
    return (String(take!(io)), events)
end

function _handle_debug_magic_write!(state::MachineState, addr::UInt32, value::UInt16)::Nothing
    pc = state.registers[:PC]
    sp = state.registers[:SP]

    if addr == DEBUG_MAGIC_U16
        printstyled(stderr, "[DEBUG] "; color=:cyan, bold=true)
        println(stderr, "u16 pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $value")
    elseif addr == DEBUG_MAGIC_I16
        signed_val = reinterpret(Int16, value)
        printstyled(stderr, "[DEBUG] "; color=:cyan, bold=true)
        println(stderr, "i16 pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $signed_val")
    elseif addr == DEBUG_MAGIC_HEX
        printstyled(stderr, "[DEBUG] "; color=:cyan, bold=true)
        println(stderr, "hex pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): 0x$(string(value, base=16, pad=4))")
    elseif addr == DEBUG_MAGIC_CHR
        char_val = Char(value & 0xFF)
        if char_val == '\n'
            buffered = String(take!(state.debug_char_buffer))
            printstyled(stderr, "[DEBUG] "; color=:cyan, bold=true)
            println(stderr, "char pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $buffered")
        else
            print(state.debug_char_buffer, char_val)
        end
    elseif addr == DEBUG_MAGIC_U32_LO
        state.debug_u32_buffer = value
    elseif addr == DEBUG_MAGIC_U32_HI
        full_value = UInt32(state.debug_u32_buffer) | (UInt32(value) << 16)
        printstyled(stderr, "[DEBUG] "; color=:cyan, bold=true)
        println(stderr, "u32 pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $full_value")
    elseif addr == DEBUG_MAGIC_STR
        ptr = UInt32(value)
        text, _ = read_c_string(state, ptr)
        printstyled(stderr, "[DEBUG] "; color=:cyan, bold=true)
        println(stderr, "str pc=0x$(string(pc; base=16, pad=4)) sp=0x$(string(sp; base=16, pad=5)): $text")
    end

    return nothing
end

# ============================================================================
# Hardware Multiplier Emulation
# ============================================================================

"""
Execute 16-bit multiply operation based on op1_mode.
Called when OP2 register is written.
"""
function _execute_multiply_16!(m::MultiplierState)
    op1 = m.op1_value & 0xFFFF
    op2 = m.op2_value & 0xFFFF

    if m.op1_mode == :mpy
        # Unsigned multiply: 16x16 -> 32
        m.result = UInt64(op1) * UInt64(op2)
        m.sumext = UInt16(0)
    elseif m.op1_mode == :mpys
        # Signed multiply: 16x16 -> 32 (signed)
        # Sign-extend 16-bit to Int32 using reinterpret for correctness
        s1 = Int32(reinterpret(Int16, UInt16(op1)))
        s2 = Int32(reinterpret(Int16, UInt16(op2)))
        result32 = s1 * s2  # Result fits in Int32 (max: 32768^2 < 2^31)
        m.result = UInt64(reinterpret(UInt32, result32))
        # SUMEXT: 0x0000 if result >= 0, 0xFFFF if result < 0
        m.sumext = result32 < 0 ? UInt16(0xFFFF) : UInt16(0)
    elseif m.op1_mode == :mac
        # Unsigned multiply-accumulate: result += op1 * op2
        m.result += UInt64(op1) * UInt64(op2)
        m.sumext = UInt16(0)
    elseif m.op1_mode == :macs
        # Signed multiply-accumulate
        # Sign-extend 16-bit to Int32 using reinterpret for correctness
        s1 = Int32(reinterpret(Int16, UInt16(op1)))
        s2 = Int32(reinterpret(Int16, UInt16(op2)))
        # Add to current result (interpret as signed)
        current = reinterpret(Int64, m.result)
        new_result = current + Int64(s1 * s2)
        m.result = reinterpret(UInt64, new_result)
        m.sumext = new_result < 0 ? UInt16(0xFFFF) : UInt16(0)
    end
end

"""
Execute 32-bit multiply operation based on op1_mode.
Called when OP2H register is written.
"""
function _execute_multiply_32!(m::MultiplierState)
    op1 = m.op1_value
    op2 = m.op2_value

    if m.op1_mode in (:mpy32, :mpy)
        # Unsigned 32x32 -> 64
        m.result = UInt64(op1) * UInt64(op2)
        m.sumext = UInt16(0)
    elseif m.op1_mode in (:mpys32, :mpys)
        # Signed 32x32 -> 64
        s1 = reinterpret(Int32, op1)
        s2 = reinterpret(Int32, op2)
        result64 = Int64(s1) * Int64(s2)
        m.result = reinterpret(UInt64, result64)
        m.sumext = result64 < 0 ? UInt16(0xFFFF) : UInt16(0)
    elseif m.op1_mode in (:mac32, :mac)
        # Unsigned 32x32 multiply-accumulate
        m.result += UInt64(op1) * UInt64(op2)
        m.sumext = UInt16(0)
    elseif m.op1_mode in (:macs32, :macs)
        # Signed 32x32 multiply-accumulate
        s1 = reinterpret(Int32, op1)
        s2 = reinterpret(Int32, op2)
        current = reinterpret(Int64, m.result)
        new_result = current + Int64(s1) * Int64(s2)
        m.result = reinterpret(UInt64, new_result)
        m.sumext = new_result < 0 ? UInt16(0xFFFF) : UInt16(0)
    end
end

"""
Handle writes to hardware multiplier registers.
Uses dispatch tables to reduce repetition and make patterns explicit.
"""
function _handle_multiplier_write!(state::MachineState, addr::UInt32, value::UInt16)
    m = state.multiplier

    # 16-bit mode registers: set mode and store full operand 1
    mode_16 = get(MULTIPLIER_16BIT_MODE, addr, nothing)
    if mode_16 !== nothing
        m.op1_mode = mode_16
        m.op1_value = UInt32(value)
        return
    end

    # 32-bit mode low registers: set mode and store low 16 bits of operand 1
    mode_32 = get(MULTIPLIER_32BIT_LOW_MODE, addr, nothing)
    if mode_32 !== nothing
        m.op1_mode = mode_32
        m.op1_value = (m.op1_value & 0xFFFF0000) | UInt32(value)
        return
    end

    # 32-bit mode high registers: store high 16 bits of operand 1 (mode already set)
    if addr in MULTIPLIER_32BIT_HIGH_ADDRS
        m.op1_value = (m.op1_value & 0x0000FFFF) | (UInt32(value) << 16)
        return
    end

    # Operand 2 registers
    if addr == OP2_ADDR
        m.op2_value = UInt32(value)
        _execute_multiply_16!(m)
    elseif addr == OP2L_ADDR
        m.op2_value = (m.op2_value & 0xFFFF0000) | UInt32(value)
    elseif addr == OP2H_ADDR
        m.op2_value = (m.op2_value & 0x0000FFFF) | (UInt32(value) << 16)
        _execute_multiply_32!(m)
    end
    # Result registers (RES0-RES3, RESLO, RESHI) are read-only in hardware
    # but we don't error on write attempts - they're just ignored
end

"""
Handle reads from hardware multiplier registers.
Returns the value that should be read.
Uses dispatch tables to reduce repetition and make patterns explicit.
"""
function _handle_multiplier_read(state::MachineState, addr::UInt32)::UInt16
    m = state.multiplier

    # Result registers: return the appropriate 16-bit word from 64-bit result
    shift = get(MULTIPLIER_RESULT_SHIFT, addr, nothing)
    if shift !== nothing
        return UInt16((m.result >> shift) & 0xFFFF)
    end

    # Sum extension register
    if addr == SUMEXT_ADDR
        return m.sumext
    end

    # Operand 1 registers
    if addr in MULTIPLIER_OP1_LOW_ADDRS
        return UInt16(m.op1_value & 0xFFFF)
    elseif addr in MULTIPLIER_OP1_HIGH_ADDRS
        return UInt16((m.op1_value >> 16) & 0xFFFF)
    end

    # Operand 2 registers
    if addr == OP2_ADDR || addr == OP2L_ADDR
        return UInt16(m.op2_value & 0xFFFF)
    elseif addr == OP2H_ADDR
        return UInt16((m.op2_value >> 16) & 0xFFFF)
    end

    return UInt16(0)
end

function write_memory!(
    state::MachineState,
    addr::UInt32,
    value::UInt32,
    data_size::Symbol,
    inst::Instruction,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    # MSP430 automatically aligns word accesses to even addresses
    aligned_addr = addr & ~UInt32(1)

    # Handle hardware multiplier writes (no cache events for peripheral registers)
    if _is_multiplier_address(aligned_addr)
        _handle_multiplier_write!(state, aligned_addr, UInt16(value & 0xFFFF))
        return ExecutionEvent[]
    end

    if _is_debug_magic_addr(aligned_addr)
        _handle_debug_magic_write!(state, aligned_addr, UInt16(value & 0xFFFF))
        return ExecutionEvent[]
    end

    # Record memory access event for non-peripheral memory
    if should_track_memory_access
        events = record_memory_access(state, addr, :write, data_size, inst)
    else
        events = ExecutionEvent[]
    end

    # Determine byte length for cache invalidation
    byte_len = data_size == :byte ? 1 : data_size == :word ? 2 : data_size == :address ? 4 : 0
    byte_len == 0 && error("Unknown data size: $data_size")

    # Invalidate cache for FRAM writes
    _is_fram_address(aligned_addr) && _invalidate_cache_range!(state, aligned_addr, byte_len)

    # Write to memory
    if data_size == :byte
        old_word = get(state.memory, aligned_addr, UInt16(0))
        new_word = (addr & 1) == 0 ?
            UInt16((old_word & 0xFF00) | (value & 0xFF)) :  # Even: lower byte
            UInt16((old_word & 0x00FF) | ((value & 0xFF) << 8))  # Odd: upper byte
        state.memory[aligned_addr] = new_word
    elseif data_size == :word
        state.memory[aligned_addr] = UInt16(value & 0xFFFF)
    elseif data_size == :address
        # 20-bit address = two 16-bit words
        state.memory[aligned_addr] = UInt16(value & 0xFFFF)
        state.memory[aligned_addr + UInt32(2)] = UInt16((value >> 16) & 0xF)
    end

    return events
end

"""
Record a memory access as an ExecutionEvent.
Pure function that returns the event without mutating state.

Generates events for both FRAM and SRAM accesses:
- FRAM: FRAMReadHit, FRAMReadMiss, FRAMWrite (with cache simulation)
- SRAM: SRAMRead, SRAMWrite (direct access, no cache)
- Unknown regions: no event
"""
function record_memory_access(
    state::MachineState,
    addr::UInt32,
    access_type::Symbol,
    data_size::Symbol,
    inst::Union{Nothing,Instruction},
)::Vector{ExecutionEvent}
    # FRAM accesses: generate event with cache hit/miss tracking
    if _is_fram_address(addr)
        event_type = if access_type == :read
            _cache_has_line(state, addr) ? FRAMReadHit : FRAMReadMiss
        else
            FRAMWrite
        end
        return [ExecutionEvent(event_type, inst, Any[addr, data_size])]
    end

    # SRAM accesses: generate SRAMRead/SRAMWrite event (no cache)
    if _is_sram_address(addr)
        event_type = access_type == :read ? SRAMRead : SRAMWrite
        return [ExecutionEvent(event_type, inst, Any[addr, data_size])]
    end

    # Unknown regions: no event
    return ExecutionEvent[]
end

"""
Get value from operand (register, immediate, or memory)
"""
function get_operand_value(
    state::MachineState,
    operand::Operand,
    data_size::Symbol,
    inst::Instruction,
    should_track_memory_access::Bool,
)::WithEvent{UInt32}
    value, events = if operand.mode == :immediate
        # Immediate value
        @assert isa(operand.value, Integer) "Immediate mode: operand.value must be Integer, got $(typeof(operand.value))"
        (UInt32(operand.value), ExecutionEvent[])
    elseif operand.mode == :register
        # Register
        @assert isa(operand.value, Symbol) "Register mode: operand.value must be Symbol, got $(typeof(operand.value))"
        (get_register_value(state, operand.value), ExecutionEvent[])
    elseif operand.mode == :indirect
        # Indirect addressing: @R1 means "value at address contained in R1"
        @assert isa(operand.value, Symbol) "Indirect mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Remove @ prefix
        addr = get_register_value(state, reg_name)
        read_memory(state, addr, data_size, inst, should_track_memory_access)
    elseif operand.mode == :autoincrement
        # Autoincrement addressing: @R1+ means "value at address in R1, then increment R1"
        @assert isa(operand.value, Symbol) "Autoincrement mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Remove @ prefix
        addr = get_register_value(state, reg_name)
        val, mem_events = read_memory(
            state, addr, data_size, inst, should_track_memory_access
        )
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
        (val, mem_events)
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
        read_memory(state, addr, data_size, inst, should_track_memory_access)
    elseif operand.mode == :absolute
        # Absolute addressing: &address
        @assert isa(operand.value, Integer) "Absolute mode: operand.value must be Integer, got $(typeof(operand.value))"
        read_memory(state, UInt32(operand.value), data_size, inst, should_track_memory_access)
    else
        error("Unknown addressing mode: $(operand.mode)")
    end

    # Apply data size mask
    return (apply_data_size_mask(value, data_size), events)
end

"""
Set value to operand (register or memory)
"""
function set_operand_value!(
    state::MachineState,
    operand::Operand,
    value::UInt32,
    data_size::Symbol,
    inst::Instruction,
    should_track_memory_access::Bool,
)::Vector{ExecutionEvent}
    # Apply data size mask to value
    masked_value = apply_data_size_mask(value, data_size)

    if operand.mode == :register
        # Register
        @assert isa(operand.value, Symbol) "Register mode: operand.value must be Symbol, got $(typeof(operand.value))"
        set_register_value!(state, operand.value, masked_value)
        return ExecutionEvent[]
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

        return write_memory!(
            state, addr, masked_value, data_size, inst, should_track_memory_access
        )
    elseif operand.mode == :absolute
        # Absolute addressing: &address
        @assert isa(operand.value, Integer) "Absolute mode: operand.value must be Integer, got $(typeof(operand.value))"
        return write_memory!(
            state, operand.value, masked_value, data_size, inst, should_track_memory_access
        )
    elseif operand.mode == :indirect
        # Indirect register mode: @Rn -> store to address in Rn
        @assert isa(operand.value, Symbol) "Indirect mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Strip leading @
        addr = get_register_value(state, reg_name)
        return write_memory!(
            state, addr, masked_value, data_size, inst, should_track_memory_access
        )
    elseif operand.mode == :autoincrement
        # Autoincrement store: write then increment pointer register
        @assert isa(operand.value, Symbol) "Autoincrement mode: operand.value must be Symbol, got $(typeof(operand.value))"
        operand_str = string(operand.value)
        reg_name = Symbol(operand_str[2:end])  # Strip leading @
        addr = get_register_value(state, reg_name)
        events = write_memory!(
            state, addr, masked_value, data_size, inst, should_track_memory_access
        )

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
        return events
    else
        error("Cannot set value for addressing mode: $(operand.mode)")
    end
end

"""
Helper to synchronize SR register with flag dictionary.
Call after modifying flags to keep SR in sync.
"""
function _sync_sr_with_flags!(state::MachineState)::Nothing
    state.registers[:SR] =
        (state.registers[:SR] & ~UInt32(0x0107)) |  # Preserve GIE/CPU mode bits
        (state.flags[:V] ? 0x0100 : 0x0000) |
        (state.flags[:N] ? 0x0004 : 0x0000) |
        (state.flags[:Z] ? 0x0002 : 0x0000) |
        (state.flags[:C] ? 0x0001 : 0x0000)
    return nothing
end

"""
Update status flags after addition operations (ADD, ADDC, INC, INCD, ADC).

Carry: Set if result exceeds data size max value.
Overflow: Set if both operands have same sign but result has different sign.

Note: DADD has custom BCD flag handling and does not use this function.
"""
function update_flags_add!(
    state::MachineState,
    result::UInt32,
    dst::UInt32,
    src::UInt32,
    data_size::Symbol=:word,
)::Nothing
    masked_result = apply_data_size_mask(result, data_size)
    masked_dst = apply_data_size_mask(dst, data_size)
    masked_src = apply_data_size_mask(src, data_size)

    max_val = get_data_size_mask(data_size)
    msb_bit = get_data_size_msb(data_size)

    # Zero flag
    state.flags[:Z] = (masked_result == 0)

    # Negative flag (MSB set)
    state.flags[:N] = (masked_result & msb_bit) != 0

    # Carry flag for addition: set if result exceeds max value
    state.flags[:C] = (masked_dst + masked_src) > max_val

    # Overflow flag for addition: both operands same sign, result different sign
    dst_sign = (masked_dst & msb_bit) != 0
    src_sign = (masked_src & msb_bit) != 0
    result_sign = (masked_result & msb_bit) != 0
    state.flags[:V] = (dst_sign == src_sign) && (dst_sign != result_sign)

    _sync_sr_with_flags!(state)
    return nothing
end

"""
Update status flags after subtraction operations (SUB, SUBC, CMP, DEC, DECD, SBC).

Carry: Set if dst >= src (no borrow needed).
Overflow: Set if operands have different signs and result sign differs from dst.

Note: XOR and AND have custom flag handling (V, C differ from SUB) and do not use this function.
"""
function update_flags_sub!(
    state::MachineState,
    result::UInt32,
    dst::UInt32,
    src::UInt32,
    data_size::Symbol=:word,
)::Nothing
    masked_result = apply_data_size_mask(result, data_size)
    masked_dst = apply_data_size_mask(dst, data_size)
    masked_src = apply_data_size_mask(src, data_size)

    msb_bit = get_data_size_msb(data_size)

    # Zero flag
    state.flags[:Z] = (masked_result == 0)

    # Negative flag (MSB set)
    state.flags[:N] = (masked_result & msb_bit) != 0

    # Carry flag for subtraction: set if no borrow needed
    state.flags[:C] = masked_dst >= masked_src

    # Overflow flag for subtraction: operands different signs, result sign differs from dst
    dst_sign = (masked_dst & msb_bit) != 0
    src_sign = (masked_src & msb_bit) != 0
    result_sign = (masked_result & msb_bit) != 0
    state.flags[:V] = (dst_sign != src_sign) && (dst_sign != result_sign)

    _sync_sr_with_flags!(state)
    return nothing
end

"""
Update status flags for simple operations (no carry/overflow calculation)
"""
function update_flags_simple!(
    state::MachineState, result::UInt32, data_size::Symbol=:word
)::Nothing
    # Get the appropriate MSB bit for the data size
    msb_bit = get_data_size_msb(data_size)

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
