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
            return get_memory_value(state, addr, data_size)
        elseif operand.mode == :autoincrement
            operand_str = string(operand.value)
            reg_name = Symbol(operand_str[2:end])
            addr = get(old_regs, reg_name, UInt32(0))
            return get_memory_value(state, addr, data_size)
        elseif operand.mode == :indexed || operand.mode == :symbolic
            offset, reg = operand.value
            base_addr = get(old_regs, reg, UInt32(0))
            if operand.mode == :symbolic
                base_addr = UInt32((base_addr + 2) & get_register_mask(reg))
            end
            addr = UInt32((base_addr + offset) & get_register_mask(reg))
            return get_memory_value(state, addr, data_size)
        elseif operand.mode == :absolute
            return get_memory_value(state, UInt32(operand.value), data_size)
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
                nested_instr = Parser.parse_rpt_nested_instruction(
                    String(instr_str), UInt32(addr + 2)
                )
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
    "delay",
]

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
            debug_enabled = Logging.shouldlog(
                current_logger(), Logging.Debug, @__MODULE__, "", nothing
            )
            old_regs = debug_enabled ? copy(state.registers) : nothing

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

            # Execute the instruction
            execute_instruction!(state, inst, addresses, current_addr_idx)
            push!(current_sequence, inst)

            # Check termination after execution
            if should_terminate
                @info "Program terminated"
                break
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
    @info "Event sequences collected" count = length(event_sequences)

    return (state, event_sequences)
end

end # module
