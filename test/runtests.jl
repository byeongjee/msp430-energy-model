using Test
using JSON
using DataFrames
using Logging

# Suppress INFO level logs during tests
global_logger(ConsoleLogger(stderr, Logging.Warn))

# Load common modules once
include("../src/types.jl")
using .Types

include("../src/parser.jl")
using .Parser

include("../src/TraceMetrics.jl")
using .TraceMetrics

include("../src/Interpreter.jl")
using .Interpreter

include("../src/model.jl")
using .Model

include("../src/Train.jl")
using .Train

include("../src/Estimation.jl")
using .Estimation

# Include test files
include("test_interpreter.jl")
include("test_train.jl")
include("test_estimate.jl")
include("test_br_immediate.jl")
include("test_sram_code.jl")
include("test_stack_events.jl")
include("test_special_function_calls.jl")

# Define test suites with their names and runner functions
const TEST_SUITES = Dict(
    "interpreter" => (
        description = "Interpreter fixture tests",
        runner = filter_pattern -> run_all_fixtures(filter_pattern),
        has_subfilter = true,  # This suite supports sub-filtering by fixture name
    ),
    "train" => (
        description = "Training module tests",
        runner = _ -> run_train_tests(),
        has_subfilter = false,
    ),
    "estimate" => (
        description = "Estimation module tests",
        runner = _ -> run_estimate_tests(),
        has_subfilter = false,
    ),
    "br_immediate" => (
        description = "BR immediate benchmark tests",
        runner = _ -> run_br_immediate_tests(),
        has_subfilter = false,
    ),
    "sram" => (
        description = "SRAM code execution tests",
        runner = _ -> run_sram_code_tests(),
        has_subfilter = false,
    ),
    "stack_events" => (
        description = "Stack event tracking tests",
        runner = _ -> run_stack_events_tests(),
        has_subfilter = false,
    ),
    "special_function_calls" => (
        description = "Special function call key tests",
        runner = _ -> run_special_function_call_tests(),
        has_subfilter = false,
    ),
)

"""
Check if a test suite name matches the given pattern.
Returns (should_run, sub_pattern) where sub_pattern is passed to suites that support sub-filtering.

Pattern matching behavior:
- If pattern matches any suite name exactly, only matching suites run
- Otherwise, pattern is passed to interpreter for fixture filtering
"""
function should_run_suite(suite_name::String, pattern::Union{Regex,Nothing}, suite_names::Vector{String})
    if isnothing(pattern)
        return (true, nothing)
    end

    # Check if pattern matches any suite name
    matches_any_suite = any(name -> occursin(pattern, name), suite_names)

    if matches_any_suite
        # Pattern matches suite name(s) - only run matching suites
        if occursin(pattern, suite_name)
            return (true, nothing)
        else
            return (false, nothing)
        end
    else
        # Pattern doesn't match any suite name - pass to interpreter for fixture filtering
        if suite_name == "interpreter"
            return (true, pattern)
        else
            return (false, nothing)
        end
    end
end

"""
Run all test suites, optionally filtered by pattern.

Pattern matching behavior:
- No pattern: Run all tests
- Pattern matches suite name (e.g., "train", "interpreter"): Run that suite
- Pattern for interpreter suite: Also filters individual fixtures

Examples:
  julia test/runtests.jl                    # Run all tests
  julia test/runtests.jl "train"            # Run train tests only
  julia test/runtests.jl "interpreter"      # Run all interpreter fixture tests
  julia test/runtests.jl "simple"           # Run interpreter fixtures matching "simple"
  julia test/runtests.jl "train|estimate"   # Run train and estimate tests
"""
function run_all_tests(pattern::Union{Regex,Nothing}=nothing)
    println("=" ^ 70)
    println("MSP430 Energy Modeling Test Suite")
    println("=" ^ 70)

    if !isnothing(pattern)
        println("Filter pattern: $(pattern.pattern)")
    end
    println()

    suite_names = sort(collect(keys(TEST_SUITES)))

    # Track which suites will run
    suites_to_run = String[]
    for suite_name in suite_names
        should_run, _ = should_run_suite(suite_name, pattern, suite_names)
        if should_run
            push!(suites_to_run, suite_name)
        end
    end

    if isempty(suites_to_run)
        println("No test suites matched pattern: $(pattern.pattern)")
        println("Available suites: $(join(suite_names, ", "))")
        return
    end

    println("Running test suites: $(join(suites_to_run, ", "))")
    println()

    @testset verbose=true "All Tests" begin
        for suite_name in suite_names
            should_run, sub_pattern = should_run_suite(suite_name, pattern, suite_names)

            if !should_run
                continue
            end

            suite = TEST_SUITES[suite_name]
            println("-" ^ 70)
            println("Running: $(suite.description)")
            println("-" ^ 70)

            suite.runner(sub_pattern)

            println()
        end
    end

    println()
    println("=" ^ 70)
    println("Test Suite Complete")
    println("=" ^ 70)
