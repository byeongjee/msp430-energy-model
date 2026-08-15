# Test that stack operations (PUSH, POP, CALL, RET) generate SRAM memory events
# when should_track_memory_access=true

using .Types: MachineState, Instruction, SRAMRead, SRAMWrite

"""
Test that stack operations generate SRAM read/write events for energy modeling.

Stack operations (PUSH, POP, CALL, RET, RETI, PUSHM, POPM) should use read_memory/write_memory!
to generate memory access events when tracking is enabled.

Without this fix, stack operations bypass the event tracking system, resulting in
inaccurate energy estimates for programs with heavy stack usage.
"""
function run_stack_events_tests()
    @testset "Stack Event Tracking" begin
        @testset "Stack operations generate SRAM events" begin
            # Compile the stack events test program
            @info "Compiling stack events test program..."
            run(`uv run pem disasm --file test/fixtures/c_programs/stack_events.c`)

            asm_file = "build/asm/stack_events.asm"
            data_file = "build/asm/stack_events.data"

            @test isfile(asm_file)
            @test isfile(data_file)

            # Read and parse assembly file
            asm_content = read(asm_file, String)
            instructions, address_info, _base_address = Interpreter.parse_asm_string(
                asm_content
            )
            func_addrs = Parser.find_functions_from_string(asm_content)

            # Execute the program with memory access tracking
            @info "Running interpreter with memory access tracking..."
            final_state, event_traces = Interpreter.interpret_program(
                instructions,
                address_info,
                func_addrs,
                100000,
                Types.PerAddressingModeConstantWithMemAccess;
                data_file=data_file,
            )

            # Compute memory access counts for each event
            memory_regions = TraceMetrics.build_memory_regions()
            access_counts = TraceMetrics.compute_event_accesses(
                event_traces, memory_regions
            )

            # We expect 2 events:
            # Event 1: CALL/RET - should have SRAM write (CALL) and SRAM read (RET)
            # Event 2: PUSH/POP - should have 2 SRAM writes (PUSH) and 2 SRAM reads (POP)
            @test length(event_traces) >= 2
            @test length(access_counts) >= 2

            if length(access_counts) >= 2
                event1 = access_counts[1]  # CALL/RET
                event2 = access_counts[2]  # PUSH/POP

                @info "Event 1 (CALL/RET)" sram_read = event1[:sram_read] sram_write = event1[:sram_write]
                @info "Event 2 (PUSH/POP)" sram_read = event2[:sram_read] sram_write = event2[:sram_write]

                # Test 1: CALL/RET event should have at least 1 SRAM write (CALL) and 1 SRAM read (RET)
                @testset "CALL/RET generates SRAM events" begin
                    @test event1[:sram_write] >= 1  # CALL pushes return address
                    @test event1[:sram_read] >= 1   # RET pops return address
                end

                # Test 2: PUSH/POP event should have at least 2 SRAM writes and 2 SRAM reads
                @testset "PUSH/POP generates SRAM events" begin
                    @test event2[:sram_write] >= 2  # 2 PUSH instructions
                    @test event2[:sram_read] >= 2   # 2 POP instructions
                end

                # Test 3: Combined SRAM events should be > 0
                @testset "Stack operations tracked correctly" begin
                    total_sram = event1[:sram] + event2[:sram]
                    @test total_sram > 0
                    @info "Total SRAM events from stack operations" total = total_sram
                end
            end

            @info "Stack event tracking test completed"
        end
    end
end

# Export function for use in runtests.jl
export run_stack_events_tests
