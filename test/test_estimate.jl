# Modules are loaded in runtests.jl

"""
Load assembly content from the compiled test program.
"""
function load_test_asm_content_for_estimate()::String
    asm_file = joinpath(@__DIR__, "./fixtures/asm/test_train_simple.asm")
    return read(asm_file, String)
end

"""
Create a minimal params dictionary for testing.
This creates valid parameters for a mean model.
"""
function create_test_params_dict(model_type::String="mean_per_instruction")::Dict
    # Create a simple params dict with one parameter
    # The key format depends on the model type
    if model_type == "mean_per_instruction"
        return Dict(
            "model" => model_type,
            "parameters" => Dict(
                "mov" => 100.0
            )
        )
    elseif model_type == "mean_per_addressing_mode"
        return Dict(
            "model" => model_type,
            "parameters" => Dict(
                "mov_register" => 100.0
            )
        )
    elseif model_type == "mean_per_addressing_mode_constant"
        return Dict(
            "model" => model_type,
            "parameters" => Dict(
                "mov_register_0" => 100.0
            )
        )
    else
        error("Unsupported model type for test: $model_type")
    end
end

@testset "Estimation.run_estimate Tests" begin
    @testset "Basic estimation with output file" begin
        asm_content = load_test_asm_content_for_estimate()
        params_dict = create_test_params_dict("mean_per_instruction")

        output_file = joinpath(tempdir(), "test_estimate_output.json")

        Estimation.run_estimate(
            asm_content,
            params_dict,
            100000,  # max_steps
            10,      # n_samples
            output_file,
            nothing  # data_dump
        )

        # Verify output file was created
        @test isfile(output_file)

        # Verify output file contains valid JSON
        result = JSON.parsefile(output_file)
        @test haskey(result, "execution_traces")
        @test isa(result["execution_traces"], Vector)

        # Clean up
        rm(output_file; force=true)
    end

    @testset "Estimation without output file" begin
        asm_content = load_test_asm_content_for_estimate()
        params_dict = create_test_params_dict("mean_per_instruction")

        # Should complete without error even without output file
        Estimation.run_estimate(
            asm_content,
            params_dict,
            100000,
            10,
            nothing,  # No output file
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

        # Create params dict without 'model' field
        invalid_params = Dict(
            "parameters" => Dict("mov" => 100.0)
        )

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
        # Test with valid params dict
        params_dict = create_test_params_dict("mean_per_instruction")
        model_type = Estimation.detect_model_type(params_dict)
        @test model_type == "mean_per_instruction"

        # Test with missing model field
        invalid_params = Dict("parameters" => Dict())
        @test_throws ErrorException Estimation.detect_model_type(invalid_params)
    end

    @testset "Estimation with trained parameters" begin
        # This test trains a model and then estimates with it
        asm_content = load_test_asm_content_for_estimate()
        energy_df = DataFrame(; energy_nJ=[100.0])

        # Train a model first
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

        # Load the trained parameters
        params_dict = JSON.parsefile(params_file)

        # Now estimate with the trained parameters
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

        # Clean up
        rm(params_file; force=true)
        rm(estimate_output; force=true)
    end
end