end

# Wrapper functions to create testsets for train and estimate
function run_train_tests()
    # The @testset is defined in test_train.jl, we just need to trigger it
    # Re-evaluate the testset block
    @testset "Train Module" begin
        @testset "Single training sample" begin
            asm_content = load_test_asm_content()
            energy_df = DataFrame(; energy_nJ=[100.0])
            output_file = joinpath(tempdir(), "test_params_single.json")

            Train.run_train(
                [asm_content],
                [energy_df],
                output_file,
                1000,
                10,
                "mean_per_instruction",
                "dominant-key",
            )

            @test isfile(output_file)
            rm(output_file; force=true)
        end

        @testset "Multiple training samples" begin
            asm_content1 = load_test_asm_content()
            asm_content2 = load_test_asm_content()
            energy_df1 = DataFrame(; energy_nJ=[100.0])
            energy_df2 = DataFrame(; energy_nJ=[150.0])
            output_file = joinpath(tempdir(), "test_params_multi.json")

            Train.run_train(
                [asm_content1, asm_content2],
                [energy_df1, energy_df2],
                output_file,
                1000,
                10,
                "mean_per_instruction",
                "dominant-key",
            )

            @test isfile(output_file)
            rm(output_file; force=true)
        end

        @testset "Training without output file" begin
            asm_content = load_test_asm_content()
            energy_df = DataFrame(; energy_nJ=[100.0])

            Train.run_train(
                [asm_content],
                [energy_df],
                nothing,
                1000,
                10,
                "mean_per_instruction",
                "dominant-key",
            )

            @test true
        end

        @testset "Validation: mismatched input lengths" begin
            asm_content = load_test_asm_content()
            energy_df = DataFrame(; energy_nJ=[100.0])

            @test_throws ErrorException Train.run_train(
                [asm_content, asm_content],
                [energy_df],
                nothing,
                1000,
                10,
                "mean_per_instruction",
                "dominant-key",
            )
        end

        @testset "Validation: event count mismatch" begin
            asm_content = load_test_asm_content()
            energy_df = DataFrame(; energy_nJ=[100.0, 200.0])

            @test_throws ErrorException Train.run_train(
                [asm_content],
                [energy_df],
                nothing,
                1000,
                10,
                "mean_per_instruction",
                "dominant-key",
            )
        end

        @testset "Different model types" begin
            asm_content = load_test_asm_content()
            energy_df = DataFrame(; energy_nJ=[100.0])

            for model_str in [
                "mean_per_instruction",
                "mean_per_addressing_mode",
                "mean_per_addressing_mode_constant",
            ]
                output_file = joinpath(tempdir(), "test_params_$(model_str).json")

                Train.run_train(
                    [asm_content], [energy_df], output_file, 1000, 10, model_str, "dominant-key"
                )

                @test isfile(output_file)
                rm(output_file; force=true)
            end
        end

        @testset "MAP inference algorithm" begin
            asm_content = load_test_asm_content()
            energy_df = DataFrame(; energy_nJ=[100.0])
            output_file = joinpath(tempdir(), "test_params_map.json")

            Train.run_train(
                [asm_content],
                [energy_df],
                output_file,
                1000,
                10,
                "mean_per_addressing_mode",
                "map",
            )

            @test isfile(output_file)

            # Verify output format is valid
            params = JSON.parsefile(output_file)
            @test params["model"] == "mean_per_addressing_mode"
            @test haskey(params, "parameters")
            @test !isempty(params["parameters"])

            # All parameters must be positive (the whole point of MAP)
            for (key, value) in params["parameters"]
                @test value > 0
            end

            rm(output_file; force=true)
        end

        @testset "MAP with multiple training samples" begin
            asm_content1 = load_test_asm_content()
            asm_content2 = load_test_asm_content()
            energy_df1 = DataFrame(; energy_nJ=[100.0])
            energy_df2 = DataFrame(; energy_nJ=[150.0])
            output_file = joinpath(tempdir(), "test_params_map_multi.json")

            Train.run_train(
                [asm_content1, asm_content2],
                [energy_df1, energy_df2],
                output_file,
                1000,
                10,
                "mean_per_addressing_mode",
                "map",
            )

            @test isfile(output_file)

            params = JSON.parsefile(output_file)
            for (key, value) in params["parameters"]
                @test value > 0
            end

            rm(output_file; force=true)
        end

        @testset "Feature-valued events in training matrix" begin
            # Create execution events with custom feature_value
            event1 = ExecutionEvent((:mov, :register, :register), 1.0)
            event2 = ExecutionEvent((:call_memcpy,), 1.0)  # intercept
            event3 = ExecutionEvent((:call_memcpy, :bytes), 256.0)  # slope feature

            @test event1.feature_value == 1.0
            @test event2.feature_value == 1.0
            @test event3.feature_value == 256.0
            @test event3.key == (:call_memcpy, :bytes)

            # Verify default feature_value is 1.0 for regular events
            inst = Instruction(:mov, [Operand(:R5, :register), Operand(:R6, :register)], :word)
            regular_event = ExecutionEvent(Val{Inst}, inst, PerAddressingMode)
            @test regular_event.feature_value == 1.0
        end

        @testset "process_training_data function" begin
            asm_content = load_test_asm_content()
            energy_df = DataFrame(; energy_nJ=[100.0])
            model = Model.create_model("mean_per_instruction")

            event_traces, energies = Train.process_training_data(
                asm_content, energy_df, 1000, model.granularity
            )

            @test length(event_traces) == 1
            @test length(energies) == 1
            @test energies[1] == 100.0
        end
    end
