# Modules are loaded in runtests.jl
# Import specific types we need
using .Types: MachineState, Instruction, Inst, get_inst

"""
Test that br_immediate benchmark executes the correct number of br instructions.

The benchmark should execute TEXTUAL_REPT * INNER_ITERS br instructions.
With current defaults (TEXTUAL_REPT=100, INNER_ITERS=10), this is 1,000 br instructions.
"""
function run_br_immediate_tests()
    @testset "BR Immediate Benchmark" begin
        @testset "br_immediate instruction count" begin
            # Generate br_immediate_benchmark.S via the branch benchmark helper
            @info "Generating br_immediate_benchmark.S..."
            run(
                `bash -c "./scripts/compile_br_immediate_benchmark.sh --file scripts/hardcoded_benchmarks/br_immediate_benchmark.c"`,
            )

            # Now compile and disassemble the .S file
            @info "Compiling and disassembling .S file..."
            run(`bash -c "make disasm FILE=build/asm/br_immediate_benchmark.S"`)

            asm_file = "build/asm/br_immediate_benchmark.asm"
            data_file = "build/asm/br_immediate_benchmark.data"

            @test isfile(asm_file)
            @test isfile(data_file)

            # Read and parse assembly file
            asm_content = read(asm_file, String)
            instructions, address_info, _base_address = Interpreter.parse_asm_string(asm_content)
            func_addrs = Parser.find_functions_from_string(asm_content)

            # Count br instructions in the parsed assembly
            br_count = count(inst -> inst.opcode == :br, instructions)
            @info "Total br instructions in assembly" br_count

            # Execute the program (use finest granularity for tests)
            @info "Running interpreter..."
            final_state, event_traces = Interpreter.interpret_program(
                instructions,
                address_info,
                func_addrs,
                100000000,
                Types.PerAddressingModeConstant;
                data_file=data_file,
            )

            # Expected: TEXTUAL_REPT (100) br instructions per inner iteration
            # INNER_ITERS (10) iterations
            # Total: 100 * 10 = 1,000 br instructions should be executed
            TEXTUAL_REPT = 100
            INNER_ITERS = 10
            expected_br_executions = TEXTUAL_REPT * INNER_ITERS

            @info "Expected br executions" expected = expected_br_executions

            # Verify the benchmark has the expected structure
            # There should be TEXTUAL_REPT br instructions in the assembly
            if br_count != TEXTUAL_REPT
                @error "Expected $TEXTUAL_REPT br instructions in assembly, got $br_count"
            end
            @test br_count == TEXTUAL_REPT

            # Count how many times br was executed by checking event traces
            total_br_executions = 0
            for trace in event_traces
                br_in_trace = count(event -> get_inst(event).opcode == :br, trace)
                total_br_executions += br_in_trace
            end

            @info "Actual br executions in events" total = total_br_executions

            # The benchmark should execute TEXTUAL_REPT * INNER_ITERS br instructions
            if total_br_executions != expected_br_executions
                @error "Expected $expected_br_executions br executions, got $total_br_executions"
            end
            @test total_br_executions == expected_br_executions

            @info "BR immediate benchmark test passed"
        end

        @testset "br_indexed instruction count" begin
            @info "Generating br_indexed_benchmark.S..."
            run(
                `bash -c "./scripts/compile_br_immediate_benchmark.sh --file scripts/hardcoded_benchmarks/br_indexed_benchmark.c"`,
            )

            @info "Compiling and disassembling .S file..."
            run(`bash -c "make disasm FILE=build/asm/br_indexed_benchmark.S"`)

            asm_file = "build/asm/br_indexed_benchmark.asm"
            data_file = "build/asm/br_indexed_benchmark.data"

            @test isfile(asm_file)
            @test isfile(data_file)

            asm_content = read(asm_file, String)
            instructions, address_info, _base_address = Interpreter.parse_asm_string(asm_content)
            func_addrs = Parser.find_functions_from_string(asm_content)

            br_count = count(inst -> inst.opcode == :br, instructions)
            @info "Total br instructions in assembly" br_count

            final_state, event_traces = Interpreter.interpret_program(
                instructions,
                address_info,
                func_addrs,
                100000000,
                Types.PerAddressingModeConstant;
                data_file=data_file,
            )

            TEXTUAL_REPT = 100
            INNER_ITERS = 10
            expected_br_executions = TEXTUAL_REPT * INNER_ITERS

            @test br_count == TEXTUAL_REPT

            total_br_executions = 0
            for trace in event_traces
                br_in_trace = count(event -> get_inst(event).opcode == :br, trace)
                total_br_executions += br_in_trace
            end

            @test total_br_executions == expected_br_executions
            @info "BR indexed benchmark test passed"
        end
    end
end

# Export function for use in runtests.jl
export run_br_immediate_tests
