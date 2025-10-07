using Pkg
Pkg.activate(".")

include("../src/EnergyModel.jl")
using .EnergyModel
using Statistics
using Gen
using Printf
using Logging

"""
Format all register values in a formatted way for MSP430
"""
function format_registers(state)::String
    io = IOBuffer()
    println(io, "--- MSP430 Register State ---")
    for i in 0:15
        reg_name = Symbol("R$i")
        value = get(state.registers, reg_name, UInt16(0))
        @printf(io, "R%-2d value_hex=0x%04x value_dec=%d\n", i, value, Int(value))
    end
    println(io, "flags = $(state.flags)")
    println(io, "-----------------------------")
    return String(take!(io))
end

function _memory_op_debug_msg(state::MachineState, inst::Instruction, old_regs::Dict{Symbol,UInt16})::Union{String,Nothing}
    # Only create a message if we can recognize a memory read/write
    if length(inst.operands) >= 2
        # Case 1: memory writes — indexed addressing on the destination
        if isa(inst.operands[2], Tuple)
            offset, reg = inst.operands[2]
            base_addr = get(old_regs, reg, UInt16(0))
            addr = UInt16((base_addr + offset) & 0xFFFF)
            if inst.opcode == :mov
                src_val = EnergyModel.get_operand_value(state, inst.operands[1])
                return "    Memory[0x$(string(addr, base=16, pad=4))] = $src_val"
            end

            # Case 2: memory reads — indirect addressing on the source (e.g., :@R5)
        elseif isa(inst.operands[1], Symbol) && !isempty(string(inst.operands[1])) && string(inst.operands[1])[1] == '@'
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
        match_result = match(r"^\s*([0-9a-fA-F]{4}):\s+([0-9a-fA-F\s]+?)\s{2,}([a-zA-Z][^;]*)", line)

        if match_result !== nothing
            addr_str = match_result.captures[1]
            hex_bytes = match_result.captures[2]
            instr_str = strip(match_result.captures[3])

            # Parse address
            addr = parse(UInt16, addr_str, base=16)

            # Set base address to the first instruction address
            if base_address === nothing
                base_address = addr
            end

            # Parse the instruction string with current address for relative jump resolution
            parsed_instr = EnergyModel.parse_line(String(instr_str), addr)
            if !isnothing(parsed_instr)
                push!(instructions, parsed_instr)
                push!(addresses, addr)
            end
        end
    end

    if isempty(instructions)
        error("No parseable instructions found in assembly file")
    end

    @info "Successfully parsed MSP430 instructions" count = length(instructions) base_address = string(base_address, base=16, pad=4)

    return instructions, addresses, base_address
end

"""
Get addresses of `begin_event` and `end_event` functions from assembly file
Returns a tuple (begin_event_addr, end_event_addr) or (nothing, nothing) if not found
"""
function parse_event_addresses(filename::String)::Tuple{Union{UInt16,Nothing},Union{UInt16,Nothing}}
    if !isfile(filename)
        error("Assembly file not found: $filename")
    end

    lines = readlines(filename)
    begin_event_addr = nothing
    end_event_addr = nothing

    for line in lines
        line = strip(line)

        # Look for function labels like "00004400 <begin_event>:"
        match_result = match(r"^([0-9a-fA-F]{8})\s+<(begin_event|end_event)>:", line)

        if match_result !== nothing
            addr_str = match_result.captures[1]
            func_name = match_result.captures[2]

            # Parse address (take lower 16 bits for MSP430)
            addr = parse(UInt16, addr_str[5:8], base=16)

            if func_name == "begin_event"
                begin_event_addr = addr
            elseif func_name == "end_event"
                end_event_addr = addr
            end
        end
    end

    return (begin_event_addr, end_event_addr)
end

# Check for jmp $+0, which is the infinite loop placed at the end of the program
function detect_termination(inst::Instruction)::Bool
    if inst.opcode == :jmp
        if length(inst.operands) > 0 && inst.operands[1] == -1  # jmp $+0 has offset -1
            return true
        end
    end
    return false
end

