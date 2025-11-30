using Test

include("../src/types.jl")
using .Types: MachineState, Instruction

include("../src/parser.jl")
using .Parser

include("../src/Interpreter.jl")
using .Interpreter

"""
Test that br_immediate benchmark executes the correct number of br instructions.

The benchmark should execute TEXTUAL_REPT * INNER_ITERS br instructions.
With default values (TEXTUAL_REPT=100, INNER_ITERS=100), this is 10,000 br instructions.
"""
function test_br_immediate_instruction_count()
    @testset "br_immediate benchmark instruction count" begin
        # Compile the br_immediate benchmark
        @info "Compiling br_immediate_benchmark.c..."
        run(`bash -c "source env.sh && make disasm FILE=scripts/hardcoded_benchmarks/br_immediate_benchmark.c"`)

        asm_file = "build/asm/br_immediate_benchmark.asm"
        data_file = "build/asm/br_immediate_benchmark.data"

        @test isfile(asm_file)
        @test isfile(data_file)

        # Parse assembly file
        instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)
        func_addrs = Parser.find_functions(asm_file)

        # Count br instructions in the parsed assembly
        br_count = count(inst -> inst.opcode == :br, instructions)
        @info "Total br instructions in assembly" br_count

        # Execute the program
        @info "Running interpreter..."
        final_state, event_sequences = Interpreter.interpret_program(
            instructions, addresses, func_addrs, 100000000; data_file=data_file
        )

        # Expected: TEXTUAL_REPT (100) br instructions per inner iteration
        # INNER_ITERS (100) iterations
        # Total: 100 * 100 = 10,000 br instructions should be executed
        TEXTUAL_REPT = 100
        INNER_ITERS = 100
        expected_br_executions = TEXTUAL_REPT * INNER_ITERS

        @info "Expected br executions" expected = expected_br_executions

        # Verify the benchmark has the expected structure
        # There should be TEXTUAL_REPT br instructions in the assembly
        if br_count != TEXTUAL_REPT
            @error "Expected $TEXTUAL_REPT br instructions in assembly, got $br_count"
        end
        @test br_count == TEXTUAL_REPT

        # Count how many times br was executed by checking event sequences
        total_br_executions = 0
        for sequence in event_sequences
            br_in_sequence = count(inst -> inst.opcode == :br, sequence)
            total_br_executions += br_in_sequence
        end

        @info "Actual br executions in events" total = total_br_executions

        # The benchmark should execute TEXTUAL_REPT * INNER_ITERS br instructions
        if total_br_executions != expected_br_executions
            @error "Expected $expected_br_executions br executions, got $total_br_executions"
        end
        @test total_br_executions == expected_br_executions

        @info "✓ br_immediate benchmark test passed!"
    end
end

# Run the test
test_br_immediate_instruction_count()
