

#include "Processor.h"

uint16_t Processor::getExtData() {
    int16_t addr = getAddress(m_program_counter++);
    return m_memory[addr];
};

void Processor::executeNextInstruction() {
    int16_t addr = getAddress(m_program_counter++);
    int16_t instruction = m_memory[addr];
    int8_t ins_high = instruction >> 8;
    int8_t ins_low = instruction & 0xFF;

    std::cout << "INS: " << static_cast<int>(ins_high) << " " << static_cast<int>(ins_low) << std::endl;

    if(ins_high & 0x80) {
        // Cannot execute kernel instructions when not in kernel mode.
        if(!(m_flags & E_PROC_FLAG_KERNEL)) throw E_PROC_ERROR_BAD_INS;

        switch(static_cast<PROC_KERN_INSTRUCTIONS>(ins_high & 0x7F))
        {
            case E_PROC_KINS_LOCK:
                m_REGS[E_PROC_REG_PAGE_STACK_SIZE] -= ins_low;
                m_REGS[ins_low] = m_pageLocks[m_REGS[E_PROC_REG_PAGE_STACK_SIZE] + 1];
            break;
            case E_PROC_KINS_UNLOCK:
                m_pageLocks[m_REGS[E_PROC_REG_PAGE_STACK_SIZE]] = ins_low;
                ++m_REGS[E_PROC_REG_PAGE_STACK_SIZE];
            break;

            case E_PROC_KINS_STACK_PUSH:
                PUSH(ins_low);
            break;
            case E_PROC_KINS_STACK_POP:
                POP(ins_low);
            break;

            case E_PROC_KINS_USR_ADDR:
                // Todo
            break;

            default: throw E_PROC_ERROR_BAD_INS;
        }
    }
    // ALU processes are just built different.
    else if(ins_high >= E_PROC_INS_ALU_LOW && ins_high <= E_PROC_INS_ALU_HIGH) {
        ALU(static_cast<PROC_INSTRUCTIONS>(ins_high), ins_low);
    }
    else {
        uint16_t _TEMP;
        switch(static_cast<PROC_INSTRUCTIONS>(ins_high))
        {
            case E_PROC_INS_RJMP:
                // Reinterpret makes this a signed operation so that jumping backwards is possible.
                m_program_counter += reinterpret_cast<char&>(ins_low);
            break;
            case E_PROC_INS_JMP:
                _TEMP = getExtData();
                if(getReg(ins_low)) m_program_counter = _TEMP;
            break;
            case E_PROC_INS_SET_LITERAL:
                setReg(ins_low, getExtData());
            break;
            case E_PROC_INS_SET_MOV:
                _TEMP = getExtData();
                if(_TEMP & 0xFF00) {
                    setReg(ins_low, getReg(_TEMP & 0xFF));
                }
                else {
                    setReg(ins_low, getReg(_TEMP & 0xFF));
                }
            break;

            case E_PROC_INS_INC:
                priv_setReg(ins_low, getReg(ins_low) + 1);
            break;
            case E_PROC_INS_DEC:
                priv_setReg(ins_low, getReg(ins_low) - 1);
            break;

            case E_PROC_INS_CALL:
                // Todo
            break;
            case E_PROC_INS_RET:
                // Todo
            break;

            case E_PROC_INS_RAISE:
                throw (ins_low & 0x3F);
            break;

            default: throw E_PROC_ERROR_BAD_INS;
        }
    }
};

// Dump internal process state for debugging and stuff.
void Processor::dumpState() {
    std::cout << std::hex << std::uppercase
        << "--------------- DUMP STATE ----------------" << std::endl;

    std::cout << "REGS:" << std::endl;
    for(int i = 0; i < 255; i ++) {
        if(m_REGS[i] != 0) {
            std::cout << "   " << i << ": " << m_REGS[i] << std::endl;
        }
    }
    
    std::cout << "INSTRUCTION_PTR: " << m_program_counter << std::endl;
    for(uint16_t i = m_program_counter; i < m_program_counter + 4; i ++) {
        std::cout << "   " << i << ": " << m_memory[i] << std::endl;
    }

    std::cout << "Flags: " << static_cast<int>(m_flags) << std::endl;

    std::cout << "V. MEM: " << std::endl;
    for(int i = 0; i < m_REGS[E_PROC_REG_PAGE_STACK_SIZE]; i ++) {
        std::cout << m_pageLocks[i] << ' ';
    }
    std::cout << std::endl;
}

void Processor::step() {
    // Execute next instruction.
    try {
        std::cout << "STEP EXECUTE INSTRUCTION" << std::endl;
        executeNextInstruction();
    }
    // Interupts
    catch(PROC_ERRORS e) {
        std::cout << "ERROR! " << e << std::endl;
        // Enter kernel mode on interupt.
        m_flags |= E_PROC_FLAG_KERNEL;

        // Attempt to recover from error
        switch(e) {
            case E_PROC_ERROR_RESET:
                reset();
            break;
            // Default for user defined interrupts.
            default:
                m_program_counter = (e << 1);
        }
    }
}

void Processor::run() {
    while(true) {
        step();
    }
};

void Processor::reset() {
    m_flags = E_PROC_FLAG_KERNEL;
    m_program_counter = 0x00;
    for(uint8_t i = 0; i < 0xFF; i ++) { m_REGS[i] = 0; }
    m_REGS[255] = 0xFF;
}

uint16_t Processor::getReg(uint8_t reg) {
    if(!(m_flags & E_PROC_FLAG_KERNEL) && !(reg & 0x80)) throw E_PROC_ERROR_MEM_ACC;
    return m_REGS[reg];
}
uint16_t Processor::priv_getReg(uint8_t reg) {
    return m_REGS[reg];
}

