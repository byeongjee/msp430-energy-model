using Test
using JSON

include("../src/types.jl")
using .Types: MachineState, Instruction

include("../src/parser.jl")
using .Parser

include("../src/Interpreter.jl")
using .Interpreter

"""
Load a test fixture from JSON file
Returns a dictionary with test_name, asm_file, and gdb_result
"""
function load_fixture(fixture_path::String)
    if !isfile(fixture_path)
        error("Fixture file not found: $fixture_path")
    end

    fixture_data = JSON.parsefile(fixture_path)
    return fixture_data
end

"""
Run the interpreter on an assembly file and return the final machine state
Optionally returns memory access counts when log_memory_access is true
"""
function run_interpreter(
    asm_file::String,
    max_steps::Int=100000000,
    data_file::Union{String,Nothing}=nothing,
    log_memory_access::Bool=false,
)
    if !isfile(asm_file)
        error("Assembly file not found: $asm_file")
    end
    data_dump = nothing
    if data_file !== nothing
        if isfile(data_file)
            data_dump = data_file
        else
            rel_path = joinpath(@__DIR__, "..", data_file)
            if isfile(rel_path)
                data_dump = rel_path
            else
                @info "Data file not found; continuing without data dump" data_file rel_path
            end
        end
    end

    # Parse assembly file
    instructions, address_info, _base_address = Interpreter.parse_asm_file(asm_file)

    # Find function addresses
    func_addrs = Parser.find_functions(asm_file)

    # Execute program
    final_state, event_traces = Interpreter.interpret_program(
        instructions, address_info, func_addrs, max_steps; data_file=data_dump
    )

    # Compute event accesses from traces if memory access logging is enabled
    event_accesses =
        log_memory_access ?
        Interpreter.compute_event_accesses(
            event_traces, Interpreter.build_memory_regions()
        ) : Vector{Dict{Symbol,Int}}()

    return final_state, event_accesses
end

"""
Convert MachineState to a comparable dictionary format
"""
function state_to_dict(state::MachineState)
    return Dict(
        "registers" => Dict(
            "PC" => Int(state.registers[:PC]),
            "SP" => Int(state.registers[:SP]),
            "SR" => Int(state.registers[:SR]),
            "R3" => Int(state.registers[:R3]),
            "R4" => Int(state.registers[:R4]),
            "R5" => Int(state.registers[:R5]),
            "R6" => Int(state.registers[:R6]),
            "R7" => Int(state.registers[:R7]),
            "R8" => Int(state.registers[:R8]),
            "R9" => Int(state.registers[:R9]),
            "R10" => Int(state.registers[:R10]),
            "R11" => Int(state.registers[:R11]),
            "R12" => Int(state.registers[:R12]),
            "R13" => Int(state.registers[:R13]),
            "R14" => Int(state.registers[:R14]),
            "R15" => Int(state.registers[:R15]),
        ),
        "flags" => Dict(
            "C" => state.flags[:C],
            "Z" => state.flags[:Z],
            "N" => state.flags[:N],
            "V" => state.flags[:V],
        ),
        "pc" => Int(state.registers[:PC]),
    )
end

"""
Compare two register/flag dictionaries and return differences
"""
function compare_states(interpreter_state::Dict, gdb_state::Dict)
    differences = Dict()

    # Compare registers
    for reg in [
        "PC",
        "SP",
        "SR",
        "R3",
        "R4",
        "R5",
        "R6",
        "R7",
        "R8",
        "R9",
        "R10",
        "R11",
        "R12",
        "R13",
        "R14",
        "R15",
    ]
        interp_val = interpreter_state["registers"][reg]
        gdb_val = gdb_state["registers"][reg]

        if interp_val != gdb_val
            differences[reg] = Dict(
                "interpreter" => "0x" * string(interp_val; base=16, pad=4),
                "gdb" => "0x" * string(gdb_val; base=16, pad=4),
            )
        end
    end

    # Compare flags
    for flag in ["C", "Z", "N", "V"]
        interp_val = interpreter_state["flags"][flag]
        gdb_val = gdb_state["flags"][flag]

        if interp_val != gdb_val
            differences["flag_$flag"] = Dict("interpreter" => interp_val, "gdb" => gdb_val)
        end
    end

    return differences
