module Interpreter

using Statistics
using Gen
using Printf
using Logging
using ..TraceMetrics: FRAM_RANGES, SRAM_RANGES
using ..Types:
    Instruction,
    Operand,
    MachineState,
    MultiplierState,
    ExecutionEvent,
    ExecutionTrace,
    CacheLine,
    Inst,
    FRAMReadHit,
    FRAMReadMiss,
    FRAMWrite,
    SRAMRead,
    SRAMWrite,
    WithEvent,
    ModelGranularity,
    Key,
    get_should_track_memory_access
using ..Parser

include("machine_state.jl")

const _HEX_CHARS = Set("0123456789abcdefABCDEF")

"""
Load bytes from an objdump -s data dump file into machine memory.
Loads data at LMA (Load Memory Address) rather than VMA (Virtual Memory Address)
so that the C runtime startup code can properly copy initialized data from ROM to RAM.
Returns true if any bytes were written.
"""
function load_memory_dump!(state::MachineState, data_file::String)::Bool
    if !isfile(data_file)
        @warn "Data dump file not found; skipping memory preload" data_file
        return false
    end

    # First pass: parse section headers to build VMA→LMA mapping
    # Format: "# section_name size vma lma"
    section_info = Dict{String,Tuple{UInt32,UInt32}}()  # section_name => (vma, lma)

    for raw_line in eachline(data_file)
        if startswith(raw_line, "# ") && !startswith(raw_line, "# Section headers")
            parts = split(strip(raw_line[3:end]))
            if length(parts) >= 4
                section_name = parts[1]
                # parts[2] is size, parts[3] is VMA, parts[4] is LMA
                vma = tryparse(UInt32, parts[3]; base=16)
                lma = tryparse(UInt32, parts[4]; base=16)
                if !isnothing(vma) && !isnothing(lma)
                    section_info[section_name] = (vma, lma)
                end
            end
        end
    end

    @debug "Parsed section headers" sections = keys(section_info)

    # Second pass: load data at LMA addresses
    bytes_written = 0
    current_section = nothing
    current_vma_offset = UInt32(0)  # LMA - VMA for current section

    for raw_line in eachline(data_file)
        if startswith(raw_line, "Contents of section ")
            m = match(r"Contents of section (\S+):", raw_line)
            current_section = isnothing(m) ? nothing : m.captures[1]
            if !isnothing(current_section) && haskey(section_info, current_section)
                vma, lma = section_info[current_section]
                current_vma_offset = lma - vma
                if current_vma_offset != 0
                    @debug "Section has VMA≠LMA, will load at LMA" section = current_section vma =
                        "0x" * string(vma; base=16, pad=4) lma =
                        "0x" * string(lma; base=16, pad=4)
                end
            else
                current_vma_offset = UInt32(0)
            end
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

        vma_addr = parse(UInt32, addr_str; base=16)
        # Translate VMA to LMA
        lma_addr = vma_addr + current_vma_offset

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
            # Direct memory write for initialization (no event tracking needed)
            state.memory[lma_addr + UInt32(div(i - 1, 2))] = UInt16(byte_val)
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
    # do not track memory access for debug
    should_track_memory_access = false
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
            # Use read_memory with no inst (no event tracking for debug)
            val, _ = read_memory(
                state, addr, data_size, nothing, should_track_memory_access
            )
            return val
        elseif operand.mode == :autoincrement
            operand_str = string(operand.value)
            reg_name = Symbol(operand_str[2:end])
            addr = get(old_regs, reg_name, UInt32(0))
            # Use read_memory with no inst (no event tracking for debug)
            val, _ = read_memory(
                state, addr, data_size, nothing, should_track_memory_access
            )
            return val
        elseif operand.mode == :indexed || operand.mode == :symbolic
            offset, reg = operand.value
            base_addr = get(old_regs, reg, UInt32(0))
            if operand.mode == :symbolic
                base_addr = UInt32((base_addr + 2) & get_register_mask(reg))
            end
            addr = UInt32((base_addr + offset) & get_register_mask(reg))
            # Use read_memory with no inst (no event tracking for debug)
            val, _ = read_memory(
                state, addr, data_size, nothing, should_track_memory_access
            )
            return val
        elseif operand.mode == :absolute
            # Use read_memory with no inst (no event tracking for debug)
            val, _ = read_memory(
                state, UInt32(operand.value), data_size, nothing, should_track_memory_access
            )
            return val
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
Parse MSP430 assembly content from a string and extract instructions with their addresses.
Returns (instructions, address_info, base_address).
"""
function parse_asm_string(
    content::String
)::Tuple{Vector{Instruction},Vector{Tuple{UInt32,UInt32}},UInt32}
    lines = split(content, '\n')
    instructions = Instruction[]
    address_info = Tuple{UInt32,UInt32}[]  # Vector of (address, length) tuples
    base_address = nothing

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
        error("No parseable instructions found in assembly content")
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
    max_steps::Int,
    model_granularity::ModelGranularity;
    data_file::Union{String,Nothing}=nothing,
)::Tuple{MachineState,Vector{ExecutionTrace}}
    @info "="^60
    @info "Interpret Program"
    @info "="^60

    # Extract function addresses from the dictionary
    skip_func_addrs = Dict{String,UInt32}()
    for func_name in FUNCTIONS_TO_SKIP
        func_addr = get(func_addrs, func_name, nothing)
        if !isnothing(func_addr)
            skip_func_addrs[func_name] = func_addr
            @debug "$func_name found in assembly file" address =
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
    current_execution_trace = ExecutionTrace()
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
                call_target, _ = get_operand_value(
                    state, inst.operands[1], inst.data_size, inst, false
                )

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
                    state.registers[:PC] = address_info[current_addr_idx + 1][1]
                    continue
                end

                # Check for end_event
                if get(func_addrs, "end_event", nothing) == call_target
                    @debug "Skipping end_event call at 0x$(string(old_pc, base=16, pad=4))"
                    push!(execution_traces, copy(current_execution_trace))
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
            events = execute_instruction!(
                state, inst, address_info, current_addr_idx, model_granularity
            )
            append!(current_execution_trace, events)

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
            # Log the full exception and backtrace to aid debugging before halting execution
            bt = catch_backtrace()
            @error "Error executing instruction" pc = string(
                state.registers[:PC]; base=16, pad=4
            ) opcode = inst.opcode exception = (e, bt)
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
    @debug "Final machine state" pc = string(state.registers[:PC]; base=16, pad=4)
    @debug format_registers(state)
    @debug "Flags" V = state.flags[:V] N = state.flags[:N] Z = state.flags[:Z] C = state.flags[:C]

    @info "Execution traces collected" count = length(execution_traces)

    return (state, execution_traces)
end

end # module
