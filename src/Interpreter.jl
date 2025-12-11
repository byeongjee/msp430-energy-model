module Interpreter

using Statistics
using Gen
using Printf
using Logging
using ..Types:
    Instruction,
    Operand,
    MachineState,
    ExecutionEvent,
    ExecutionTrace,
    CacheLine,
    Inst,
    FRAMReadHit,
    FRAMReadMiss,
    FRAMWrite,
    SRAMRead,
    SRAMWrite
using ..Parser

include("machine_state.jl")

const _HEX_CHARS = Set("0123456789abcdefABCDEF")

"""
Parse an address range specification of the form "start:end" (hex or decimal).
"""
function _parse_range(range_str::String)::Tuple{UInt32,UInt32}
    parts = split(range_str, ":")
    length(parts) == 2 || error("Invalid range '$range_str'. Expected start:end.")
    parse_addr =
        s -> UInt32(parse(Int, startswith(lowercase(s), "0x") ? s : "0x$s"; base=16))
    start_addr = parse_addr(strip(parts[1]))
    end_addr = parse_addr(strip(parts[2]))
    start_addr <= end_addr || error("Range start must be <= end in '$range_str'")
    return (start_addr, end_addr)
end

"""
Create memory region configuration for FRAM/SRAM classification.
"""
function build_memory_regions(
    fram_specs::Union{Nothing,Vector{String}}=nothing,
    sram_specs::Union{Nothing,Vector{String}}=nothing,
)
    fram_ranges =
        isnothing(fram_specs) || isempty(fram_specs) ? FRAM_RANGES :
        [_parse_range(r) for r in fram_specs]
    sram_ranges =
        isnothing(sram_specs) || isempty(sram_specs) ? SRAM_RANGES :
        [_parse_range(r) for r in sram_specs]
    return Dict(:fram => fram_ranges, :sram => sram_ranges)
end

"""
Classify an address into :fram, :sram, or :other based on configured ranges.
"""
function classify_region(addr::UInt32, memory_regions)::Symbol
    for (lo, hi) in get(memory_regions, :sram, SRAM_RANGES)
        if lo <= addr <= hi
            return :sram
        end
    end
    for (lo, hi) in get(memory_regions, :fram, FRAM_RANGES)
        if lo <= addr <= hi
            return :fram
        end
    end
    @warn "Address $addr not in any memory region"
    return :other
end

"""
Accumulate per-event memory access counts for logging.
"""
function update_access_counts!(
    counts::Dict{Symbol,Int},
    execution_trace::ExecutionTrace,
    memory_regions,
)::Dict{Symbol,Int}
    for execution_event in execution_trace
        if execution_event.type == Inst ||
            isempty(execution_event.operand_addressing_mode_and_constants)
            continue
        end

        addr = execution_event.operand_addressing_mode_and_constants[1]
        region = classify_region(addr, memory_regions)

        if execution_event.type == FRAMReadHit
            counts[:fram_read_hit] = get(counts, :fram_read_hit, 0) + 1
            counts[:reads] = get(counts, :reads, 0) + 1
        elseif execution_event.type == FRAMReadMiss
            counts[:fram_read_miss] = get(counts, :fram_read_miss, 0) + 1
            counts[:reads] = get(counts, :reads, 0) + 1
        elseif execution_event.type == FRAMWrite
            counts[:fram_write] = get(counts, :fram_write, 0) + 1
            counts[:writes] = get(counts, :writes, 0) + 1
        elseif execution_event.type == SRAMRead
            counts[:sram_read] = get(counts, :sram_read, 0) + 1
            counts[:reads] = get(counts, :reads, 0) + 1
        elseif execution_event.type == SRAMWrite
            counts[:sram_write] = get(counts, :sram_write, 0) + 1
            counts[:writes] = get(counts, :writes, 0) + 1
        else
            counts[:other] = get(counts, :other, 0) + 1
        end

        counts[region] = get(counts, region, 0) + 1
        counts[:total] = get(counts, :total, 0) + 1
    end
    return counts
end

