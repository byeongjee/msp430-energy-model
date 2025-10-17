using Test

# Include test files
include("test_interpreter.jl")

@testset "MSP430 Interpreter Test Suite" begin
    println("="^60)
    println("Running MSP430 Interpreter Tests")
    println("="^60)
    println()

    # Run all fixture-based tests
    run_all_fixtures()

    println()
    println("="^60)
    println("Test Suite Complete")
    println("="^60)
end
