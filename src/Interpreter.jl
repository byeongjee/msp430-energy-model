module Interpreter

using Statistics
using Gen
using Printf
using Logging
using ..Types: Instruction, Operand, MachineState
using ..Parser

include("machine_state.jl")

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
    # Only create a message if we can recognize a memory read/write
    if length(inst.operands) >= 2
        # Case 1: memory writes — indexed addressing on the destination
        dst_operand = inst.operands[2]
        if dst_operand.mode == :indexed
            offset, reg = dst_operand.value
            base_addr = get(old_regs, reg, UInt32(0))
            addr = UInt32((base_addr + offset) & 0xFFFFF)
            if inst.opcode == :mov
                src_val = get_operand_value(state, inst.operands[1])
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
function parse_asm_file(filename::String)::Tuple{Vector{Instruction},Vector{UInt32},UInt32}
    if !isfile(filename)
        error("Assembly file not found: $filename")
    end

    lines = readlines(filename)
    instructions = Instruction[]
    addresses = UInt32[]
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
                if !isnothing(rpt_instr)
                    push!(instructions, rpt_instr)
                    push!(addresses, addr)
                end

                # Parse the nested instruction at addr+2
                nested_instr = Parser.parse_rpt_nested_instruction(String(instr_str), UInt32(addr + 2))
                if !isnothing(nested_instr)
                    push!(instructions, nested_instr)
                    push!(addresses, addr + 2)
                end
            else
                parsed_instr = Parser.parse_line(String(instr_str), addr)
                if !isnothing(parsed_instr)
                    push!(instructions, parsed_instr)
                    push!(addresses, addr)
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

    return instructions, addresses, base_address
end

FUNCTIONS_TO_SKIP = [
    "initialize",
    "toggle_gpio",
    "begin_measurement_window",
    "end_measurement_window",
    "begin_event",
    "end_event",
]

"""
Fast-path handler for memset(void *ptr, int value, size_t num)
MSP430 calling convention: r12=ptr, r13=value, r14=num
"""
function handle_memset!(state::MachineState)::Nothing
    ptr = state.registers[:R12]
    value = UInt8(state.registers[:R13] & 0xFF)
    num = state.registers[:R14]

    # Fill memory directly
    for i in 0:(num - 1)
        addr = UInt32((ptr + i) & 0xFFFFF)
        state.memory[addr] = UInt16(value)
    end

    # Update registers to match what the actual memset assembly would do
    # The memset implementation: R14 = ptr + num, R15 = ptr + num
    state.registers[:R14] = UInt32((ptr + num) & 0xFFFFF)
    state.registers[:R15] = UInt32((ptr + num) & 0xFFFFF)

    @debug "Fast-path: memset filled $num bytes at 0x$(string(ptr, base=16, pad=4)) with value $value"
    return nothing
end

"""
Fast-path handler for memmove/memcpy(void *dest, const void *src, size_t num)
MSP430 calling convention: r12=dest, r13=src, r14=num
"""
function handle_memmove!(state::MachineState)::Nothing
    dest = state.registers[:R12]
    src = state.registers[:R13]
    num = state.registers[:R14]

    # Copy memory directly (handle overlapping regions for memmove)
    if dest <= src || dest >= src + num
        # Non-overlapping or dest before src: copy forward
        for i in 0:(num - 1)
            src_addr = UInt32((src + i) & 0xFFFFF)
            dest_addr = UInt32((dest + i) & 0xFFFFF)
            state.memory[dest_addr] = get(state.memory, src_addr, UInt16(0))
        end
    else
        # Overlapping with dest after src: copy backward
        for i in (num - 1):-1:0
            src_addr = UInt32((src + i) & 0xFFFFF)
            dest_addr = UInt32((dest + i) & 0xFFFFF)
            state.memory[dest_addr] = get(state.memory, src_addr, UInt16(0))
        end
    end

    # Update registers to match what the actual memmove assembly would do
    # The memmove implementation increments R13 and R14 as it copies bytes
    state.registers[:R13] = UInt32((src + num) & 0xFFFFF)
    state.registers[:R14] = UInt32((dest + num) & 0xFFFFF)
    state.registers[:R15] = UInt32((src + num) & 0xFFFFF)

    # Clear all flags - the actual memmove ends with all flags clear
    # The last comparison before return compares equal values, but testing shows
    # that GDB reports all flags as 0 after memmove completes
    state.flags[:C] = false
    state.flags[:Z] = false
    state.flags[:N] = false
    state.flags[:V] = false

    # Sync flags to SR register
    state.registers[:SR] =
        (state.registers[:SR] & 0xFFF0) |
        (state.flags[:V] ? 0x0100 : 0x0000) |
        (state.flags[:N] ? 0x0004 : 0x0000) |
        (state.flags[:Z] ? 0x0002 : 0x0000) |
        (state.flags[:C] ? 0x0001 : 0x0000)

    @debug "Fast-path: memmove/memcpy copied $num bytes from 0x$(string(src, base=16, pad=4)) to 0x$(string(dest, base=16, pad=4))"
    return nothing