"""
Load bytes from an objdump -s data dump file into machine memory.
Returns true if any bytes were written.
"""
function load_memory_dump!(state::MachineState, data_file::String)::Bool
    if !isfile(data_file)
        @warn "Data dump file not found; skipping memory preload" data_file
        return false
    end

    bytes_written = 0
    current_section = nothing

    for raw_line in eachline(data_file)
        if startswith(raw_line, "Contents of section ")
            m = match(r"Contents of section (\S+):", raw_line)
            current_section = isnothing(m) ? nothing : m.captures[1]
            continue
        end

        if isnothing(current_section)
            continue
        end

        line = strip(raw_line)
        isempty(line) && continue

        parts = split(line)
        isempty(parts) && continue

        addr_str = parts[1]
        if !all(c -> c in _HEX_CHARS, addr_str)
            continue
        end

        addr = parse(UInt32, addr_str; base=16)

        hex_tokens = String[]
        for token in parts[2:end]
            # Stop once ASCII column appears; only accept even-length hex tokens
            if iseven(length(token)) && all(c -> c in _HEX_CHARS, token)
                push!(hex_tokens, token)
            else
                break  # Stop when ASCII column starts
            end
        end

        isempty(hex_tokens) && continue

        hex_str = join(hex_tokens, "")
        for i in 1:2:length(hex_str)
            byte_val = parse(UInt8, hex_str[i:(i + 1)]; base=16)
            write_memory!(state, addr + UInt32(div(i - 1, 2)), UInt32(byte_val), :byte)
            bytes_written += 1
        end
    end

    if bytes_written == 0
        @warn "No bytes loaded from data dump" data_file
        return false
    end

    @info "Preloaded memory from data dump" data_file bytes = bytes_written
    return true
end

"""
Format all register values in a formatted way for MSP430
"""
function format_registers(state)::String
    io = IOBuffer()
    println(io, "--- MSP430 Register State ---")
    # Format special registers first
    for (name, label) in [(:PC, "PC "), (:SP, "SP "), (:SR, "SR ")]
        value = get(state.registers, name, UInt16(0))
        @printf(io, "%-3s value_hex=0x%04x value_dec=%d\n", label, value, Int(value))
    end
    # Format general purpose registers
    for i in 3:15
        reg_name = Symbol("R$i")
        value = get(state.registers, reg_name, UInt16(0))
        @printf(io, "R%-2d value_hex=0x%04x value_dec=%d\n", i, value, Int(value))
    end
    println(io, "flags = $(state.flags)")
    println(io, "-----------------------------")
    return String(take!(io))
end

function _memory_op_debug_msg(
    state::MachineState, inst::Instruction, old_regs::Dict{Symbol,UInt32}
)::Union{String,Nothing}
    # Use a side-effect-free read of operand values using the pre-execution register snapshot
    function _peek_operand_value(operand::Operand, data_size::Symbol)::UInt32
        if operand.mode == :immediate
            return apply_data_size_mask(UInt32(operand.value), data_size)
        elseif operand.mode == :register
            return apply_data_size_mask(get(old_regs, operand.value, UInt32(0)), data_size)
        elseif operand.mode == :indirect
            operand_str = string(operand.value)
            reg_name = Symbol(operand_str[2:end])
            addr = get(old_regs, reg_name, UInt32(0))
            return read_memory(state, addr, data_size)
        elseif operand.mode == :autoincrement
            operand_str = string(operand.value)
            reg_name = Symbol(operand_str[2:end])
            addr = get(old_regs, reg_name, UInt32(0))
            return read_memory(state, addr, data_size)
        elseif operand.mode == :indexed || operand.mode == :symbolic
            offset, reg = operand.value
            base_addr = get(old_regs, reg, UInt32(0))
            if operand.mode == :symbolic
                base_addr = UInt32((base_addr + 2) & get_register_mask(reg))
            end
            addr = UInt32((base_addr + offset) & get_register_mask(reg))
            return read_memory(state, addr, data_size)
        elseif operand.mode == :absolute
            return read_memory(state, UInt32(operand.value), data_size)
        else
            return UInt32(0)
        end
    end

    # Only create a message if we can recognize a memory read/write
    if length(inst.operands) >= 2
        # Case 1: memory writes — indexed addressing on the destination
        dst_operand = inst.operands[2]
        if dst_operand.mode == :indexed
            offset, reg = dst_operand.value
            base_addr = get(old_regs, reg, UInt32(0))
            addr = UInt32((base_addr + offset) & 0xFFFFF)
            if inst.opcode == :mov
                src_val = _peek_operand_value(inst.operands[1], inst.data_size)
                return "    Memory[0x$(string(addr, base=16, pad=5))] = $src_val"
            end
        end

        # Case 2: memory reads — indirect addressing on the source
        src_operand = inst.operands[1]
        if src_operand.mode == :indirect
            operand_str = string(src_operand.value)
            reg_name = Symbol(operand_str[2:end])
            addr = get(old_regs, reg_name, UInt32(0))
            val = get(state.memory, addr, UInt16(0))
            return "    Memory[0x$(string(addr, base=16, pad=5))] → $val"
        end
    end
    return nothing
