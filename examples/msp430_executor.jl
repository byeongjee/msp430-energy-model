# msp430_executor.jl - Parse objdump output and execute MSP430 instructions

using Pkg
Pkg.activate(".")

include("../src/MSP430EnergyModel.jl")
using .MSP430EnergyModel
using Statistics
using Gen

"""
Parse objdump output from a file containing assembly instructions
"""
function parse_instructions_file(filename::String)
    if !isfile(filename)
        error("Instructions file not found: $filename")
    end

    lines = readlines(filename)

    # Filter out empty lines and comments, clean hex prefixes
    cleaned_lines = String[]
    for line in lines
        line = strip(line)
        if !isempty(line) && !startswith(line, "#")
            # Clean up lines that start with hex bytes like "ff 3f jmp $+0"
            if occursin(r"^[0-9a-fA-F]{2} [0-9a-fA-F]{2}", line)
                # Extract just the instruction part after hex bytes
                parts = split(line, r"\s+", limit=3)
                if length(parts) >= 3
                    line = parts[3]
                end
            end
            push!(cleaned_lines, line)
        end
    end

    if isempty(cleaned_lines)
        error("No assembly instructions found in file: $filename")
    end

    println("Found $(length(cleaned_lines)) assembly instructions")

    # Parse using existing MSP430 parser
    try
        instructions = parse_msp430_assembly(cleaned_lines)
        println("✓ Successfully parsed $(length(instructions)) MSP430 instructions")
        return instructions
    catch e
        println("❌ Error parsing instructions: $e")
        println("Raw assembly lines:")
        for (i, line) in enumerate(cleaned_lines)
            println("  $i: $line")
        end
        rethrow(e)
    end
end

"""
Execute MSP430 program and show detailed results
"""
function execute_and_analyze(instructions::Vector{MSP430Instruction})
    println("\n" * "=" ^ 60)
    println("MSP430 Program Execution & Analysis")
    println("=" ^ 60)

    # Show the program
    println("\n📋 MSP430 Program ($(length(instructions)) instructions):")
    for (i, inst) in enumerate(instructions)
        size_str = inst.data_size == :byte ? ".b" : ""
        println("  $i: $(inst.opcode)$size_str $(inst.operands) [$(inst.addressing_mode)]")
    end

    # Create initial machine state
    state = MSP430MachineState()
    println("\n🔧 Initial machine state:")
    println("  PC: 0x$(string(state.pc, base=16, pad=4))")
    println("  SP: 0x$(string(state.sp, base=16, pad=4))")
    println("  R0-R5: $(state.registers[:R0]), $(state.registers[:R1]), $(state.registers[:R2]), $(state.registers[:R3]), $(state.registers[:R4]), $(state.registers[:R5])")

    # Execute instructions step by step
    println("\n⚡ Executing instructions:")
    execution_log = []

    for (i, inst) in enumerate(instructions)
        try
            old_pc = state.pc
            old_regs = copy(state.registers)

            execute_msp430_instruction!(state, inst)

            # Log execution details
            step_info = (
                step = i,
                instruction = inst,
                old_pc = old_pc,
                new_pc = state.pc,
                register_changes = Dict()
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

            println("  Step $i: $(inst.opcode) $(inst.operands)")
            println("    PC: 0x$(string(old_pc, base=16, pad=4)) → 0x$(string(state.pc, base=16, pad=4))")

            # Show memory operations
            if !isempty(memory_operation)
                println(memory_operation)
            end

            # Show register changes (excluding R0/PC since it always changes)
            if !isempty(step_info.register_changes)
                for (reg, (old_val, new_val)) in step_info.register_changes
                    if reg != :R0 && reg != :PC  # Skip PC since it changes every instruction
                        println("    $reg: $old_val → $new_val")
                    end
                end
            end

        catch e
            println("  ❌ Error executing instruction $i ($(inst.opcode)): $e")
            break
        end
    end

    # Show final state
    println("\n🏁 Final machine state:")
    println("  PC: 0x$(string(state.pc, base=16, pad=4))")
    println("  SP: 0x$(string(state.sp, base=16, pad=4))")
    println("  R0-R7: $(state.registers[:R0]), $(state.registers[:R1]), $(state.registers[:R2]), $(state.registers[:R3]), $(state.registers[:R4]), $(state.registers[:R5]), $(state.registers[:R6]), $(state.registers[:R7])")
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
    instruction_counts = Dict{Symbol, Int}()
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
        println("Usage: julia msp430_executor.jl <instructions_file>")
        println("Example: julia msp430_executor.jl build/asm/simple.instructions")
        exit(1)
    end

    instructions_file = ARGS[1]

    println("MSP430 Instruction Executor")
    println("=" ^ 40)
    println("Instructions file: $instructions_file")

    try
        # Parse instructions from file
        instructions = parse_instructions_file(instructions_file)

        # Execute and analyze
        final_state, execution_log = execute_and_analyze(instructions)

        # Estimate energy
        energy_stats = estimate_energy(instructions)

        # Summary
        println("\n" * "=" ^ 60)
        println("🎯 EXECUTION SUMMARY")
        println("=" ^ 60)
        println("✅ Successfully executed $(length(instructions)) MSP430 instructions")
        if energy_stats !== nothing
            println("📊 Estimated energy: $(round(energy_stats.mean, digits=3)) ± $(round(energy_stats.std, digits=3)) units")
        end
        println("🔧 Final PC: 0x$(string(final_state.pc, base=16, pad=4))")

        # Show final register values
        important_regs = [:R4, :R5, :R6, :R7]  # Commonly used for variables
        println("📋 Key registers:")
        for reg in important_regs
            if haskey(final_state.registers, reg)
                val = final_state.registers[reg]
                if val != 0
                    println("   $reg = $val (0x$(string(val, base=16, pad=4)))")
                end
            end
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