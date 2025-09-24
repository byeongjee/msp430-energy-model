# msp430_executor.jl - Parse objdump output and execute MSP430 instructions

using Pkg
Pkg.activate(".")

include("../src/MSP430EnergyModel.jl")
using .MSP430EnergyModel
using Statistics
using Gen

"""
Print all register values in a formatted way for MSP430
"""
function print_msp430_registers(state::MSP430MachineState)
    println("    --- MSP430 Register State ---")

    # Print general registers R0-R15
    for i in 0:15
        reg_name = Symbol("R$i")
        value = get(state.registers, reg_name, UInt16(0))
        println("    R$i: 0x$(string(value, base=16, pad=4)) ($value)")
    end

    # Print flags
    print("    flags: ")
    for (flag, value) in state.flags
        print("$flag=$value ")
    end
    println()
    println("    -----------------------------")
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

    println("Parsing assembly file: $filename")

    for line in lines
        line = strip(line)

        # Skip empty lines and headers
        if isempty(line) || occursin("Disassembly", line) || occursin("file format", line)
            continue
        end

        # Parse instruction lines like "4002:	31 40 00 2c 	mov	#11264,	r1	;#0x2c00"
        # Format: ADDRESS: HEX_BYTES INSTRUCTION
        match_result = match(r"^\s*([0-9a-fA-F]{4}):\s+([0-9a-fA-F\s]+)\s+([a-zA-Z][^;]*)", line)

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

            try
                # Parse the instruction string with current address for relative jump resolution
                parsed_instr = MSP430EnergyModel.parse_msp430_line(String(instr_str), addr)
                if !isnothing(parsed_instr)
                    push!(instructions, parsed_instr)
                    push!(addresses, addr)
                end
            catch e
                println("  Warning: Could not parse instruction at 0x$(addr_str): $instr_str")
                println("  Error: $e")
                continue
            end
        end
    end

    if isempty(instructions)
        error("No parseable instructions found in assembly file")
    end

    println("✓ Successfully parsed $(length(instructions)) MSP430 instructions")
    println("✓ Base address: 0x$(string(base_address, base=16, pad=4))")

    return instructions, addresses, base_address
end

"""
Execute MSP430 program and show detailed results with PC-based execution
"""
function execute_and_analyze(instructions::Vector{MSP430Instruction}, addresses::Vector{UInt16})
    println("\n" * "="^60)
    println("MSP430 Program Execution & Analysis")
    println("="^60)

    # Show the program
    println("\n📋 MSP430 Program ($(length(instructions)) instructions):")
    for (i, inst) in enumerate(instructions)
        size_str = inst.data_size == :byte ? ".b" : ""
        println("  $i: $(inst.opcode)$size_str $(inst.operands) [$(inst.addressing_mode)]")
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

    println("\n🔧 Initial machine state:")
    println("  PC: 0x$(string(state.pc, base=16, pad=4)) (first instruction)")
    println("  SP: 0x$(string(state.sp, base=16, pad=4))")
    println("  R0-R5: $(state.registers[:R0]), $(state.registers[:R1]), $(state.registers[:R2]), $(state.registers[:R3]), $(state.registers[:R4]), $(state.registers[:R5])")

    # Execute instructions using PC-based execution
    println("\n⚡ Executing instructions (PC-based execution):")
    execution_log = []
    step_count = 0
    max_steps = 1000  # Prevent infinite loops

    while step_count < max_steps
        step_count += 1

        # Get instruction at current PC
        if !haskey(pc_to_instruction, state.pc)
            println("  🏁 Execution finished: PC 0x$(string(state.pc, base=16, pad=4)) not in program")
            break
        end

        instruction_index, inst = pc_to_instruction[state.pc]
        try
            old_pc = state.pc
            old_regs = copy(state.registers)

            # Handle call instruction return address setup
            if inst.opcode == :call
                # Find next instruction address for return address
                current_addr_idx = findfirst(addr -> addr == old_pc, addresses)
                if current_addr_idx !== nothing && current_addr_idx < length(addresses)
                    next_addr = addresses[current_addr_idx+1]
                    # MSP430 call instruction: push return address to stack, then jump
                    # SP decrements by 2 because MSP430 stack grows downward and each entry is 16-bit (2 bytes)
                    state.sp -= 2
                    state.registers[:R1] = state.sp
                    state.registers[:SP] = state.sp
                    state.memory[state.sp] = next_addr  # Store return address on stack
                    # Execute the call (will set PC to target)
                    if length(inst.operands) > 0
                        target_addr = inst.operands[1]
                        state.pc = target_addr
                        state.registers[:R0] = state.pc
                        state.registers[:PC] = state.pc
                    end
                else
                    execute_msp430_instruction!(state, inst)
                end
            else
                execute_msp430_instruction!(state, inst)
            end

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

            println("  Step $step_count @ 0x$(string(old_pc, base=16, pad=4)): $(inst.opcode) $(inst.operands)")
            println("    PC: 0x$(string(old_pc, base=16, pad=4)) → 0x$(string(state.pc, base=16, pad=4))")

            # Show memory operations
            if !isempty(memory_operation)
                println(memory_operation)
            end

            # Print all register values after each step
            print_msp430_registers(state)

            # Handle PC updates for non-control-flow instructions
            if inst.opcode != :jmp && inst.opcode != :call && inst.opcode != :ret && inst.opcode != :reti && !startswith(string(inst.opcode), "j")
                # Find next instruction address
                current_addr_idx = findfirst(addr -> addr == old_pc, addresses)
                if current_addr_idx !== nothing && current_addr_idx < length(addresses)
                    next_addr = addresses[current_addr_idx+1]
                    state.pc = next_addr
                    state.registers[:R0] = state.pc
                    state.registers[:PC] = state.pc
                end
            end

            # Check for jmp $+0 (program termination) or other infinite loops
            if inst.opcode == :jmp
                if length(inst.operands) > 0 && inst.operands[1] == -1  # jmp $+0 has offset -1
                    println("  🏁 Program termination: jmp \$+0 instruction executed")
                    break
                end
            end

        catch e
            println("  ❌ Error executing instruction at PC 0x$(string(state.pc, base=16, pad=4)) ($(inst.opcode)): $e")
            break
        end
    end

    if step_count >= max_steps
        println("  ⚠️  Execution stopped: Maximum steps ($max_steps) reached")
    end

    # Show final state
    println("\n🏁 Final machine state:")
    println("  PC: 0x$(string(state.pc, base=16, pad=4))")
    print_msp430_registers(state)
    println("  Flags: V=$(state.flags[:V]), N=$(state.flags[:N]), Z=$(state.flags[:Z]), C=$(state.flags[:C])")

    return state, execution_log
