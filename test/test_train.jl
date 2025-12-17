# Modules are loaded in runtests.jl

"""
Load assembly content from the compiled test program.
This uses a real compiled C program to ensure realistic assembly.
"""
function load_test_asm_content()::String
    asm_file = joinpath(@__DIR__, "./fixtures/asm/test_train_simple.asm")
    return read(asm_file, String)
end

@testset "Train.run_train Tests" begin
    @testset "Single training sample" begin
        # Load real assembly content from compiled C program
        asm_content = load_test_asm_content()

        # Create energy DataFrame with one event
        # The energy values are arbitrary for testing purposes
        energy_df = DataFrame(; energy_nJ=[100.0])

        # Create temporary output file path
        output_file = joinpath(tempdir(), "test_params_single.json")

        # Run training with mean model (simpler than gamma for testing)
        Train.run_train(
            [asm_content],
            [energy_df],
            output_file,
            1000,  # max_steps
            10,      # n_samples
            "mean_per_instruction",
            "dominant-key",
        )

        # Verify output file was created
        @test isfile(output_file)

        # Clean up
        rm(output_file; force=true)
    end

    @testset "Multiple training samples" begin
        # Load assembly content (use same for both samples in this test)
        asm_content1 = load_test_asm_content()
        asm_content2 = load_test_asm_content()

        # Create energy DataFrames
        # Each DataFrame has measurements for one assembly file
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
        # Test that training works without saving to file
        asm_content = load_test_asm_content()
        energy_df = DataFrame(; energy_nJ=[100.0])

        # No output file specified (nothing)
        Train.run_train(
            [asm_content],
            [energy_df],
            nothing,  # No output file
            1000,
            10,
            "mean_per_instruction",
            "dominant-key",
        )

        # Should complete without error (no assertion needed, just shouldn't throw)
        @test true
    end

    @testset "Validation: mismatched input lengths" begin
        asm_content = load_test_asm_content()
        energy_df = DataFrame(; energy_nJ=[100.0])

        # Provide 2 assembly contents but only 1 energy DataFrame
        @test_throws ErrorException Train.run_train(
            [asm_content, asm_content],  # 2 contents
            [energy_df],                  # 1 DataFrame - mismatch!
            nothing,
            1000,
            10,
            "mean_per_instruction",
            "dominant-key",
        )
    end

    @testset "Validation: event count mismatch" begin
        asm_content = load_test_asm_content()

        # Create DataFrame with 2 energy measurements
        # but the program only generates 1 event
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

        # Test with different model granularities
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

    @testset "process_training_data function" begin
        # Test the helper function directly
        asm_content = load_test_asm_content()
        energy_df = DataFrame(; energy_nJ=[100.0])

        model = Model.create_model("mean_per_instruction")

        event_traces, energies = Train.process_training_data(
            asm_content, energy_df, 1000, model.granularity
        )

        # Verify we got traces and energies back
        @test length(event_traces) == 1
        @test length(energies) == 1
        @test energies[1] == 100.0
    end
end
