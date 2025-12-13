module TraceMetrics

using Logging
using ..Types:
    ExecutionTrace,
    Inst,
    FRAMReadHit,
    FRAMReadMiss,
    FRAMWrite,
    SRAMRead,
    SRAMWrite

export FRAM_RANGES,
    SRAM_RANGES,
    build_memory_regions,
    classify_region,
    compute_event_accesses

const FRAM_RANGES = [(0x04000, 0x043FFF)]
const SRAM_RANGES = [(0x1C00, 0x3BFF)]

"""
Parse an address range specification of the form "start:end" (hex or decimal).
"""
function _parse_range(range_str::String)::Tuple{UInt32,UInt32}
    parts = split(range_str, ":")
    length(parts) == 2 || error("Invalid range '$range_str'. Expected start:end.")
    parse_addr =
        s -> UInt32(parse(Int, startswith(lowercase(s), "0x") ? s : "0x$s"; base=16))
    start_addr = parse_addr(strip(parts[1]))
    end_addr = parse_addr(strip(parts[2]))
    start_addr <= end_addr || error("Range start must be <= end in '$range_str'")
    return (start_addr, end_addr)
end

"""
Create memory region configuration for FRAM/SRAM classification.
"""
function build_memory_regions(
    fram_specs::Union{Nothing,Vector{String}}=nothing,
    sram_specs::Union{Nothing,Vector{String}}=nothing,
)
    fram_ranges =
        isnothing(fram_specs) || isempty(fram_specs) ? FRAM_RANGES :
        [_parse_range(r) for r in fram_specs]
    sram_ranges =
        isnothing(sram_specs) || isempty(sram_specs) ? SRAM_RANGES :
        [_parse_range(r) for r in sram_specs]
    return Dict(:fram => fram_ranges, :sram => sram_ranges)
end

"""
Classify an address into :fram, :sram, or :other based on configured ranges.
"""
function classify_region(addr::UInt32, memory_regions)::Symbol
    for (lo, hi) in get(memory_regions, :sram, SRAM_RANGES)
        if lo <= addr <= hi
            return :sram
        end
    end
    for (lo, hi) in get(memory_regions, :fram, FRAM_RANGES)
        if lo <= addr <= hi
            return :fram
        end
    end
    @warn "Address $addr not in any memory region"
    return :other
end

"""
Accumulate per-event memory access counts for logging.
"""
function update_access_counts!(
    counts::Dict{Symbol,Int}, execution_trace::ExecutionTrace, memory_regions
)::Dict{Symbol,Int}
    for execution_event in execution_trace
        if execution_event.type == Inst
            continue
        end

        addr = execution_event.memory_access_info[1]
        region = classify_region(addr, memory_regions)

        if execution_event.type == FRAMReadHit
            counts[:fram_read_hit] = get(counts, :fram_read_hit, 0) + 1
            counts[:reads] = get(counts, :reads, 0) + 1
        elseif execution_event.type == FRAMReadMiss
            counts[:fram_read_miss] = get(counts, :fram_read_miss, 0) + 1
            counts[:reads] = get(counts, :reads, 0) + 1
        elseif execution_event.type == FRAMWrite
            counts[:fram_write] = get(counts, :fram_write, 0) + 1
            counts[:writes] = get(counts, :writes, 0) + 1
        elseif execution_event.type == SRAMRead
            counts[:sram_read] = get(counts, :sram_read, 0) + 1
            counts[:reads] = get(counts, :reads, 0) + 1
        elseif execution_event.type == SRAMWrite
            counts[:sram_write] = get(counts, :sram_write, 0) + 1
            counts[:writes] = get(counts, :writes, 0) + 1
        else
            counts[:other] = get(counts, :other, 0) + 1
        end

        counts[region] = get(counts, region, 0) + 1
        counts[:total] = get(counts, :total, 0) + 1
    end
    return counts
end

"""
Compute memory access counts for each execution trace.
Returns a vector of access count dictionaries, one per trace.
"""
function compute_event_accesses(
    event_traces::Vector{ExecutionTrace}, memory_regions
)::Vector{Dict{Symbol,Int}}
    return [
        update_access_counts!(
            Dict{Symbol,Int}(
                :fram_read_hit => 0,
                :fram_read_miss => 0,
                :fram_write => 0,
                :sram_read => 0,
                :sram_write => 0,
                :other => 0,
                :reads => 0,
                :writes => 0,
                :fram => 0,
                :sram => 0,
                :total => 0,
            ),
            trace,
            memory_regions,
        ) for trace in event_traces
    ]
end

end
