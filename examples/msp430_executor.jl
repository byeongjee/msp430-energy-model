# msp430_executor.jl - Parse objdump output and execute MSP430 instructions

using Pkg
Pkg.activate(".")

include("../src/MSP430EnergyModel.jl")
using .MSP430EnergyModel
using Statistics
using Gen
using Logging

"""
Print all register values in a formatted way for MSP430
"""
function print_msp430_registers(state::MSP430MachineState)
    @debug "--- MSP430 Register State ---"

    # Print general registers R0-R15
    for i in 0:15
        reg_name = Symbol("R$i")
        value = get(state.registers, reg_name, UInt16(0))
        @debug "R$i" value_hex=string(value, base=16, pad=4) value_dec=value
    end

    # Print flags
    @debug "flags" flags=state.flags
    @debug "-----------------------------"
end

"""
Parse MSP430 assembly file and extract instructions with their addresses
"""
function parse_asm_file(filename::String)
    if !isfile(filename)
        error("Assembly file not found: $filename")
    end

    lines = readlines(filename)
    instructions = MSP430Instruction[]
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
            parsed_instr = MSP430EnergyModel.parse_msp430_line(String(instr_str), addr)
            if !isnothing(parsed_instr)
                push!(instructions, parsed_instr)
                push!(addresses, addr)
            end
        end
    end

    if isempty(instructions)
        error("No parseable instructions found in assembly file")
    end

    @info "Successfully parsed MSP430 instructions" count=length(instructions) base_address=string(base_address, base=16, pad=4)

    return instructions, addresses, base_address
end

"""
Execute MSP430 program and show detailed results with PC-based execution
"""
function execute_and_analyze(instructions::Vector{MSP430Instruction}, addresses::Vector{UInt16}, verbose::Bool=false)
    @info "="^60
    @info "MSP430 Program Execution & Analysis"
    @info "="^60

    # Show the program
    @info "MSP430 Program" instruction_count=length(instructions)
    for (i, inst) in enumerate(instructions)
        size_str = inst.data_size == :byte ? ".b" : ""
        @debug "Instruction $i" opcode="$(inst.opcode)$size_str" operands=inst.operands addressing_mode=inst.addressing_mode
    end

    # Create PC to instruction mapping
    pc_to_instruction = Dict{UInt16,Tuple{Int,MSP430Instruction}}()
    for (i, (addr, inst)) in enumerate(zip(addresses, instructions))
        pc_to_instruction[addr] = (i, inst)
    end

    # Create initial machine state and set PC to first instruction address
    state = MSP430MachineState()
    state.pc = addresses[1]  # Start at the first instruction address
    state.registers[:R0] = state.pc
    state.registers[:PC] = state.pc

    if verbose
        @info "Initial machine state" pc=string(state.pc, base=16, pad=4) sp=string(state.sp, base=16, pad=4) r0=state.registers[:R0] r1=state.registers[:R1] r2=state.registers[:R2] r3=state.registers[:R3] r4=state.registers[:R4] r5=state.registers[:R5]

        # Execute instructions using PC-based execution
        @info "Executing instructions (PC-based execution)"
    end
    execution_log = []
    step_count = 0
    max_steps = 1000  # Prevent infinite loops

    while step_count < max_steps
        step_count += 1

        # Get instruction at current PC
        if !haskey(pc_to_instruction, state.pc)
            @info "Execution finished" pc=string(state.pc, base=16, pad=4) reason="PC not in program"
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

            # Use the new centralized PC management function
            execute_msp430_instruction!(state, inst, addresses, current_addr_idx)

            # Log execution details
            step_info = (
                step=step_count,
                instruction_index=instruction_index,
                address=old_pc,
                instruction=inst,
                old_pc=old_pc,
                new_pc=state.pc,
                register_changes=Dict()
            )

            # Track register changes
            for (reg, new_val) in state.registers
                old_val = get(old_regs, reg, UInt16(0))
                if new_val != old_val
                    step_info.register_changes[reg] = (old_val, new_val)
                end
            end

            # Track memory operations
            memory_operation = ""
            if length(inst.operands) >= 2
                # Check for memory writes (indexed addressing destination)
                if isa(inst.operands[2], Tuple)
                    offset, reg = inst.operands[2]
                    base_addr = get(old_regs, reg, UInt16(0))
                    addr = UInt16((base_addr + offset) & 0xFFFF)
                    if inst.opcode == :mov
                        src_val = MSP430EnergyModel.get_operand_value(state, inst.operands[1])
                        memory_operation = "    Memory[0x$(string(addr, base=16, pad=4))] = $src_val"
                    end
                    # Check for memory reads (indirect addressing source)
                elseif isa(inst.operands[1], Symbol) && string(inst.operands[1])[1] == '@'
                    reg_name = Symbol(string(inst.operands[1])[2:end])
                    addr = get(old_regs, reg_name, UInt16(0))
                    val = get(state.memory, addr, UInt16(0))
                    memory_operation = "    Memory[0x$(string(addr, base=16, pad=4))] → $val"
                end
            end

            push!(execution_log, step_info)

            if verbose
                @debug "Step $step_count" address=string(old_pc, base=16, pad=4) opcode=inst.opcode operands=inst.operands
                @debug "PC transition" old_pc=string(old_pc, base=16, pad=4) new_pc=string(state.pc, base=16, pad=4)

                # Show memory operations
                if !isempty(memory_operation)
                    @debug memory_operation
                end

                # Print all register values after each step
                print_msp430_registers(state)
            end

            # Check for jmp $+0 (program termination) or other infinite loops
            if inst.opcode == :jmp
                if length(inst.operands) > 0 && inst.operands[1] == -1  # jmp $+0 has offset -1
                    @info "Program termination: jmp \$+0 instruction executed"
                    break
                end
            end

        catch e
            @error "Error executing instruction" pc=string(state.pc, base=16, pad=4) opcode=inst.opcode error=e
            break
        end
    end

    if step_count >= max_steps
        @warn "Execution stopped: Maximum steps reached" max_steps
    end

    # Show final state
    @info "Final machine state" pc=string(state.pc, base=16, pad=4)
    print_msp430_registers(state)
    @info "Flags" V=state.flags[:V] N=state.flags[:N] Z=state.flags[:Z] C=state.flags[:C]

    return state, execution_log
