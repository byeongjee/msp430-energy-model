# Test that special function calls (e.g., __mspabi_divu) are treated as
# single composite instructions with function-specific keys.

using .Types: ExecutionEvent, Inst, PerAddressingMode, PerAddressingModeConstant, PerOpcode
using .Model: parse_key_string

"""
Test special function call key generation and serialization round-trip.
"""
function run_special_function_call_tests()
    @testset "Special Function Call Keys" begin
        @testset "parse_key_string round-trips special function keys" begin
            @test parse_key_string("call___mspabi_divu") == (:call, :__mspabi_divu)
            @test parse_key_string("call___mspabi_mpyi") == (:call, :__mspabi_mpyi)
            @test parse_key_string("call___mspabi_mpyl") == (:call, :__mspabi_mpyl)
            @test parse_key_string("calla___mspabi_divu") == (:calla, :__mspabi_divu)
        end

        @testset "parse_key_string still works for normal keys" begin
            @test parse_key_string("call_immediate") == (:call, :immediate)
            @test parse_key_string("mov_immediate_register") == (:mov, :immediate, :register)
            @test parse_key_string("ret") == (:ret,)
            @test parse_key_string("nop") == (:nop,)
            @test parse_key_string("rlam_immediate_2") == (:rlam, :immediate, 2)
        end

        @testset "Key serialization produces correct string" begin
            key = (:call, :__mspabi_divu)
            key_str = join(string.(key), "_")
            @test key_str == "call___mspabi_divu"
        end

        @testset "Interpreter handles special function calls" begin
            # Compile the test program
            @info "Compiling special function calls test program..."
            run(`make disasm FILE=test/fixtures/c_programs/special_function_calls.c`)

            asm_file = "build/asm/special_function_calls.asm"
            data_file = "build/asm/special_function_calls.data"

            @test isfile(asm_file)
            @test isfile(data_file)

            # Read and parse assembly file
            asm_content = read(asm_file, String)
            instructions, address_info, _base_address = Interpreter.parse_asm_string(asm_content)
            func_addrs = Parser.find_functions_from_string(asm_content)

            # Verify the special functions exist in the disassembly
            has_divu = haskey(func_addrs, "__mspabi_divu")
            has_mpyi = haskey(func_addrs, "__mspabi_mpyi")
            if !has_divu
                @warn "No __mspabi_divu in disassembly — compiler may have optimized it away"
            end
            if !has_mpyi
                @warn "No __mspabi_mpyi in disassembly — compiler may have optimized it away"
            end

            @testset "PerAddressingMode granularity" begin
                final_state, event_traces = Interpreter.interpret_program(
                    instructions, address_info, func_addrs, 100000,
                    PerAddressingMode; data_file=data_file,
                )

                @test length(event_traces) >= 1

                if length(event_traces) >= 1 && has_divu
                    event1 = event_traces[1]
                    inst_events = filter(evt -> evt.type == Inst, event1)
                    inst_keys = [evt.key for evt in inst_events]

                    @test (:call, :__mspabi_divu) in inst_keys
                    # Generic call_immediate should NOT appear for this call
                    @test !any(k -> k == (:call, :immediate), inst_keys)
                end

                if length(event_traces) >= 2 && has_mpyi
                    event2 = event_traces[2]
                    inst_events = filter(evt -> evt.type == Inst, event2)
                    inst_keys = [evt.key for evt in inst_events]

                    @test (:call, :__mspabi_mpyi) in inst_keys
                end
            end

            @testset "PerAddressingModeConstant granularity" begin
                final_state, event_traces = Interpreter.interpret_program(
                    instructions, address_info, func_addrs, 100000,
                    PerAddressingModeConstant; data_file=data_file,
                )

                @test length(event_traces) >= 1

                if length(event_traces) >= 1 && has_divu
                    event1 = event_traces[1]
                    inst_events = filter(evt -> evt.type == Inst, event1)
                    inst_keys = [evt.key for evt in inst_events]

                    # Key should be (:call, :__mspabi_divu), NOT include a constant value
                    @test (:call, :__mspabi_divu) in inst_keys
                end
            end

            @testset "PerOpcode granularity" begin
                final_state, event_traces = Interpreter.interpret_program(
                    instructions, address_info, func_addrs, 100000,
                    PerOpcode; data_file=data_file,
                )

                @test length(event_traces) >= 1

                if length(event_traces) >= 1 && has_divu
                    event1 = event_traces[1]
                    inst_events = filter(evt -> evt.type == Inst, event1)
                    inst_keys = [evt.key for evt in inst_events]

                    # For PerOpcode, key should be just (:call,)
                    @test (:call,) in inst_keys
                    # Should NOT have function-specific key
                    @test !any(k -> k == (:call, :__mspabi_divu), inst_keys)
                end
            end
        end
    end
end
