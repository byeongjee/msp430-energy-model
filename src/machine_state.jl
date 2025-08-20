# machine_state.jl - Machine state management and instruction execution

"""
Initialize a new machine state
"""
function MachineState()
    registers = Dict(Symbol("r$i") => 0 for i in 0:15)
    registers[:sp] = 0x10000  # Stack pointer
    registers[:lr] = 0        # Link register
    registers[:pc] = 0        # Program counter

    MachineState(
        registers,
        Dict{Int64,Int64}(),
        0,
        Dict(:N => false, :Z => false, :C => false, :V => false)
    )
end

"""
Execute an instruction and update machine state (side effects)
"""
function execute_instruction!(state::MachineState, inst::ARMInstruction)
    opcode = inst.opcode
    ops = inst.operands

    if opcode == :mov && length(ops) == 2
        execute_mov!(state, ops)
    elseif opcode == :add && length(ops) == 3
        execute_add!(state, ops)
    elseif opcode == :sub && length(ops) == 3
        execute_sub!(state, ops)
    elseif opcode == :mul && length(ops) == 3
        execute_mul!(state, ops)
    elseif opcode == :ldr && length(ops) == 2
        execute_ldr!(state, ops)
    elseif opcode == :str && length(ops) == 2
        execute_str!(state, ops)
    elseif opcode == :cmp && length(ops) == 2
        execute_cmp!(state, ops)
    elseif opcode == :b
        # Branch - placeholder
    elseif opcode == :nop
        # No operation
    end

    state.pc += 4  # ARM instructions are 4 bytes
end

# Individual instruction implementations
function execute_mov!(state::MachineState, ops)
    dest, src = ops
    if isa(src, Symbol)
        state.registers[dest] = state.registers[src]
    else
        state.registers[dest] = src
    end
end

function execute_add!(state::MachineState, ops)
    dest, src1, src2 = ops
    val1 = state.registers[src1]
    val2 = isa(src2, Symbol) ? state.registers[src2] : src2
    state.registers[dest] = val1 + val2
end

function execute_sub!(state::MachineState, ops)
    dest, src1, src2 = ops
    val1 = state.registers[src1]
    val2 = isa(src2, Symbol) ? state.registers[src2] : src2
    state.registers[dest] = val1 - val2
end

function execute_mul!(state::MachineState, ops)
    dest, src1, src2 = ops
    val1 = state.registers[src1]
    val2 = state.registers[src2]
    state.registers[dest] = val1 * val2
end

function execute_ldr!(state::MachineState, ops)
    dest, addr_reg = ops
    addr = state.registers[addr_reg]
    state.registers[dest] = get(state.memory, addr, 0)
end

function execute_str!(state::MachineState, ops)
    src, addr_reg = ops
    addr = state.registers[addr_reg]
    state.memory[addr] = state.registers[src]
end

function execute_cmp!(state::MachineState, ops)
    src1, src2 = ops
    val1 = state.registers[src1]
    val2 = isa(src2, Symbol) ? state.registers[src2] : src2
    result = val1 - val2
    state.flags[:Z] = (result == 0)
    state.flags[:N] = (result < 0)
end