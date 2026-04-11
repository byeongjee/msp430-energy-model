# Test that special function calls (e.g., __mspabi_divu) are treated as
# single composite instructions with function-specific keys.

using .Types:
    ExecutionEvent,
    ExecutionTrace,
    Inst,
    PerAddressingMode,
    PerAddressingModeConstant,
    PerOpcode
using .Model:
    parse_key_string,
    create_model,
    load_params!,
    create_estimation_config,
    estimate_energy

"""
Test special function call key generation and serialization round-trip.
"""
function run_special_function_call_tests()
    @testset "Special Function Call Keys" begin
        @testset "parse_key_string round-trips special function keys" begin
            @test parse_key_string("call___mspabi_divi") == (:call, :__mspabi_divi)
            @test parse_key_string("call___mspabi_divli") == (:call, :__mspabi_divli)
            @test parse_key_string("call___mspabi_divu") == (:call, :__mspabi_divu)
            @test parse_key_string("call___mspabi_mpyi") == (:call, :__mspabi_mpyi)
            @test parse_key_string("call___mspabi_mpyl") == (:call, :__mspabi_mpyl)
            @test parse_key_string("call___mspabi_remu") == (:call, :__mspabi_remu)
            @test parse_key_string("calla___mspabi_divu") == (:calla, :__mspabi_divu)
        end

        @testset "parse_key_string still works for normal keys" begin
            @test parse_key_string("call_immediate") == (:call, :immediate)
            @test parse_key_string("mov_immediate_register") == (:mov, :immediate, :register)
            @test parse_key_string("ret") == (:ret,)
            @test parse_key_string("nop") == (:nop,)
            @test parse_key_string("rlam_immediate_2") == (:rlam, :immediate, 2)
        end

        @testset "parse_key_string round-trips feature-function keys" begin
            @test parse_key_string("call_memcpy") == (:call_memcpy,)
            @test parse_key_string("call_memcpy_bytes") == (:call_memcpy, :bytes)
            @test parse_key_string("call_memset") == (:call_memset,)
            @test parse_key_string("call_memset_bytes") == (:call_memset, :bytes)
        end

        @testset "Key serialization produces correct string" begin
            key = (:call, :__mspabi_divu)
            key_str = join(string.(key), "_")
            @test key_str == "call___mspabi_divu"
        end

        @testset "Mean estimation scales feature-valued events" begin
            model = create_model("mean_per_addressing_mode")
            load_params!(
                model,
                Dict(
                    "model" => "mean_per_addressing_mode",
                    "parameters" => Dict(
                        "call_memcpy" => 2.0,
                        "call_memcpy_bytes" => 0.5,
                    ),
                ),
            )

            trace = ExecutionTrace([
                ExecutionEvent((:call_memcpy,), 1.0),
                ExecutionEvent((:call_memcpy, :bytes), 16.0),
            ])
            stats = estimate_energy(model, trace, create_estimation_config(model, 1))

            @test stats.mean ≈ 10.0 atol=1e-9
            @test stats.min ≈ 10.0 atol=1e-9
            @test stats.max ≈ 10.0 atol=1e-9
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
            has_divi = haskey(func_addrs, "__mspabi_divi")
            has_divli = haskey(func_addrs, "__mspabi_divli")
            has_divu = haskey(func_addrs, "__mspabi_divu")
            has_mpyi = any(name -> haskey(func_addrs, name), [
                "__mspabi_mpyi",
                "__mspabi_mpyi_f5hw",
                "__mulhi2",
            ])
            has_remu = haskey(func_addrs, "__mspabi_remu")
            if !has_divi
                @warn "No __mspabi_divi in disassembly — compiler may have optimized it away"
            end
            if !has_divli
                @warn "No __mspabi_divli in disassembly — compiler may have optimized it away"
            end
            if !has_divu
                @warn "No __mspabi_divu in disassembly — compiler may have optimized it away"
            end
            if !has_mpyi
                @warn "No __mspabi_mpyi alias in disassembly — compiler may have optimized it away"
            end
            if !has_remu
                @warn "No __mspabi_remu in disassembly — compiler may have optimized it away"
            end

            @testset "PerAddressingMode granularity" begin
                final_state, event_traces = Interpreter.interpret_program(
                    instructions, address_info, func_addrs, 100000,
                    PerAddressingMode; data_file=data_file,
                    intercept_special_calls=true,
                )

                @test length(event_traces) >= 1

                event_expectations = [
                    (1, has_divu, (:call, :__mspabi_divu)),
                    (2, has_mpyi, (:call, :__mspabi_mpyi)),
                    (3, has_divi, (:call, :__mspabi_divi)),
                    (4, has_remu, (:call, :__mspabi_remu)),
                    (5, has_divli, (:call, :__mspabi_divli)),
                ]

                for (event_idx, has_special_call, expected_key) in event_expectations
                    if length(event_traces) >= event_idx && has_special_call
                        event_trace = event_traces[event_idx]
                        inst_events = filter(evt -> evt.type == Inst, event_trace)
                        inst_keys = [evt.key for evt in inst_events]

                        @test expected_key in inst_keys
                        @test !any(k -> k == (:call, :immediate), inst_keys)
                    end
                end
            end

            @testset "PerAddressingModeConstant granularity" begin
                final_state, event_traces = Interpreter.interpret_program(
                    instructions, address_info, func_addrs, 100000,
                    PerAddressingModeConstant; data_file=data_file,
                    intercept_special_calls=true,
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
                    intercept_special_calls=true,
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

            @testset "Estimate mode interception" begin
                params_dict = Dict(
                    "model" => "mean_per_addressing_mode",
                    "parameters" => Dict(
                        "call___mspabi_divu" => 1.0,
                        "call___mspabi_mpyi" => 1.0,
                        "call___mspabi_divi" => 1.0,
                        "call___mspabi_remu" => 1.0,
                        "call___mspabi_divli" => 1.0,
                    ),
                )
                debug_file = joinpath(tempdir(), "test_estimate_special_calls_debug.json")
                rm(debug_file; force=true)

                withenv("JULIA_ESTIMATE_DEBUG_DUMP_PATH" => debug_file) do
                    Estimation.run_estimate(
                        asm_content,
                        params_dict,
                        100000,
                        10,
                        nothing,
                        data_file;
                        intercept_special_calls=true,
                    )
                end

                @test isfile(debug_file)

                debug_data = JSON.parsefile(debug_file)
                event_key_counts = [event["key_counts"] for event in debug_data["events"]]
                aggregate_key_counts = debug_data["aggregate"]["key_counts"]

                find_event_with_key(key) =
                    findfirst(key_counts -> haskey(key_counts, key), event_key_counts)

                if has_divu
                    @test find_event_with_key("call___mspabi_divu") !== nothing
                    @test haskey(aggregate_key_counts, "call___mspabi_divu")
                end
                if has_mpyi
                    mpyi_event_idx = find_event_with_key("call___mspabi_mpyi")
                    @test mpyi_event_idx !== nothing
                    @test haskey(aggregate_key_counts, "call___mspabi_mpyi")
                    if mpyi_event_idx !== nothing
                        @test !any(
                            key -> occursin("MPY", key) || occursin("OP2", key),
                            keys(event_key_counts[mpyi_event_idx]),
                        )
                    end
                end
                if has_divi
                    @test find_event_with_key("call___mspabi_divi") !== nothing
                    @test haskey(aggregate_key_counts, "call___mspabi_divi")
                end
                if has_remu
                    @test find_event_with_key("call___mspabi_remu") !== nothing
                    @test haskey(aggregate_key_counts, "call___mspabi_remu")
                end
                if has_divli
                    @test find_event_with_key("call___mspabi_divli") !== nothing
                    @test haskey(aggregate_key_counts, "call___mspabi_divli")
                end

                rm(debug_file; force=true)
            end
        end
    end
end
