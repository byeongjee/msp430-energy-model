module Train

using CSV
using DataFrames
using Logging
using ..Types: ExecutionTrace, ExecutionEvent, TrainingData, ModelGranularity
using ..Interpreter
using ..Parser
using ..Model

include("model_common.jl")

export run_train

"""
Process training data from assembly content and energy measurements.
Returns event traces and energy measurements.
"""
function process_training_data(
    asm_content::String,
    energy_df::DataFrame,
    max_steps::Int,
    model_granularity::ModelGranularity,
)::Tuple{Vector{ExecutionTrace},Vector{Float64}}
    @info "Processing training data"

    # Parse assembly content
    instructions, address_info, _base_address = Interpreter.parse_asm_string(asm_content)

    func_addrs = Parser.find_functions_from_string(asm_content)
    begin_event_addr = get(func_addrs, "begin_event", nothing)
    end_event_addr = get(func_addrs, "end_event", nothing)

    if isnothing(begin_event_addr) || isnothing(end_event_addr)
        @info "begin_event or end_event not found in assembly"
    else
        @info "begin_event and end_event found in assembly" begin_event_addr =
            "0x" * string(begin_event_addr; base=16, pad=4) end_event_addr =
            "0x" * string(end_event_addr; base=16, pad=4)
    end

    _, event_traces = Interpreter.interpret_program(
        instructions, address_info, func_addrs, max_steps, model_granularity; data_file=nothing
    )

    energies = energy_df.energy_nJ

    if length(event_traces) != length(energies)
        error(
            "Mismatch between event traces ($(length(event_traces))) and energy measurements ($(length(energies)))",
        )
    end

    @info "Training data processed successfully" num_events = length(event_traces)

    return event_traces, energies
end

"""
Train mode: Infer energy parameters from assembly content and measurement data.
Supports single or multiple training samples.
"""
function run_train(
    asm_contents::Vector{String},
    energy_dfs::Vector{DataFrame},
    output_file::Union{String,Nothing},
    max_steps::Int,
    n_samples::Int,
    model_str::String,
    inference_str::String,
)::Nothing
    @info "Running in TRAIN mode"
    @info "Number of training samples" n_samples = length(asm_contents)

    # Validate that number of asm contents matches number of data frames
    if length(asm_contents) != length(energy_dfs)
        error(
            "Number of assembly contents ($(length(asm_contents))) must match number of energy dataframes ($(length(energy_dfs)))",
        )
    end

    model = Model.create_model(model_str)
    @info "Model type" model = model_str
    granularity = model.granularity

    if !isnothing(output_file)
        @info "Output file" path = output_file
    end

    all_event_traces = Vector{ExecutionTrace}()
    all_energies = Vector{Float64}()

    for (asm_content, energy_df) in zip(asm_contents, energy_dfs)
        event_traces, energies =
            process_training_data(asm_content, energy_df, max_steps, granularity)
        append!(all_event_traces, event_traces)
        append!(all_energies, energies)
    end

    @info "Creating combined training data" total_samples = length(all_energies)
    training_data = TrainingData(all_event_traces, all_energies)

    @info "Training data created successfully"

    config = Model.create_training_config(model, n_samples, inference_str)
    Model.learn_params!(model, training_data, config)

    if !isnothing(output_file)
        Model.save_params(model, output_file)
    else
        @info "No output file specified, skipping save"
    end

    return nothing
end

end # module
