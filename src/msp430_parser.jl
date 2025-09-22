# msp430_parser.jl - MSP430 assembly parser

"""
Parse MSP430 assembly string into instruction objects
"""
function parse_msp430_assembly(asm_lines::Vector{String})
    instructions = MSP430Instruction[]

    for line in asm_lines
        inst = parse_msp430_line(line)
        if !isnothing(inst)
            push!(instructions, inst)
        end
    end

    return instructions
end

"""
Parse a single line of MSP430 assembly
"""
function parse_msp430_line(line::String)
    # Remove comments and trim
    line = strip(split(line, ";")[1])
    isempty(line) && return nothing

    # Skip labels (lines ending with :)
    if endswith(line, ":")
        return nothing
    end

    parts = split(line)
    opcode = Symbol(lowercase(parts[1]))

    # Parse operands
    operands = []
    addressing_mode = :register  # Default addressing mode

    if length(parts) > 1
        op_str = join(parts[2:end], " ")
        operands, addressing_mode = parse_msp430_operands(op_str)
    end

    return MSP430Instruction(opcode, operands, addressing_mode)
end

"""
Parse MSP430 operand string into structured operands with addressing modes
"""
function parse_msp430_operands(op_str::String)
    operands = []
    addressing_mode = :register
    op_parts = split(op_str, ",")

    for op in op_parts
        op = strip(op)

        if startswith(op, "#")
            # Immediate addressing mode: #value
            value_str = strip(op[2:end])
            if startswith(value_str, "0x") || startswith(value_str, "0X")
                # Hexadecimal
                push!(operands, parse(UInt16, value_str[3:end], base=16))
            else
                # Decimal
                push!(operands, parse(UInt16, value_str))
            end
            addressing_mode = :immediate

        elseif startswith(op, "@")
            # Indirect register mode: @Rn
            reg_name = uppercase(strip(op[2:end]))
            indirect_symbol = Symbol("@" * reg_name)
            push!(operands, indirect_symbol)
            addressing_mode = :indirect

        elseif contains(op, "(") && contains(op, ")")
            # Indexed mode: offset(Rn)
            paren_idx = findfirst('(', op)
            offset_str = strip(op[1:paren_idx-1])
            reg_part = strip(op[paren_idx+1:end-1])

            # Parse offset
            if startswith(offset_str, "0x") || startswith(offset_str, "0X")
                offset = parse(UInt16, offset_str[3:end], base=16)
            else
                offset = parse(UInt16, offset_str)
            end

            reg_name = Symbol(uppercase(reg_part))
            push!(operands, (offset, reg_name))  # Store as tuple
            addressing_mode = :indexed

        elseif startswith(op, "&")
            # Absolute addressing: &address
            addr_str = strip(op[2:end])
            if startswith(addr_str, "0x") || startswith(addr_str, "0X")
                addr = parse(UInt16, addr_str[3:end], base=16)
            else
                addr = parse(UInt16, addr_str)
            end
            push!(operands, addr)
            addressing_mode = :absolute

        else
            # Register mode: Rn or register name
            reg_name = Symbol(uppercase(op))
            push!(operands, reg_name)
            addressing_mode = :register
        end
    end

    return operands, addressing_mode
end

"""
Parse MSP430 assembly from a file
"""
function parse_msp430_file(filename::String)
    lines = readlines(filename)
    return parse_msp430_assembly(lines)
end

"""
Convert register number to register symbol (R0-R15)
"""
function reg_num_to_symbol(reg_num::Int)
    if 0 <= reg_num <= 15
        return Symbol("R$reg_num")
    else
        throw(ArgumentError("Invalid register number: $reg_num"))
    end
end

"""
Convert register symbol to register number
"""
function reg_symbol_to_num(reg_sym::Symbol)
    reg_str = string(reg_sym)
    if startswith(reg_str, "R") && length(reg_str) >= 2
        num_str = reg_str[2:end]
        try
            reg_num = parse(Int, num_str)
            if 0 <= reg_num <= 15
                return reg_num
            end
        catch
            # Handle named registers
            if reg_sym == :PC
                return 0
            elseif reg_sym == :SP
                return 1
            elseif reg_sym == :SR
                return 2
            elseif reg_sym == :CG2
                return 3
            end
        end
    end
    throw(ArgumentError("Invalid register symbol: $reg_sym"))
end

"""
Identify MSP430 instruction format
"""
function get_instruction_format(opcode::Symbol)
    # Dual-operand instructions (Format I)
    dual_operand = [:mov, :add, :addc, :sub, :subc, :cmp, :dadd, :bit, :bic, :bis, :xor, :and]

    # Single-operand instructions (Format II)
    single_operand = [:rrc, :swpb, :rra, :sxt, :push, :call, :reti]

    # Jump instructions (Format III)
    jump_instructions = [:jnz, :jz, :jnc, :jc, :jn, :jge, :jl, :jmp]

    if opcode in dual_operand
        return :dual_operand
    elseif opcode in single_operand
        return :single_operand
    elseif opcode in jump_instructions
        return :jump
    else
        return :unknown
    end
end

"""
Validate MSP430 instruction operands
"""
function validate_msp430_instruction(inst::MSP430Instruction)
    format = get_instruction_format(inst.opcode)

    if format == :dual_operand
        return length(inst.operands) == 2
    elseif format == :single_operand
        return length(inst.operands) == 1
    elseif format == :jump
        return length(inst.operands) == 1
    else
        return false
    end
end