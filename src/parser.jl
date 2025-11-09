# parser.jl - MSP430 assembly parser module

module Parser

using ..Types: Instruction, Operand

export parse_line, find_functions

"""
Parse MSP430 assembly string into instruction objects
"""
function parse_assembly(
    asm_lines::Vector{String}, start_addr::UInt16=UInt16(0x4000)
)::Vector{Instruction}
    instructions = Instruction[]
    current_addr = start_addr

    for line in asm_lines
        inst = parse_line(line, current_addr)
        if !isnothing(inst)
            push!(instructions, inst)
            current_addr += 2  # Assume 2-byte instructions for demo purposes
        end
    end

    return instructions
end

"""
Parse a single line of MSP430 assembly
"""
function parse_line(line::String, current_addr::UInt16)::Union{Instruction,Nothing}
    # Remove comments and trim
    line = strip(split(line, ";")[1])
    isempty(line) && return nothing

    # Skip labels (lines ending with :)
    if endswith(line, ":")
        return nothing
    end

    parts = split(line)

    # Parse opcode and data size suffix
    opcode_str = lowercase(parts[1])
    data_size = :word  # default

    if contains(opcode_str, ".")
        opcode_parts = split(opcode_str, ".")
        opcode_str = opcode_parts[1]
        suffix = opcode_parts[2]
        if suffix == "b"
            data_size = :byte
        elseif suffix == "w"
            data_size = :word
        end
    end

    opcode = Symbol(opcode_str)

    # Parse operands
    operands = Operand[]

    if length(parts) > 1
        op_str = join(parts[2:end], " ")
        operands = parse_operands(op_str, current_addr)
    end

    return Instruction(opcode, operands, data_size)
end

"""
Parse MSP430 operand string into structured operands with addressing modes
"""
function parse_operands(op_str::String, current_addr::UInt16)::Vector{Operand}
    operands = Operand[]
    op_parts = split(op_str, ",")

    for op in op_parts
        op = strip(op)

        if startswith(op, "#")
            # Immediate addressing mode: #value
            value_str = strip(op[2:end])
            value = if startswith(value_str, "0x") || startswith(value_str, "0X")
                # Hexadecimal
                parse(UInt16, value_str[3:end]; base=16)
            else
                # Decimal (may be negative)
                int_val = parse(Int16, value_str)
                # Convert to UInt16 representation (two's complement)
                reinterpret(UInt16, int_val)
            end
            push!(operands, Operand(value, :immediate))

        elseif startswith(op, "@")
            # Indirect register mode: @Rn or autoincrement mode: @Rn+
            reg_str = strip(op[2:end])  # Remove @ prefix

            if endswith(reg_str, "+")
                # Autoincrement mode: @Rn+
                reg_str = reg_str[1:end-1]  # Remove + suffix
                reg_name = normalize_register_name(Symbol(uppercase(reg_str)))
                indirect_symbol = Symbol("@" * string(reg_name))
                push!(operands, Operand(indirect_symbol, :autoincrement))
            else
                # Indirect mode: @Rn
                reg_name = normalize_register_name(Symbol(uppercase(reg_str)))
                indirect_symbol = Symbol("@" * string(reg_name))
                push!(operands, Operand(indirect_symbol, :indirect))
            end

        elseif contains(op, "(") && contains(op, ")")
            # Indexed mode: offset(Rn) or Symbolic mode: offset(PC)
            paren_idx = findfirst('(', op)
            offset_str = strip(op[1:(paren_idx - 1)])
            reg_part = strip(op[(paren_idx + 1):(end - 1)])

            # Parse offset (may be negative)
            offset = if startswith(offset_str, "0x") || startswith(offset_str, "0X")
                parse(UInt16, offset_str[3:end]; base=16)
            else
                # Parse as signed integer first, then convert to UInt16 representation
                int_offset = parse(Int16, offset_str)
                reinterpret(UInt16, int_offset)
            end

            reg_name = normalize_register_name(Symbol(uppercase(reg_part)))

            # Symbolic mode is indexed mode with PC as base register: X(PC)
            addressing_mode = (reg_name == :PC) ? :symbolic : :indexed
            push!(operands, Operand((offset, reg_name), addressing_mode))

        elseif startswith(op, "&")
            # Absolute addressing: &address
            addr_str = strip(op[2:end])
            addr = if startswith(addr_str, "0x") || startswith(addr_str, "0X")
                parse(UInt16, addr_str[3:end]; base=16)
            else
                parse(UInt16, addr_str)
            end
            push!(operands, Operand(addr, :absolute))

        elseif startswith(op, "\$")
            # Jump offset: $+0, $-2, etc.
            # MSP430 jumps use symbolic (PC-relative) addressing
            # Target = PC + 2 + (offset * 2)
            # So for $+N: we want current_addr + N = PC + 2 + (offset * 2)
            # Therefore: offset = (current_addr + N - PC - 2) / 2
            # Since PC will be current_addr when executing: offset = (N - 2) / 2
            offset_str = strip(op[2:end])  # Remove $ prefix
            byte_offset = if startswith(offset_str, "+")
                parse(Int16, offset_str[2:end])  # Remove + and parse
            else
                parse(Int16, offset_str)  # Parse number directly
            end
            # Convert to MSP430 word offset
            word_offset = div(byte_offset - 2, 2)
            # Store as tuple (offset, PC) for consistency with X(PC) symbolic mode
            push!(operands, Operand((word_offset, :PC), :symbolic))

        elseif startswith(op, "0x") || startswith(op, "0X")
            # Bare hex address without prefix = Symbolic (PC-relative) addressing
            # Example: add 0xdbc0, r12  (objdump shows this for symbolic mode)
            # This is different from &0x1c00 which is absolute addressing
            offset = parse(UInt16, op[3:end]; base=16)
            push!(operands, Operand((offset, :PC), :symbolic))

        else
            # Register mode: Rn or register name
            reg_name = normalize_register_name(Symbol(uppercase(op)))
            push!(operands, Operand(reg_name, :register))
        end
    end

    return operands