"""
Interpret MSP430 program
"""
function interpret_program(instructions::Vector{Instruction}, addresses::Vector{UInt16}, max_steps::Int=1000)::MachineState
    @info "="^60
    @info "Interpret Program"
    @info "="^60

    # Show the program
    @info instruction_count = length(instructions)
    for (i, inst) in enumerate(instructions)
        size_str = inst.data_size == :byte ? ".b" : ""
        @debug "Instruction $i" opcode = "$(inst.opcode)$size_str" operands = inst.operands addressing_mode = inst.addressing_mode
    end

    # Create PC -> instruction mapping
    pc_to_instruction = Dict{UInt16,Tuple{Int,Instruction}}()
    for (i, (addr, inst)) in enumerate(zip(addresses, instructions))
        pc_to_instruction[addr] = (i, inst)
    end

    state = MachineState()
    state.pc = addresses[1]  # Start at the first instruction address
    state.registers[:R0] = state.pc
    state.registers[:PC] = state.pc

    @debug "Initial machine state" pc = string(state.pc, base=16, pad=4) sp = string(state.sp, base=16, pad=4) r0 = state.registers[:R0] r1 = state.registers[:R1] r2 = state.registers[:R2] r3 = state.registers[:R3] r4 = state.registers[:R4] r5 = state.registers[:R5]
    step_count = 0

    while step_count < max_steps
        step_count += 1

        # Get instruction at current PC
        if !haskey(pc_to_instruction, state.pc)
            @info "Execution finished" pc = string(state.pc, base=16, pad=4) reason = "PC not in program"
            break
        end

        instruction_index, inst = pc_to_instruction[state.pc]
        try
            old_pc = state.pc
            old_regs = copy(state.registers)

            # Find current instruction index for address-based PC management
            current_addr_idx = findfirst(addr -> addr == old_pc, addresses)
            if current_addr_idx === nothing
                error("Cannot find current PC 0x$(string(old_pc, base=16, pad=4)) in addresses array. This indicates a serious bug in PC management.")
            end

            # Use the centralized PC management function
            EnergyModel.execute_instruction!(state, inst, addresses, current_addr_idx)

            if Logging.shouldlog(current_logger(), Logging.Debug, @__MODULE__, "", nothing)
                if (msg = _memory_op_debug_msg(state, inst, old_regs)) !== nothing
                    @debug msg
                end
                @debug "Step $step_count" address = string(old_pc, base=16, pad=4) opcode = inst.opcode operands = inst.operands
                @debug "PC transition" old_pc = string(old_pc, base=16, pad=4) new_pc = string(state.pc, base=16, pad=4)
                @debug format_registers(state)
            end

            if detect_termination(inst)
                @info "Program terminated"
                break
            end

        catch e
            @error "Error executing instruction" pc = string(state.pc, base=16, pad=4) opcode = inst.opcode error = e
            break
        end
    end

    if step_count >= max_steps
        @warn "Execution stopped: Maximum steps reached" max_steps
    end

    # Show final state
    @info "Final machine state" pc = string(state.pc, base=16, pad=4)
    @info format_registers(state)
    @info "Flags" V = state.flags[:V] N = state.flags[:N] Z = state.flags[:Z] C = state.flags[:C]

    return state
end

"""
Estimate energy consumption using probabilistic model
"""
function estimate_energy(instructions::Vector{Instruction})::Union{NamedTuple{(:mean, :std, :min, :max, :samples),Tuple{Float64,Float64,Float64,Float64,Vector{Float64}}},Nothing}
    @info "Energy Consumption Analysis"

    # Run probabilistic energy simulation
    n_samples = 1000
    energy_samples = Float64[]

    @info "Running energy simulations" n_samples

    for _ in 1:n_samples
        try
            trace = simulate(interpret_program, (instructions,))
            push!(energy_samples, get_retval(trace))
        catch e
            @warn "Energy simulation failed" error = e
            # Continue with other samples
        end
    end

    if isempty(energy_samples)
        @error "All energy simulations failed"
        return nothing
    end

    mean_energy = mean(energy_samples)
    std_energy = std(energy_samples)
    min_energy = minimum(energy_samples)
    max_energy = maximum(energy_samples)

    @info "Energy statistics" samples = length(energy_samples) mean = round(mean_energy, digits=3) std = round(std_energy, digits=3) min = round(min_energy, digits=3) max = round(max_energy, digits=3)

    # Show energy per instruction type
    instruction_counts = Dict{Symbol,Int}()
    for inst in instructions
        instruction_counts[inst.opcode] = get(instruction_counts, inst.opcode, 0) + 1
    end

    @info "Energy breakdown by instruction type"
    unique_opcodes = unique([inst.opcode for inst in instructions])
    for opcode in sort(unique_opcodes)
        count = instruction_counts[opcode]
        alpha, beta = get_energy_params(opcode)
        mean_inst_energy = alpha * beta
        total_inst_energy = mean_inst_energy * count
        percentage = (total_inst_energy / mean_energy) * 100
        @info "Instruction energy" opcode count mean_inst = round(mean_inst_energy, digits=2) total = round(total_inst_energy, digits=2) percentage = round(percentage, digits=1)
    end

    return (mean=mean_energy, std=std_energy, min=min_energy, max=max_energy, samples=energy_samples)
end

