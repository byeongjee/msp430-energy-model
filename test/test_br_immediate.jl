# Modules are loaded in runtests.jl
# Import specific types we need
using .Types: MachineState, Instruction, Inst, get_inst

"""
Test that br_immediate benchmark executes the correct number of br instructions.

The benchmark executes TEXTUAL_REPT * INNER_ITERS br instructions. Both counts are
passed to the benchmark generator below instead of relying on the defaults in
include/setup.h, which are retuned for measurement stability and would otherwise
silently invalidate the expected values here.
"""
const BR_TEXTUAL_REPT = 100
const BR_INNER_ITERS = 10
const BR_DEFINES = "TEXTUAL_REPT=$(BR_TEXTUAL_REPT) INNER_ITERS=$(BR_INNER_ITERS)"

"""
Count the br instructions inside the function starting at `func_name`.

Counting them over the whole disassembly is not stable: the indexed benchmark's
jump table sits in .text, so objdump decodes it as instructions, and every table
entry pointing at an address whose low nibble is 0 decodes as a br (destination
register 0 is the PC). Which entries those are shifts with the code layout of
everything preceding the table.
"""
function count_br_in_function(
    instructions::Vector{Instruction},
    address_info::Vector{Tuple{UInt32,UInt32}},
    func_addrs::Dict{String,UInt32},
    func_name::String,
)
    start_addr = func_addrs[func_name]
    later_addrs = filter(>(start_addr), collect(values(func_addrs)))
    stop_addr = isempty(later_addrs) ? typemax(UInt32) : minimum(later_addrs)

    return count(eachindex(instructions)) do i
        instructions[i].opcode == :br && start_addr <= address_info[i][1] < stop_addr
    end
end

function run_br_immediate_tests()
    @testset "BR Immediate Benchmark" begin
        @testset "br_immediate instruction count" begin
            # Generate br_immediate_benchmark.S via the branch benchmark helper
            @info "Generating br_immediate_benchmark.S..."
            run(
                `uv run pem compile-branch-benchmark --file scripts/benchmarks/hardcoded/br_immediate_benchmark.c --defines $BR_DEFINES`,
            )

            # Now compile and disassemble the .S file
            @info "Compiling and disassembling .S file..."
            run(`uv run pem disasm --file build/asm/br_immediate_benchmark.S`)

            asm_file = "build/asm/br_immediate_benchmark.asm"
            data_file = "build/asm/br_immediate_benchmark.data"

            @test isfile(asm_file)
            @test isfile(data_file)

            # Read and parse assembly file
            asm_content = read(asm_file, String)
            instructions, address_info, _base_address = Interpreter.parse_asm_string(
                asm_content
            )
            func_addrs = Parser.find_functions_from_string(asm_content)

            # Count br instructions in the parsed assembly
            br_count = count_br_in_function(
                instructions, address_info, func_addrs, "bench_br_immediate_loop_header"
            )
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

            expected_br_executions = BR_TEXTUAL_REPT * BR_INNER_ITERS

            @info "Expected br executions" expected = expected_br_executions

            # Verify the benchmark has the expected structure
            # There should be TEXTUAL_REPT br instructions in the assembly
            if br_count != BR_TEXTUAL_REPT
                @error "Expected $BR_TEXTUAL_REPT br instructions in assembly, got $br_count"
            end
            @test br_count == BR_TEXTUAL_REPT

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
                `uv run pem compile-branch-benchmark --file scripts/benchmarks/hardcoded/br_indexed_benchmark.c --defines $BR_DEFINES`,
            )

            @info "Compiling and disassembling .S file..."
            run(`uv run pem disasm --file build/asm/br_indexed_benchmark.S`)

            asm_file = "build/asm/br_indexed_benchmark.asm"
            data_file = "build/asm/br_indexed_benchmark.data"

            @test isfile(asm_file)
            @test isfile(data_file)

            asm_content = read(asm_file, String)
            instructions, address_info, _base_address = Interpreter.parse_asm_string(
                asm_content
            )
            func_addrs = Parser.find_functions_from_string(asm_content)

            br_count = count_br_in_function(
                instructions, address_info, func_addrs, "bench_br_indexed_loop_header"
            )
            @info "Total br instructions in assembly" br_count

            final_state, event_traces = Interpreter.interpret_program(
                instructions,
                address_info,
                func_addrs,
                100000000,
                Types.PerAddressingModeConstant;
                data_file=data_file,
            )

            expected_br_executions = BR_TEXTUAL_REPT * BR_INNER_ITERS

            @test br_count == BR_TEXTUAL_REPT

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
