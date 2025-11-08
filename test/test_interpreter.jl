using Test
using JSON

# Include Types module first
include("../src/types.jl")
using .Types: MachineState, Instruction

# Include Parser module
include("../src/parser.jl")
using .Parser: find_functions

# Include Interpreter module
include("../src/Interpreter.jl")
using .Interpreter: parse_asm_file, interpret_program

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
"""
function run_interpreter(asm_file::String, max_steps::Int=100000000)
    if !isfile(asm_file)
        error("Assembly file not found: $asm_file")
    end

    # Parse assembly file
    instructions, addresses, _base_address = parse_asm_file(asm_file)

    # Find function addresses
    func_addrs = find_functions(asm_file)

    # Execute program
    final_state, _ = interpret_program(
        instructions, addresses, func_addrs, max_steps
    )

    return final_state
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
Run a single test case from a fixture file
"""
function test_fixture(fixture_path::String)
    fixture = load_fixture(fixture_path)
    test_name = fixture["test_name"]
    asm_file = fixture["asm_file"]
    gdb_result = fixture["gdb_result"]

    @testset "Test: $test_name" begin
        # Run interpreter
        final_state = run_interpreter(asm_file)

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
