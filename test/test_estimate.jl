# Modules are loaded in runtests.jl
# This file contains helper functions for estimate tests

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
    if model_type == "mean_per_instruction"
        return Dict("model" => model_type, "parameters" => Dict("mov" => 100.0))
    elseif model_type == "mean_per_addressing_mode"
        return Dict("model" => model_type, "parameters" => Dict("mov_register" => 100.0))
    elseif model_type == "mean_per_addressing_mode_constant"
        return Dict("model" => model_type, "parameters" => Dict("mov_register_0" => 100.0))
    else
        error("Unsupported model type for test: $model_type")
    end
end
