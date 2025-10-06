# run.jl - Main entry point

push!(LOAD_PATH, "src")
using ARMEnergyModel
using Logging
include("examples/demo.jl")
include("examples/inference_demo.jl")

function main()
    @info "ARM Energy Model - Task 1.1 Implementation"
    @info "="^50

    # Interactive menu
    while true
        @info "\nOptions:"
        @info "1. Run demo"
        @info "2. Run inference demo"
        @info "3. Analyze custom program"
        @info "4. View instruction distributions"
        @info "5. Compare programs"
        @info "6. Exit"
        print("Choice: ")

        choice = readline()

        if choice == "1"
            demo()
        elseif choice == "2"
            demo_parameter_learning()
        elseif choice == "3"
            @info "Enter assembly instructions (empty line to finish):"
            lines = String[]
            while true
                line = readline()
                isempty(line) && break
                push!(lines, line)
            end
            program = parse_arm_assembly(lines)
            stats = analyze_energy_distribution(program, 1000)
            @info "Mean energy" value=stats.mean unit="mJ"
            p = plot_program_energy_distribution(program, 1000)
            display(p)
        elseif choice == "4"
            p = plot_instruction_energy_distributions(5000)
            display(p)
        elseif choice == "5"
            example_comparison()
        elseif choice == "6"
            break
        end
    end
end

# Run main if executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end