end

"""
Estimate energy consumption using probabilistic model
"""
function estimate_energy(instructions::Vector{MSP430Instruction})
    @info "Energy Consumption Analysis"

    # Run probabilistic energy simulation
    n_samples = 1000
    energy_samples = Float64[]

    @info "Running energy simulations" n_samples

    for _ in 1:n_samples
        try
            trace = simulate(interpret_msp430_program, (instructions,))
            push!(energy_samples, get_retval(trace))
        catch e
            @warn "Energy simulation failed" error=e
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

    @info "Energy statistics" samples=length(energy_samples) mean=round(mean_energy, digits=3) std=round(std_energy, digits=3) min=round(min_energy, digits=3) max=round(max_energy, digits=3)

    # Show energy per instruction type
    instruction_counts = Dict{Symbol,Int}()
    for inst in instructions
        instruction_counts[inst.opcode] = get(instruction_counts, inst.opcode, 0) + 1
    end

    @info "Energy breakdown by instruction type"
    unique_opcodes = unique([inst.opcode for inst in instructions])
    for opcode in sort(unique_opcodes)
        count = instruction_counts[opcode]
        alpha, beta = get_msp430_energy_params(opcode)
        mean_inst_energy = alpha * beta
        total_inst_energy = mean_inst_energy * count
        percentage = (total_inst_energy / mean_energy) * 100
        @info "Instruction energy" opcode count mean_inst=round(mean_inst_energy, digits=2) total=round(total_inst_energy, digits=2) percentage=round(percentage, digits=1)
    end

    return (mean=mean_energy, std=std_energy, min=min_energy, max=max_energy, samples=energy_samples)
end

"""
Main function
"""
function main()
    if length(ARGS) < 1
        @info "Usage: julia msp430_executor.jl <assembly_file> [--verbose|-v]"
        @info "Example: julia msp430_executor.jl build/asm/simple.asm"
        @info "Options:"
        @info "  --verbose, -v    Show detailed execution log"
        exit(1)
    end

    asm_file = ARGS[1]
    verbose = length(ARGS) >= 2 && (ARGS[2] == "--verbose" || ARGS[2] == "-v")

    # Set logging level based on verbose flag
    if verbose
        global_logger(ConsoleLogger(stderr, Logging.Debug))
    else
        global_logger(ConsoleLogger(stderr, Logging.Info))
    end

    @info "MSP430 Instruction Executor"
    @info "="^40
    @info "Assembly file" path=asm_file

    try
        # Parse instructions from assembly file
        instructions, addresses, base_address = parse_asm_file(asm_file)

        # Execute and analyze
        final_state, execution_log = execute_and_analyze(instructions, addresses, verbose)

        # Estimate energy
        # energy_stats = estimate_energy(instructions)

        # Summary
        @info "="^60
        @info "EXECUTION SUMMARY"
        @info "="^60
        @info "Successfully executed MSP430 instructions" count=length(instructions)
        # if energy_stats !== nothing
        #     @info "Estimated energy" mean=round(energy_stats.mean, digits=3) std=round(energy_stats.std, digits=3)
        # end

    catch e
        @error "Execution failed" error=e
        exit(1)
    end
end

# Run main function if called directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end