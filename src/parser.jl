# parser.jl - ARM assembly parser

"""
Parse a simple ARM assembly string into instruction objects
"""
function parse_arm_assembly(asm_lines::Vector{String})::Vector{ARMInstruction}
    instructions = ARMInstruction[]

    for line in asm_lines
        inst = parse_line(line)
        if !isnothing(inst)
            push!(instructions, inst)
        end
    end

    return instructions
end

"""
Parse a single line of assembly
"""
function parse_line(line::String)::Union{ARMInstruction,Nothing}
    # Remove comments and trim
    line = strip(split(line, ";")[1])
    isempty(line) && return nothing

    parts = split(line)
    opcode = Symbol(lowercase(parts[1]))

    # Parse operands
    operands = []
    if length(parts) > 1
        op_str = join(parts[2:end], " ")
        operands = parse_operands(op_str)
    end

    return ARMInstruction(opcode, operands)
end

"""
Parse operand string into structured operands
"""
function parse_operands(op_str::String)::Vector{Any}
    operands = []
    op_parts = split(op_str, ",")

    for op in op_parts
        op = strip(op)

        # Check if it's a memory operand [reg]
        if startswith(op, "[") && endswith(op, "]")
            # Extract register name from brackets
            reg_name = strip(op[2:end-1])
            push!(operands, Symbol(reg_name))
        elseif startswith(op, "#")
            # Immediate value
            push!(operands, parse(Int, op[2:end]))
        else
            # Register or label
            push!(operands, Symbol(op))
        end
    end

    return operands
end

"""
Parse assembly from a file
"""
function parse_arm_file(filename::String)::Vector{ARMInstruction}
    lines = readlines(filename)
    return parse_arm_assembly(lines)
end