#!/usr/bin/env julia

# Test baseline mean estimation method
# Train on train_addressing_mode.c, test on test.c with two granularities

include("../src/Interpreter.jl")
include("../src/Inference.jl")
include("../src/BaselineEstimation.jl")

using .Interpreter
using .Inference
using .BaselineEstimation
using .Inference: get_instruction_key

# Import the types and functions we need
const Instruction = Interpreter.Instruction
const MachineState = Interpreter.MachineState
const find_functions = Interpreter.find_functions
using CSV
using DataFrames
using Statistics
using Logging

"""
Extract dominant instruction key from a program (event sequence).
For microbenchmarks, finds the most frequent instruction.
"""
function get_dominant_key(
    program::Vector{Instruction}, granularity::ModelGranularity
)::Tuple{Vararg{Symbol}}
    # Count instruction types
    inst_counts = Dict{Tuple{Vararg{Symbol}},Int}()
    for inst in program
        key = get_instruction_key(inst, granularity)
        inst_counts[key] = get(inst_counts, key, 0) + 1
    end

    # Return key with maximum count
    dominant_key = argmax(inst_counts)
    return dominant_key
end

"""
Process data file and extract dominant keys for each event.
"""
function process_data(
    asm_file::String,
    data_file::String,
    granularity::ModelGranularity,
    max_steps::Int=100000000,
)
    @info "Processing data" asm = asm_file data = data_file

    # Parse assembly
    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)
    func_addrs = find_functions(asm_file)

    # Run interpreter to get event sequences
    _, event_sequences = Interpreter.interpret_program(
        instructions, addresses, func_addrs, max_steps
    )

    # Read measurements
    df = CSV.read(data_file, DataFrame)
    energies = df.energy_nJ

    if length(event_sequences) != length(energies)
        error(
            "Mismatch: $(length(event_sequences)) events vs $(length(energies)) measurements",
        )
    end

    # Extract dominant key for each event
    keys = [get_dominant_key(seq, granularity) for seq in event_sequences]

    @info "Data processed" num_events = length(event_sequences)

    return event_sequences, energies, keys
end

"""
Process test assembly file and get event sequences (no measurements needed).
"""
function process_test_asm(asm_file::String, max_steps::Int=100000000)
    @info "Processing test assembly" asm = asm_file

    # Parse assembly
    instructions, addresses, _base_address = Interpreter.parse_asm_file(asm_file)
    func_addrs = find_functions(asm_file)

    # Run interpreter to get event sequences
    _, event_sequences = Interpreter.interpret_program(
        instructions, addresses, func_addrs, max_steps
    )

    @info "Test program interpreted" num_events = length(event_sequences)

    return event_sequences
end

"""
Run baseline estimation: train on training data, predict on test data.
"""
function test_baseline(
    train_asm::String,
    train_csv::String,
    test_asm::String,
    granularity::ModelGranularity;
    max_steps::Int=100000000,
)
    @info "="^60
    @info "BASELINE ESTIMATION TEST"
    @info "="^60
    @info "Training file" asm = train_asm data = train_csv
    @info "Test file" asm = test_asm
    @info "Granularity" granularity

    # Process test program (interpret only, no measurements)
    @info "Processing test program..."
    test_sequences = process_test_asm(test_asm, max_steps)

    # Quick sanity check
    if !isempty(test_sequences)
        @info "Test events captured" count = length(test_sequences)
        # Check instruction counts per event
        lengths = [length(seq) for seq in test_sequences]
        @info "Instructions per event" mean = round(mean(lengths); digits=1) min = minimum(
            lengths
        ) max = maximum(lengths)
    end

    # Process training data
    train_sequences, train_energies, train_keys = process_data(
        train_asm, train_csv, granularity, max_steps
    )

    # Learn baseline parameters
    @info "Learning baseline parameters..."
    mean_params = learn_mean_parameters(train_energies, train_sequences, granularity)

    # Estimate energies for test sequences
    @info "Estimating test energies..."
    predictions = Float64[]
    for seq in test_sequences
        pred = estimate_energy_baseline(seq, mean_params, granularity)
        push!(predictions, pred)
    end

    @info "="^60
    @info "RESULTS"
    @info "="^60
    @info "Test events" count = length(predictions)
    @info "Predicted energy (mean)" mean = round(mean(predictions); digits=2)
    @info "Predicted energy (std)" std = round(std(predictions); digits=2)
    @info "Predicted energy (min)" min = round(minimum(predictions); digits=2)
    @info "Predicted energy (max)" max = round(maximum(predictions); digits=2)

    return predictions, mean_params
end

# Main execution
function main()
    max_steps = 100000000

    train_asm = "build/asm/train_addressing_mode.asm"
    train_csv = "./train_addressing_mode_updated2_segments.csv"
    test_asm = "build/asm/test.asm"

    # Check if files exist
    if !isfile(train_asm)
        error("Training assembly not found: $train_asm")
    end
    if !isfile(train_csv)
        error("Training CSV not found: $train_csv")
    end
    if !isfile(test_asm)
        error("Test assembly not found: $test_asm")
    end

    # Test 1: PerOpcode granularity
    @info "\n" * "="^60
    @info "TEST 1: train_addressing_mode.c → test.c (PerOpcode)"
    @info "="^60

    test_baseline(train_asm, train_csv, test_asm, Inference.PerOpcode; max_steps=max_steps)

    # Test 2: PerAddressingMode granularity
    @info "\n" * "="^60
    @info "TEST 2: train_addressing_mode.c → test.c (PerAddressingMode)"
    @info "="^60

    test_baseline(
        train_asm, train_csv, test_asm, Inference.PerAddressingMode; max_steps=max_steps
    )

    @info "\n" * "="^60
    @info "ALL TESTS COMPLETE"
    @info "="^60
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
