# Modules are loaded in runtests.jl
# Import specific types we need
using .Types: MachineState, Instruction, Inst, FRAMReadHit, FRAMReadMiss

"""
Test that SRAM code execution produces no FRAM cache events for instruction fetches,
while FRAM code execution does produce cache events.

This verifies the .text_sram section feature that allows isolating FRAM data access
costs from instruction fetch costs during energy benchmarking.
"""
function run_sram_code_tests()
    @testset "SRAM Code Execution" begin
        @testset "SRAM code execution isolation" begin
            # Compile the SRAM code benchmark
            @info "Compiling SRAM code benchmark..."
            run(`make disasm FILE=examples/misc/sram_code_benchmark.c`)

            asm_file = "build/asm/sram_code_benchmark.asm"
            data_file = "build/asm/sram_code_benchmark.data"

            @test isfile(asm_file)
            @test isfile(data_file)

            # Read and parse assembly file
            asm_content = read(asm_file, String)
            instructions, address_info, _base_address = Interpreter.parse_asm_string(asm_content)
            func_addrs = Parser.find_functions_from_string(asm_content)

            # Verify that SRAM code functions exist at SRAM addresses (0x1C00-0x3BFF)
            # Note: func_addrs uses string keys
            sram_code_fram_read_addr = get(func_addrs, "sram_code_fram_read", nothing)
            sram_code_nops_addr = get(func_addrs, "sram_code_nops", nothing)

            @test !isnothing(sram_code_fram_read_addr)
            @test !isnothing(sram_code_nops_addr)

            if !isnothing(sram_code_fram_read_addr)
                @test 0x1C00 <= sram_code_fram_read_addr <= 0x3BFF
                @info "sram_code_fram_read address" addr = string(sram_code_fram_read_addr; base=16)
            end

            if !isnothing(sram_code_nops_addr)
                @test 0x1C00 <= sram_code_nops_addr <= 0x3BFF
                @info "sram_code_nops address" addr = string(sram_code_nops_addr; base=16)
            end

            # Execute the program with memory access tracking
            @info "Running interpreter with memory access tracking..."
            final_state, event_traces = Interpreter.interpret_program(
                instructions,
                address_info,
                func_addrs,
                10000,
                Types.PerAddressingModeConstantWithMemAccess;
                data_file=data_file,
            )

            # Compute memory access counts for each event
            memory_regions = TraceMetrics.build_memory_regions()
            access_counts = TraceMetrics.compute_event_accesses(event_traces, memory_regions)

            # We expect 4 events:
            # Event 1: sram_code_fram_read - SRAM code reading FRAM data (only data events)
            # Event 2: fram_code_fram_read - FRAM code reading FRAM data (data + instruction events)
            # Event 3: sram_code_nops - SRAM code NOPs (zero FRAM events)
            # Event 4: fram_code_nops - FRAM code NOPs (instruction fetch events only)
            @test length(event_traces) == 4
            @test length(access_counts) == 4

            if length(access_counts) >= 4
                event1 = access_counts[1]  # sram_code_fram_read
                event2 = access_counts[2]  # fram_code_fram_read
                event3 = access_counts[3]  # sram_code_nops
                event4 = access_counts[4]  # fram_code_nops

                @info "Event 1 (sram_code_fram_read)" fram_events = event1[:fram]
                @info "Event 2 (fram_code_fram_read)" fram_events = event2[:fram]
                @info "Event 3 (sram_code_nops)" fram_events = event3[:fram]
                @info "Event 4 (fram_code_nops)" fram_events = event4[:fram]

                # Test 1: sram_code_nops should produce ZERO FRAM events
                # This is the key test - SRAM code execution should not generate any
                # instruction fetch cache events
                @testset "SRAM NOPs produce zero FRAM events" begin
                    @test event3[:fram] == 0
                    @test event3[:fram_read_hit] == 0
                    @test event3[:fram_read_miss] == 0
                end

                # Test 2: fram_code_nops should produce > 0 FRAM events
                # FRAM code execution generates instruction fetch cache events
                @testset "FRAM NOPs produce FRAM events" begin
                    @test event4[:fram] > 0
                    @test event4[:fram_read_hit] + event4[:fram_read_miss] > 0
                end

                # Test 3: sram_code_fram_read should produce fewer FRAM events than fram_code_fram_read
                # Both read the same FRAM data, but fram_code_fram_read also has instruction fetch events
                @testset "SRAM code has fewer FRAM events than FRAM code" begin
                    @test event1[:fram] < event2[:fram]
                    # The difference should be significant (instruction fetch overhead)
                    @test event2[:fram] - event1[:fram] > 100
                end

                # Test 4: sram_code_fram_read should have ~100 FRAM data reads
                # (FRAM_READ_ITERS = 100 by default)
                @testset "SRAM code FRAM reads match expected count" begin
                    # Allow some tolerance for loop overhead accessing FRAM
                    @test 90 <= event1[:fram] <= 150
                end
            end

            @info "SRAM code execution isolation test passed"
        end
    end
end

# Export function for use in runtests.jl
export run_sram_code_tests