void Processor::setReg(uint8_t reg, uint16_t value)
{
    if(!(m_flags & E_PROC_FLAG_KERNEL) && !(reg & 0x80)) throw E_PROC_ERROR_MEM_ACC;
    priv_setReg(reg, value);
}
void Processor::priv_setReg(uint8_t reg, uint16_t value) {
    if(reg == 255) return;
    m_REGS[reg] = value;
}

void Processor::PUSH(uint8_t x) {
    if(m_REGS[E_PROC_REG_STACK_SIZE] >= 0XFF) throw E_PROC_ERROR_STACK_OVERFLOW;
    m_STACK[m_REGS[E_PROC_REG_STACK_SIZE]] = m_REGS[x];
    ++m_REGS[E_PROC_REG_STACK_SIZE];
}
void Processor::POP(uint8_t x) {
    if(m_REGS[E_PROC_REG_STACK_SIZE] == 0) throw E_PROC_ERROR_STACK_UNDERFLOW;
    priv_setReg(x, m_STACK[--m_REGS[E_PROC_REG_STACK_SIZE]]);
}

// The ALU component.
void Processor::ALU(PROC_INSTRUCTIONS opcode, uint8_t x)
{
    // Special case.
    if(opcode == E_PROC_INS_ALU_BNOT) {
        priv_setReg(x, !getReg(x)); // We can use priv here because getReg performs a memcheck
        return;
    }

    // Normal ALU operations
    if(opcode < E_PROC_INS_ALU_START_FLOAT) {
        uint16_t ext = getExtData();
        uint16_t res = getReg(ext >> 8), b = getReg(ext & 0xFF);
        switch(opcode) {
            case E_PROC_INS_ALU_ADD: res += b; break;
            case E_PROC_INS_ALU_SUB: res -= b; break;
            case E_PROC_INS_ALU_DIV: res /= b; break;
            case E_PROC_INS_ALU_MOD: res %= b; break;

            case E_PROC_INS_ALU_RSHIFT: res = res >> b; break;
            case E_PROC_INS_ALU_LSHIFT: res = res << b; break;

            case E_PROC_INS_ALU_AND: res &= b; break;
            case E_PROC_INS_ALU_OR: res |= b; break;
            case E_PROC_INS_ALU_XOR: res ^= b; break;

            case E_PROC_INS_ALU_BAND: res = res && b; break;
            case E_PROC_INS_ALU_BOR: res = res || b; break;
            case E_PROC_INS_ALU_BXOR: res = (!res) != (!b); break;

            default: throw E_PROC_ERROR_BAD_INS;
        }
        setReg(x, res);
    }
    // Special cases. output = 32 bit, inputs = 16 bit
    else if(opcode == E_PROC_INS_ALU_MUL) {
        uint16_t ext = getExtData();
        uint32_t res = getReg(ext >> 8), b = getReg(ext & 0x0F);
        res *= b;
        setReg(x, res >> 16);
        setReg(x+1, res & 0xFFFF);
    }
    else if(opcode == E_PROC_INS_ALU_DIVMOD) {
        uint16_t ext = getExtData();
        uint16_t res = getReg(ext >> 8), b = getReg(ext & 0x0F);
        uint16_t remainder = res % b;
        res /= b;
        setReg(x, res);
        setReg(x+1, remainder);
    }
    // inputs & outputs = 32 bits
    else if(opcode < E_PROC_INS_ALU_START_SINGLE) {
        uint16_t ext = getExtData();
        uint8_t r1 = ext >> 8, r2 = ext & 0x0F;
        uint32_t res = (getReg(r1) << 16) | getReg(r1+1), b = (getReg(r2) << 16) | getReg(r2+1);
        float _temp;
        switch (opcode)
        {
            case E_PROC_INS_ALU_FADD:
                _temp = reinterpret_cast<float&>(res) + reinterpret_cast<float&>(b);
                res = reinterpret_cast<uint32_t&>(_temp);
            break;
            case E_PROC_INS_ALU_FSUB:
                _temp = reinterpret_cast<float&>(res) - reinterpret_cast<float&>(b);
                res = reinterpret_cast<uint32_t&>(_temp);
            break;
            case E_PROC_INS_ALU_FMUL:
                _temp = reinterpret_cast<float&>(res) * reinterpret_cast<float&>(b);
                res = reinterpret_cast<uint32_t&>(_temp);
            break;
            case E_PROC_INS_ALU_FDIV:
                _temp = reinterpret_cast<float&>(res) / reinterpret_cast<float&>(b);
                res = reinterpret_cast<uint32_t&>(_temp);
            break;
            
            default: throw E_PROC_ERROR_BAD_INS;
        }
        setReg(x, res >> 16);
        setReg(x+1, res & 0xFFFF);
    }
    // Single register modification.
    else {
        switch(opcode) {
            case E_PROC_INS_ALU_XORI: setReg(x, x ^ getExtData()); break;
            case E_PROC_INS_ALU_ANDI: setReg(x, x & getExtData()); break;
            case E_PROC_INS_ALU_ORI: setReg(x, x | getExtData()); break;

            default: throw E_PROC_ERROR_BAD_INS;
        }
    }
}

// I journeyed to the top of the mountain seeking truth.
// At the summit I met a man with a long, flowing beard.
// And he said to me:
void Processor::load(std::istream& s) {
    char c;
    uint16_t word;
    uint32_t i = 0;
    while(s.get(c)) {
        word = ((word & 0xFF) << 8) | reinterpret_cast<unsigned char&>(c);
        m_memory[i/2] = word;
        ++i;
    }
}
// I nodded in appreciation of the beauty of his words.
// Even though in my heart I realized I had no idea what they meant.

