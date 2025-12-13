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
Process a single assembly file and its corresponding measurement data.
Returns event traces and energy measurements.
"""
function process_training_file(
    asm_file::String, data_file::String, max_steps::Int, model_granularity::ModelGranularity
)::Tuple{Vector{ExecutionTrace},Vector{Float64}}
    @info "Processing training file" asm = asm_file data = data_file

    instructions, address_info, _base_address = Interpreter.parse_asm_file(asm_file)

    func_addrs = Parser.find_functions(asm_file)
    begin_event_addr = get(func_addrs, "begin_event", nothing)
    end_event_addr = get(func_addrs, "end_event", nothing)

    if isnothing(begin_event_addr) || isnothing(end_event_addr)
        @info "begin_event or end_event not found in assembly file"
    else
        @info "begin_event and end_event found in assembly file" begin_event_addr =
            "0x" * string(begin_event_addr; base=16, pad=4) end_event_addr =
            "0x" * string(end_event_addr; base=16, pad=4)
    end

    _, event_traces = Interpreter.interpret_program(
        instructions, address_info, func_addrs, max_steps, model_granularity; data_file=nothing
    )

    @info "Reading measurement data from CSV"
    df = CSV.read(data_file, DataFrame)

    energies = df.energy_nJ

    if length(event_traces) != length(energies)
        error(
            "Mismatch between event traces ($(length(event_traces))) and energy measurements ($(length(energies))) for file: $asm_file",
        )
    end

    @info "File processed successfully" num_events = length(event_traces)

    return event_traces, energies
end

"""
Train mode: Infer energy parameters from assembly and measurement data.
Supports single or multiple files for training.
"""
function run_train(
    asm_files::Vector{String},
    data_files::Vector{String},
    output_file::Union{String,Nothing},
    max_steps::Int,
    n_samples::Int,
    model_str::String,
    inference_str::String,
)::Nothing
    @info "Running in TRAIN mode"
    @info "Number of training files" n_files = length(asm_files)

    # Validate that number of asm files matches number of data files
    if length(asm_files) != length(data_files)
        error(
            "Number of assembly files ($(length(asm_files))) must match number of data files ($(length(data_files)))",
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

    for (asm_file, data_file) in zip(asm_files, data_files)
        event_traces, energies =
            process_training_file(asm_file, data_file, max_steps, granularity)
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