end

"""
Estimate energy consumption using probabilistic model
"""
function estimate_energy(instructions::Vector{MSP430Instruction})
    println("\n⚡ Energy Consumption Analysis:")

    # Run probabilistic energy simulation
    n_samples = 1000
    energy_samples = Float64[]

    println("  Running $n_samples energy simulations...")

    for _ in 1:n_samples
        try
            trace = simulate(interpret_msp430_program, (instructions,))
            push!(energy_samples, get_retval(trace))
        catch e
            println("  Warning: Energy simulation failed: $e")
            # Continue with other samples
        end
    end

    if isempty(energy_samples)
        println("  ❌ All energy simulations failed")
        return nothing
    end

    mean_energy = mean(energy_samples)
    std_energy = std(energy_samples)
    min_energy = minimum(energy_samples)
    max_energy = maximum(energy_samples)

    println("  📊 Energy statistics ($(length(energy_samples)) samples):")
    println("    Mean: $(round(mean_energy, digits=3)) energy units")
    println("    Std:  $(round(std_energy, digits=3)) energy units")
    println("    Min:  $(round(min_energy, digits=3)) energy units")
    println("    Max:  $(round(max_energy, digits=3)) energy units")

    # Show energy per instruction type
    instruction_counts = Dict{Symbol,Int}()
    for inst in instructions
        instruction_counts[inst.opcode] = get(instruction_counts, inst.opcode, 0) + 1
    end

    println("  📈 Energy breakdown by instruction type:")
    unique_opcodes = unique([inst.opcode for inst in instructions])
    for opcode in sort(unique_opcodes)
        count = instruction_counts[opcode]
        alpha, beta = get_msp430_energy_params(opcode)
        mean_inst_energy = alpha * beta
        total_inst_energy = mean_inst_energy * count
        percentage = (total_inst_energy / mean_energy) * 100
        println("    $opcode: $(count)x @ $(round(mean_inst_energy, digits=2)) = $(round(total_inst_energy, digits=2)) ($(round(percentage, digits=1))%)")
    end

    return (mean=mean_energy, std=std_energy, min=min_energy, max=max_energy, samples=energy_samples)
end

"""
Main function
"""
function main()
    if length(ARGS) < 1
        println("Usage: julia msp430_executor.jl <assembly_file>")
        println("Example: julia msp430_executor.jl build/asm/simple.asm")
        exit(1)
    end

    asm_file = ARGS[1]

    println("MSP430 Instruction Executor")
    println("="^40)
    println("Assembly file: $asm_file")

    try
        # Parse instructions from assembly file
        instructions, addresses, base_address = parse_asm_file(asm_file)

        # Execute and analyze
        final_state, execution_log = execute_and_analyze(instructions, addresses)

        # Estimate energy
        energy_stats = estimate_energy(instructions)

        # Summary
        println("\n" * "="^60)
        println("🎯 EXECUTION SUMMARY")
        println("="^60)
        println("✅ Successfully executed $(length(instructions)) MSP430 instructions")
        if energy_stats !== nothing
            println("📊 Estimated energy: $(round(energy_stats.mean, digits=3)) ± $(round(energy_stats.std, digits=3)) units")
        end

    catch e
        println("❌ Execution failed: $e")
        exit(1)
    end
end

# Run main function if called directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end