end

function run_estimate_tests()
    @testset "Estimate Module" begin
        @testset "Basic estimation with output file" begin
            asm_content = load_test_asm_content_for_estimate()
            params_dict = create_test_params_dict("mean_per_instruction")
            output_file = joinpath(tempdir(), "test_estimate_output.json")

            Estimation.run_estimate(
                asm_content,
                params_dict,
                100000,
                10,
                output_file,
                nothing
            )

            @test isfile(output_file)
            result = JSON.parsefile(output_file)
            @test haskey(result, "execution_traces")
            @test isa(result["execution_traces"], Vector)

            rm(output_file; force=true)
        end

        @testset "Estimation without output file" begin
            asm_content = load_test_asm_content_for_estimate()
            params_dict = create_test_params_dict("mean_per_instruction")

            Estimation.run_estimate(
                asm_content,
                params_dict,
                100000,
                10,
                nothing,
                nothing
            )

            @test true
        end

        @testset "Different model types" begin
            asm_content = load_test_asm_content_for_estimate()

            for model_type in [
                "mean_per_instruction",
                "mean_per_addressing_mode",
                "mean_per_addressing_mode_constant"
            ]
                params_dict = create_test_params_dict(model_type)
                output_file = joinpath(tempdir(), "test_estimate_$(model_type).json")

                Estimation.run_estimate(
                    asm_content,
                    params_dict,
                    100000,
                    10,
                    output_file,
                    nothing
                )

                @test isfile(output_file)
                rm(output_file; force=true)
            end
        end

        @testset "Validation: missing model field" begin
            asm_content = load_test_asm_content_for_estimate()
            invalid_params = Dict("parameters" => Dict("mov" => 100.0))

            @test_throws ErrorException Estimation.run_estimate(
                asm_content,
                invalid_params,
                100000,
                10,
                nothing,
                nothing
            )
        end

        @testset "detect_model_type function" begin
            params_dict = create_test_params_dict("mean_per_instruction")
            model_type = Estimation.detect_model_type(params_dict)
            @test model_type == "mean_per_instruction"

            invalid_params = Dict("parameters" => Dict())
            @test_throws ErrorException Estimation.detect_model_type(invalid_params)
        end

        @testset "Estimation with trained parameters" begin
            asm_content = load_test_asm_content_for_estimate()
            energy_df = DataFrame(; energy_nJ=[100.0])

            params_file = joinpath(tempdir(), "test_train_for_estimate.json")
            Train.run_train(
                [asm_content],
                [energy_df],
                params_file,
                100000,
                10,
                "mean_per_instruction",
                "dominant-key"
            )

            params_dict = JSON.parsefile(params_file)

            estimate_output = joinpath(tempdir(), "test_estimate_trained.json")
            Estimation.run_estimate(
                asm_content,
                params_dict,
                100000,
                10,
                estimate_output,
                nothing
            )

            @test isfile(estimate_output)

            rm(params_file; force=true)
            rm(estimate_output; force=true)
        end
    end
end

# Parse command-line arguments for test filtering
filter_pattern = nothing
if length(ARGS) > 0
    filter_pattern = Regex(ARGS[1])
end

# Run all tests
run_all_tests(filter_pattern)
