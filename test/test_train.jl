# Modules are loaded in runtests.jl
# This file contains helper functions for train tests

"""
Load assembly content from the compiled test program.
This uses a real compiled C program to ensure realistic assembly.
"""
function load_test_asm_content()::String
    asm_file = joinpath(@__DIR__, "./fixtures/asm/test_train_simple.asm")
    return read(asm_file, String)
end