end

"""
Parse MSP430 assembly file and extract instructions with their addresses
"""
function parse_asm_file(filename::String)::Tuple{Vector{Instruction},Vector{Tuple{UInt32,UInt32}},UInt32}
    if !isfile(filename)
        error("Assembly file not found: $filename")
    end

    lines = readlines(filename)
    instructions = Instruction[]
    address_info = Tuple{UInt32,UInt32}[]  # Vector of (address, length) tuples
    base_address = nothing

    @info "Parsing assembly file" filename

    for line in lines
        line = strip(line)

        # Skip empty lines and headers
        if isempty(line) || occursin("Disassembly", line) || occursin("file format", line)
            continue
        end

        # Parse instruction lines like "4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00"
        # Format: ADDRESS: HEX_BYTES INSTRUCTION
        # Hex bytes are pairs of hex digits separated by single spaces, followed by tabs/multiple spaces
        match_result = match(
            r"^\s*([0-9a-fA-F]{4}):\s+([0-9a-fA-F\s]+?)\s{2,}([a-zA-Z][^;]*)", line
        )

        if match_result !== nothing
            addr_str = match_result.captures[1]
            hex_bytes = match_result.captures[2]
            instr_str = strip(match_result.captures[3])

            # Calculate instruction length from hex bytes
            # Each pair of hex digits (e.g., "31 40") is one byte
            hex_byte_count = length(split(strip(hex_bytes)))
            instr_len = UInt32(hex_byte_count)

            # Parse address (MSP430X uses 20-bit addressing)
            addr = parse(UInt32, addr_str; base=16)

            # Set base address to the first instruction address
            if base_address === nothing
                base_address = addr
            end

            # Parse the instruction string with current address for relative jump resolution
            # Special case: RPT instruction contains two instructions on one line
            if contains(instr_str, "{")
                # Parse RPT: "rpt #N { instruction"
                rpt_instr = Parser.parse_rpt_instruction(String(instr_str), addr)
                # Parse the nested instruction at addr+2
                nested_instr = Parser.parse_rpt_nested_instruction(
                    String(instr_str), UInt32(addr + 2)
                )
                if !isnothing(rpt_instr)
                    rpt_with_nested = Instruction(
                        rpt_instr.opcode,
                        rpt_instr.operands,
                        rpt_instr.data_size;
                        rpt_nested=nested_instr,
                    )
                    push!(instructions, rpt_with_nested)
                    push!(address_info, (addr, UInt32(2)))  # RPT instruction is 2 bytes
                end

                if !isnothing(nested_instr)
                    push!(instructions, nested_instr)
                    push!(address_info, (addr + UInt32(2), instr_len - UInt32(2)))  # Nested instruction takes remaining bytes
                end
            else
                parsed_instr = Parser.parse_line(String(instr_str), addr)
                if !isnothing(parsed_instr)
                    push!(instructions, parsed_instr)
                    push!(address_info, (addr, instr_len))
                end
            end
        end
    end

    if isempty(instructions)
        error("No parseable instructions found in assembly file")
    end

    @info "Successfully parsed MSP430 instructions" count = length(instructions) base_address = string(
        base_address; base=16, pad=4
    )

    return instructions, address_info, base_address
end