end

"""
Compare memory access counts with expected values
Returns dictionary of differences or empty dict if all match
"""
function compare_cache_accesses(actual::Vector{Dict{Symbol,Int}}, expected::Vector)
    differences = Dict()

    if length(actual) != length(expected)
        differences["event_count"] = (actual=length(actual), expected=length(expected))
        return differences
    end

    for (i, (actual_event, expected_event)) in enumerate(zip(actual, expected))
        event_diffs = Dict()

        # Check each field
        for (key_str, expected_val) in expected_event
            key = Symbol(key_str)
            actual_val = get(actual_event, key, 0)

            if actual_val != expected_val
                event_diffs[key] = (actual=actual_val, expected=expected_val)
            end
        end

        if !isempty(event_diffs)
            differences["event_$i"] = event_diffs
        end
    end

    return differences
end

"""
Run a single test case from a fixture file
"""
function test_fixture(fixture_path::String)
    fixture = load_fixture(fixture_path)
    test_name = fixture["test_name"]
    asm_file = fixture["asm_file"]
    data_file = get(fixture, "data_file", nothing)
    gdb_result = fixture["gdb_result"]

    # Check if cache testing is needed
    has_cache_test = haskey(fixture, "cache")

    @testset "Test: $test_name" begin
        # Run interpreter with optional memory access logging
        if has_cache_test
            final_state, event_accesses = run_interpreter(
                asm_file, 100000000, data_file, true
            )
        else
            final_state, _ = run_interpreter(asm_file, 100000000, data_file, false)
        end

        # Convert to comparable format
        interpreter_result = state_to_dict(final_state)

        # Compare results
        differences = compare_states(interpreter_result, gdb_result)

        # Single test: states must match exactly
        if !isempty(differences)
            println("\n⚠️  Test FAILED: $test_name")
            println("Differences:")
            for (key, diff) in differences
                println("  $key:")
                println("    Interpreter: $(diff["interpreter"])")
                println("    GDB:         $(diff["gdb"])")
            end
            println()
        end

        @test isempty(differences)

        # Test cache accesses if cache field exists
        if has_cache_test
            expected_cache = fixture["cache"]
            cache_diffs = compare_cache_accesses(event_accesses, expected_cache)

            if !isempty(cache_diffs)
                println("\n⚠️  Cache test FAILED: $test_name")
                println("Cache access differences:")
                for (event_key, diffs) in cache_diffs
                    println("  $event_key:")
                    for (field, values) in diffs
                        println(
                            "    $field: actual=$(values.actual), expected=$(values.expected)",
                        )
                    end
                end
                println()
            end

            @test isempty(cache_diffs)
        end
    end
end

"""
Run all test fixtures in the fixtures directory
Optional filter_pattern: only run tests whose names match the regex pattern
"""
function run_all_fixtures(filter_pattern::Union{Regex,Nothing}=nothing)
    fixtures_dir = joinpath(@__DIR__, "fixtures")

    if !isdir(fixtures_dir)
        @warn "Fixtures directory not found: $fixtures_dir"
        @warn "Please create fixtures using: test/scripts/create_fixture.sh"
        return nothing
    end

    fixture_files = filter(f -> endswith(f, ".json"), readdir(fixtures_dir))

    if isempty(fixture_files)
        @warn "No fixture files found in: $fixtures_dir"
        @warn "Please create fixtures using: test/scripts/create_fixture.sh"
        return nothing
    end

    # Apply filter pattern if provided
    if !isnothing(filter_pattern)
        fixture_files = filter(fixture_files) do f
            # Remove .json extension for matching
            test_name = replace(f, r"\.json$" => "")
            occursin(filter_pattern, test_name)
        end

        if isempty(fixture_files)
            @warn "No fixture files matched the pattern: $filter_pattern"
            return nothing
        end
    end

    @testset "All Interpreter Tests" begin
        for fixture_file in fixture_files
            fixture_path = joinpath(fixtures_dir, fixture_file)
            test_fixture(fixture_path)
        end
    end
end

# Export functions for use in runtests.jl
export load_fixture, run_interpreter, test_fixture, run_all_fixtures