end

"""
memset/memmove/memcpy functions are reasonably fast in real hardward
but extremely slow in our interpreter.
We handle the function calls with fast-path optimizations.
"""
function try_fast_path_call!(
    state::MachineState,
    call_target::UInt32,
    func_addrs::Dict{String,UInt32},
    addresses::Vector{UInt32},
    current_idx::Int,
)::Bool
    # memset
    memset_addr = get(func_addrs, "memset", nothing)
    if !isnothing(memset_addr) && call_target == memset_addr
        handle_memset!(state)
        state.registers[:PC] = addresses[current_idx + 1]
        return true
    end

    # memmove/memcpy
    memmove_addr = get(func_addrs, "memmove", nothing)
    memcpy_addr = get(func_addrs, "memcpy", nothing)
    if (!isnothing(memmove_addr) && call_target == memmove_addr) ||
        (!isnothing(memcpy_addr) && call_target == memcpy_addr)
        handle_memmove!(state)
        state.registers[:PC] = addresses[current_idx + 1]
        return true
    end

    return false
end

"""
Interpret MSP430 program
"""
function interpret_program(
    instructions::Vector{Instruction},
    addresses::Vector{UInt32},
    func_addrs::Dict{String,UInt32},
    max_steps::Int,
)::Tuple{MachineState,Vector{Vector{Instruction}}}
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

    # Track instruction sequences between begin_event and end_event
    event_sequences = Vector{Vector{Instruction}}()
    current_sequence = Vector{Instruction}()

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
    for (i, (addr, inst)) in enumerate(zip(addresses, instructions))
        pc_to_instruction[addr] = (i, inst)
    end

    state = MachineState()
    state.registers[:PC] = addresses[1]  # Start at the first instruction address

    @debug "Initial machine state" pc = string(state.registers[:PC]; base=16, pad=4) sp = string(
        state.registers[:SP]; base=16, pad=4
    ) PC = state.registers[:PC] SP = state.registers[:SP] SR = state.registers[:SR] r3 = state.registers[:R3] r4 = state.registers[:R4] r5 = state.registers[:R5]
    step_count = 0

    # Start timing execution
    start_time = time()

    while step_count < max_steps
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

            # Pre-check if this is a call instruction to avoid multiple function checks
            is_call = inst.opcode == :call
            should_terminate = false

            if is_call
                call_target = get_operand_value(state, inst.operands[1])

                # Check for begin_event
                if get(func_addrs, "begin_event", nothing) == call_target
                    @debug "Skipping begin_event call at 0x$(string(old_pc, base=16, pad=4))"
                    current_sequence = Vector{Instruction}()
                    state.registers[:PC] = addresses[current_addr_idx + 1]
                    continue
                end

                # Check for end_event
                if get(func_addrs, "end_event", nothing) == call_target
                    @debug "Skipping end_event call at 0x$(string(old_pc, base=16, pad=4))"
                    push!(event_sequences, copy(current_sequence))
                    state.registers[:PC] = addresses[current_addr_idx + 1]
                    continue
                end

                # Check for other functions to skip
                skip_function = false
                for (func_name, func_addr) in skip_func_addrs
                    if func_addr == call_target
                        @debug "Skipping call to $func_name at 0x$(string(old_pc, base=16, pad=4))"
                        state.registers[:PC] = addresses[current_addr_idx + 1]
                        skip_function = true
                        break
                    end
                end

                if skip_function
                    continue
                end

                # Check for termination (_exit) - set flag but still execute
                if get(func_addrs, "_exit", nothing) == call_target
                    should_terminate = true
                end
            end

            # Try fast-path optimization for common library functions
            if is_call && try_fast_path_call!(
                state, call_target, func_addrs, addresses, current_addr_idx
            )
                continue
            end

            # Execute the instruction
            execute_instruction!(state, inst, addresses, current_addr_idx)
            push!(current_sequence, inst)

            # Check termination after execution
            if should_terminate
                @info "Program terminated"
                break
            end

            # Debug logging only when needed
            if Logging.shouldlog(current_logger(), Logging.Debug, @__MODULE__, "", nothing)
                # Only copy registers when debug logging is active
                old_regs = copy(state.registers)
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
    @info "Event sequences collected" count = length(event_sequences)

    return (state, event_sequences)
end

end # module