FUNCTIONS_TO_SKIP = [
    "initialize",
    "toggle_gpio",
    "begin_measurement_window",
    "end_measurement_window",
    "begin_event",
    "end_event",
    "delay",
]

"""
Interpret MSP430 program
"""
function interpret_program(
    instructions::Vector{Instruction},
    address_info::Vector{Tuple{UInt32,UInt32}},
    func_addrs::Dict{String,UInt32},
    max_steps::Int;
    data_file::Union{String,Nothing}=nothing,
    memory_regions=build_memory_regions(),
    log_memory_access::Bool=false,
)::Tuple{MachineState,Vector{ExecutionTrace},Vector{Dict{Symbol,Int}}}
    @info "="^60
    @info "Interpret Program"
    @info "="^60

    # Extract function addresses from the dictionary
    skip_func_addrs = Dict{String,UInt32}()
    for func_name in FUNCTIONS_TO_SKIP
        func_addr = get(func_addrs, func_name, nothing)
        if !isnothing(func_addr)
            skip_func_addrs[func_name] = func_addr
            @info "$func_name found in assembly file" address =
                "0x" * string(func_addr; base=16, pad=4)
        end
    end

    debug_func_names = [
        :debug_out_u16,
        :debug_out_i16,
        :debug_out_hex,
        :debug_out_char,
        :debug_out_u32,
        :debug_out_str,
    ]
    debug_call_targets = Dict{UInt32,Symbol}()
    for func_name in debug_func_names
        func_addr = get(func_addrs, String(func_name), nothing)
        if !isnothing(func_addr)
            debug_call_targets[func_addr] = func_name
            @debug "Debug function stub detected" func = func_name address =
                "0x" * string(func_addr; base=16, pad=4)
        end
    end

    state = MachineState()
    state.registers[:PC] = address_info[1][1]  # Start at the first instruction address

    if !isnothing(data_file)
        load_memory_dump!(state, data_file)
    end

    # Track execution traces between begin_event and end_event
    execution_traces = Vector{ExecutionTrace}()
    event_accesses = Vector{Dict{Symbol,Int}}()
    current_execution_trace = ExecutionTrace()
    current_event_access = Ref{Union{Nothing,Dict{Symbol,Int}}}(nothing)
    exit_addr = get(func_addrs, "_exit", nothing)

    # Show the program
    @info "instruction_count" count = length(instructions)
    for (i, inst) in enumerate(instructions)
        size_str = inst.data_size == :byte ? ".b" : ""
        operand_info = ["$(op.value) [$(op.mode)]" for op in inst.operands]
        @debug "Instruction $i" opcode = "$(inst.opcode)$size_str" operands = join(
            operand_info, ", "
        )
    end

    pc_to_instruction = Dict{UInt32,Tuple{Int,Instruction}}()
    for (i, ((addr, _), inst)) in enumerate(zip(address_info, instructions))
        pc_to_instruction[addr] = (i, inst)
    end

    @debug "Initial machine state" pc = string(state.registers[:PC]; base=16, pad=4) sp = string(
        state.registers[:SP]; base=16, pad=4
    ) PC = state.registers[:PC] SP = state.registers[:SP] SR = state.registers[:SR] r3 = state.registers[:R3] r4 = state.registers[:R4] r5 = state.registers[:R5]
    step_count = 0

    # Start timing execution
    start_time = time()

    while step_count < max_steps
        if exit_addr !== nothing && state.registers[:PC] == exit_addr
            @info "Program terminated at _exit" pc = string(
                state.registers[:PC]; base=16, pad=4
            )
            break
        end

        step_count += 1
        state.current_operand_cache_hits = Bool[]
        state.current_inst_cache_hit = true

        # Get instruction at current PC
        if !haskey(pc_to_instruction, state.registers[:PC])
            @info "Execution finished" pc = string(state.registers[:PC]; base=16, pad=4) reason =
                "PC not in program (this may not be a bug. It seems that GCC sometimes " *
                "optimizes away the tail of the main function which restores the stack " *
                "pointer, so main may not return correctly.)"
            break
        end

        current_addr_idx, inst = pc_to_instruction[state.registers[:PC]]

        try
            old_pc = state.registers[:PC]
            debug_enabled = Logging.shouldlog(
                current_logger(), Logging.Debug, @__MODULE__, "", nothing
            )
            old_regs = debug_enabled ? copy(state.registers) : nothing

            # Pre-check if this is a call instruction to avoid multiple function checks
            is_call = inst.opcode == :call

            if is_call
                call_target = get_operand_value(state, inst.operands[1])

                # Check for debug_out_* stubs; handle in interpreter and skip call
                if haskey(debug_call_targets, call_target)
                    func_sym = debug_call_targets[call_target]
                    handle_debug_function_call!(state, func_sym, old_pc)
                    if current_addr_idx < length(address_info)
                        state.registers[:PC] = address_info[current_addr_idx + 1][1]
                    end
                    continue
                end

                # Check for begin_event
                if get(func_addrs, "begin_event", nothing) == call_target
                    @debug "Skipping begin_event call at 0x$(string(old_pc, base=16, pad=4))"
                    current_execution_trace = ExecutionTrace()
                    if log_memory_access
                        current_event_access[] = Dict(
                            :fram => 0,
                            :sram => 0,
                            :other => 0,
                            :fram_read_hit => 0,
                            :fram_read_miss => 0,
                            :fram_write => 0,
                            :sram_read => 0,
                            :sram_write => 0,
                            :reads => 0,
                            :writes => 0,
                            :total => 0,
                        )
                    end
                    state.registers[:PC] = address_info[current_addr_idx + 1][1]
                    continue
                end

                # Check for end_event
                if get(func_addrs, "end_event", nothing) == call_target
                    @debug "Skipping end_event call at 0x$(string(old_pc, base=16, pad=4))"
                    push!(execution_traces, copy(current_execution_trace))
                    if log_memory_access && current_event_access[] !== nothing
                        push!(event_accesses, deepcopy(current_event_access[]))
                        current_event_access[] = nothing
                    end
                    state.registers[:PC] = address_info[current_addr_idx + 1][1]
                    continue
                end

                # Check for other functions to skip
                skip_function = false
                for (func_name, func_addr) in skip_func_addrs
                    if func_addr == call_target
                        @debug "Skipping call to $func_name at 0x$(string(old_pc, base=16, pad=4))"
                        state.registers[:PC] = address_info[current_addr_idx + 1][1]
                        skip_function = true
                        break
                    end
                end

                if skip_function
                    continue
                end
            end

            # Execute the instruction
            events = execute_instruction!(state, inst, address_info, current_addr_idx)
            append!(current_execution_trace, events)
            if log_memory_access && current_event_access[] !== nothing
                update_access_counts!(current_event_access[], events, memory_regions)
            end

            # Debug logging only when needed
            if debug_enabled && old_regs !== nothing
                if (msg = _memory_op_debug_msg(state, inst, old_regs)) !== nothing
                    @debug msg
                end
                @debug "Step $step_count" address = string(old_pc; base=16, pad=4) opcode =
                    inst.opcode operands = inst.operands
                @debug "PC transition" old_pc = string(old_pc; base=16, pad=4) new_pc = string(
                    state.registers[:PC]; base=16, pad=4
                )
                @debug format_registers(state)
            end

        catch e
            @error "Error executing instruction" pc = string(
                state.registers[:PC]; base=16, pad=4
            ) opcode = inst.opcode error = e
            break
        end
    end

    if step_count >= max_steps
        @warn "Execution stopped: Maximum steps reached" max_steps
    end

    # Calculate and log execution time
    execution_time = time() - start_time
    @info "Execution completed" time = execution_time steps = step_count

    # Show final state
    @info "Final machine state" pc = string(state.registers[:PC]; base=16, pad=4)
    @info format_registers(state)
    @info "Flags" V = state.flags[:V] N = state.flags[:N] Z = state.flags[:Z] C = state.flags[:C]
    # If an event was started but not ended, flush its access counts and trace.
    if log_memory_access &&
        current_event_access[] !== nothing &&
        !isempty(current_execution_trace)
        push!(execution_traces, copy(current_execution_trace))
        push!(event_accesses, deepcopy(current_event_access[]))
    end

    @info "Execution traces collected" count = length(execution_traces)

    return (state, execution_traces, event_accesses)
end

end # module
