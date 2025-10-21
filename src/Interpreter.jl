module Interpreter

using Statistics
using Gen
using Printf
using Logging

# Use Main.EnergyModel to avoid type conflicts
using Main.EnergyModel

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
    state::MachineState, inst::Instruction, old_regs::Dict{Symbol,UInt16}
)::Union{String,Nothing}
    # Only create a message if we can recognize a memory read/write
    if length(inst.operands) >= 2
        # Case 1: memory writes — indexed addressing on the destination
        if isa(inst.operands[2], Tuple)
            offset, reg = inst.operands[2]
            base_addr = get(old_regs, reg, UInt16(0))
            addr = UInt16((base_addr + offset) & 0xFFFF)
            if inst.opcode == :mov
                src_val = Main.EnergyModel.get_operand_value(state, inst.operands[1])
                return "    Memory[0x$(string(addr, base=16, pad=4))] = $src_val"
            end

            # Case 2: memory reads — indirect addressing on the source (e.g., :@R5)
        elseif isa(inst.operands[1], Symbol) &&
            !isempty(string(inst.operands[1])) &&
            string(inst.operands[1])[1] == '@'
            reg_name = Symbol(string(inst.operands[1])[2:end])
            addr = get(old_regs, reg_name, UInt16(0))
            val = get(state.memory, addr, UInt16(0))
            return "    Memory[0x$(string(addr, base=16, pad=4))] → $val"
        end
    end
    return nothing
end

"""
Parse MSP430 assembly file and extract instructions with their addresses
"""
function parse_asm_file(filename::String)::Tuple{Vector{Instruction},Vector{UInt16},UInt16}
    if !isfile(filename)
        error("Assembly file not found: $filename")
    end

    lines = readlines(filename)
    instructions = Instruction[]
    addresses = UInt16[]
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

            # Parse address
            addr = parse(UInt16, addr_str; base=16)

            # Set base address to the first instruction address
            if base_address === nothing
                base_address = addr
            end

            # Parse the instruction string with current address for relative jump resolution
            parsed_instr = parse_line(String(instr_str), addr)
            if !isnothing(parsed_instr)
                push!(instructions, parsed_instr)
                push!(addresses, addr)
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

function detect_termination(
    state::MachineState, inst::Instruction, func_addrs::Dict{String,UInt16}
)::Bool
    return is_call_to_function(state, inst, "_exit", func_addrs)
end

FUNCTIONS_TO_SKIP = [
    "begin_event",
    "end_event",
    "initialize",
    "toggle_gpio",
    "begin_measurement_window",
    "end_measurement_window",
]

function is_call_to_function(
    state::MachineState,
    inst::Instruction,
    func_name::String,
    func_addrs::Dict{String,UInt16},
)::Bool
    if isnothing(get(func_addrs, func_name, nothing))
        return false
    end
    return inst.opcode == :call &&
           length(inst.operands) > 0 &&
           Main.EnergyModel.get_operand_value(state, inst.operands[1]) ==
           func_addrs[func_name]
end

"""
Interpret MSP430 program
"""
function interpret_program(
    instructions::Vector{Instruction},
    addresses::Vector{UInt16},
    func_addrs::Dict{String,UInt16},
    max_steps::Int,
)::Tuple{MachineState,Vector{Vector{Instruction}}}
    @info "="^60
    @info "Interpret Program"
    @info "="^60

    # Extract function addresses from the dictionary
    for func_name in FUNCTIONS_TO_SKIP
        func_addr = get(func_addrs, func_name, nothing)
        if !isnothing(func_addr)
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
        @debug "Instruction $i" opcode = "$(inst.opcode)$size_str" operands = inst.operands addressing_mode =
            inst.addressing_mode
    end

    # Create PC -> instruction mapping
    pc_to_instruction = Dict{UInt16,Tuple{Int,Instruction}}()
    for (i, (addr, inst)) in enumerate(zip(addresses, instructions))
        pc_to_instruction[addr] = (i, inst)
    end

    state = MachineState()
    state.pc = addresses[1]  # Start at the first instruction address
    state.registers[:PC] = state.pc

    @debug "Initial machine state" pc = string(state.pc; base=16, pad=4) sp = string(
        state.sp; base=16, pad=4
    ) PC = state.registers[:PC] SP = state.registers[:SP] SR = state.registers[:SR] r3 = state.registers[:R3] r4 = state.registers[:R4] r5 = state.registers[:R5]
    step_count = 0

    while step_count < max_steps
        step_count += 1

        # Get instruction at current PC
        if !haskey(pc_to_instruction, state.pc)
            @info "Execution finished" pc = string(state.pc; base=16, pad=4) reason = "PC not in program"
            break
        end

        _instruction_index, inst = pc_to_instruction[state.pc]

        try
            old_pc = state.pc
            old_regs = copy(state.registers)

            # Find current instruction index from the instruction list
            # This is used for relative jump resolution
            current_addr_idx = findfirst(addr -> addr == old_pc, addresses)
            if current_addr_idx === nothing
                error(
                    "Cannot find current PC 0x$(string(old_pc, base=16, pad=4)) in addresses array. This indicates a serious bug in PC management.",
                )
            end

            # Check if this is a call to begin_event and skip it
            if is_call_to_function(state, inst, "begin_event", func_addrs)
                @debug "Skipping begin_event call at 0x$(string(old_pc, base=16, pad=4))"
                @info "starting new event sequence"
                current_sequence = Vector{Instruction}()
            end

            if is_call_to_function(state, inst, "end_event", func_addrs)
                @debug "Skipping end_event call at 0x$(string(old_pc, base=16, pad=4))"
                @info "ending event sequence"
                push!(event_sequences, current_sequence)
            end

            # Skip calls to functions in FUNCTIONS_TO_SKIP
            if any(
                is_call_to_function(state, inst, func_name, func_addrs) for
                func_name in FUNCTIONS_TO_SKIP
            )
                @debug "Skipping call to function at 0x$(string(old_pc, base=16, pad=4))"
                state.pc = addresses[current_addr_idx + 1]
                state.registers[:PC] = state.pc
            else
                execute_instruction!(state, inst, addresses, current_addr_idx)
                push!(current_sequence, inst)
            end

            if Logging.shouldlog(current_logger(), Logging.Debug, @__MODULE__, "", nothing)
                if (msg = _memory_op_debug_msg(state, inst, old_regs)) !== nothing
                    @debug msg
                end
                @debug "Step $step_count" address = string(old_pc; base=16, pad=4) opcode =
                    inst.opcode operands = inst.operands
                @debug "PC transition" old_pc = string(old_pc; base=16, pad=4) new_pc = string(
                    state.pc; base=16, pad=4
                )
                @debug format_registers(state)
            end

            if detect_termination(state, inst, func_addrs)
                @info "Program terminated"
                break
            end

        catch e
            @error "Error executing instruction" pc = string(state.pc; base=16, pad=4) opcode =
                inst.opcode error = e
            break
        end
    end

    if step_count >= max_steps
        @warn "Execution stopped: Maximum steps reached" max_steps
    end

    # Show final state
    @info "Final machine state" pc = string(state.pc; base=16, pad=4)
    @info format_registers(state)
    @info "Flags" V = state.flags[:V] N = state.flags[:N] Z = state.flags[:Z] C = state.flags[:C]
    @info "Event sequences collected" count = length(event_sequences)

    return (state, event_sequences)
end

end # module