end

"""
Parse MSP430 assembly from a file
"""
function parse_file(filename::String)::Vector{Instruction}
    lines = readlines(filename)
    return parse_assembly(lines)
end

"""
Normalize register name: convert R0/R1/R2 to PC/SP/SR
"""
function normalize_register_name(reg_sym::Symbol)::Symbol
    if reg_sym == :R0
        return :PC
    elseif reg_sym == :R1
        return :SP
    elseif reg_sym == :R2
        return :SR
    else
        return reg_sym
    end
end

"""
Convert register number to register symbol
R0 -> PC, R1 -> SP, R2 -> SR, R3-R15 -> R3-R15
"""
function reg_num_to_symbol(reg_num::Int)::Symbol
    if reg_num == 0
        return :PC
    elseif reg_num == 1
        return :SP
    elseif reg_num == 2
        return :SR
    elseif 3 <= reg_num <= 15
        return Symbol("R$reg_num")
    else
        throw(ArgumentError("Invalid register number: $reg_num"))
    end
end

"""
Convert register symbol to register number
"""
function reg_symbol_to_num(reg_sym::Symbol)::Int
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
function get_instruction_format(opcode::Symbol)::Symbol
    # Dual-operand instructions (Format I)
    dual_operand = [
        :mov, :add, :addc, :sub, :subc, :cmp, :dadd, :bit, :bic, :bis, :xor, :and
    ]

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
function validate_instruction(inst::Instruction)::Bool
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

"""
Find all functions in an assembly file
Returns a dictionary mapping function names to their addresses
"""
function find_functions(filename::String)::Dict{String,UInt16}
    if !isfile(filename)
        error("Assembly file not found: $filename")
    end

    lines = readlines(filename)
    functions = Dict{String,UInt16}()

    for line in lines
        line = strip(line)

        # Look for function labels like "00004400 <function_name>:"
        match_result = match(r"^([0-9a-fA-F]{8})\s+<([^>]+)>:", line)

        if match_result !== nothing
            addr_str = match_result.captures[1]
            func_name = match_result.captures[2]

            # Parse address (take lower 16 bits for MSP430)
            addr = parse(UInt16, addr_str[5:8]; base=16)
            functions[func_name] = addr
        end
    end

    return functions
end

end # module Parser
