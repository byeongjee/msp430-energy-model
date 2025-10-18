using Test

# Include test files
include("test_interpreter.jl")

# Parse command-line arguments for test filtering
filter_pattern = nothing
if length(ARGS) > 0
    filter_pattern = Regex(ARGS[1])
    println("Filtering tests with pattern: $(ARGS[1])")
    println()
end

@testset "MSP430 Interpreter Test Suite" begin
    println("="^60)
    println("Running MSP430 Interpreter Tests")
    println("="^60)
    println()

    # Run all fixture-based tests (with optional filtering)
    run_all_fixtures(filter_pattern)

    println()
    println("="^60)
    println("Test Suite Complete")
    println("="^60)
end
