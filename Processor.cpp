

#include <fstream>
#include "Processor.h"

uint16_t Processor::getExtData() {
    int16_t addr = getAddress(m_program_counter++);
    return m_memory[addr];
};

void Processor::executeNextInstruction() {
    uint16_t addr = getAddress(m_program_counter++);
    uint16_t instruction = m_memory[addr];
    uint8_t ins_high = instruction >> 8;
    uint8_t ins_low = instruction & 0xFF;

    if(ins_high & 0x80) {
        // Cannot execute kernel instructions when not in kernel mode.
        if(!(m_flags & E_PROC_FLAG_KERNEL)) throw E_PROC_ERROR_BAD_INS;

        uint16_t y, z;
        uint16_t _temp;
        uint32_t _temp32;
        switch(static_cast<PROC_KERN_INSTRUCTIONS>(ins_high))
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

            case E_PROC_KINS_EXTFETCH:
                _temp = getExtData();
                y = m_REGS[(_temp >> 8) & 0xFF], z = m_REGS[_temp & 0xFF];
                if(m_REGS[ins_low] >= m_ports.size()) interrupt(E_PROC_ERROR_FAILED_EXT_ACCESS);
                _temp32 = (y << 16) | z;
                if(_temp32 >= m_ports[m_REGS[ins_low]].size) interrupt(E_PROC_ERROR_FAILED_EXT_ACCESS);
                m_REGS[E_PROC_REG_EXT_IN] = m_ports.at(m_REGS[ins_low]).bytes[_temp32];
            break;
            case E_PROC_KINS_EXTWRITE:
                _temp = getExtData();
                y = m_REGS[(_temp >> 8) & 0xFF], z = m_REGS[_temp & 0xFF];
                if(m_REGS[ins_low] >= m_ports.size()) interrupt(E_PROC_ERROR_FAILED_EXT_ACCESS);
                _temp32 = (y << 16) & z;
                if(_temp32 >= m_ports[m_REGS[ins_low]].size) interrupt(E_PROC_ERROR_FAILED_EXT_ACCESS);
                m_ports[m_REGS[ins_low]].bytes[_temp32] = m_REGS[E_PROC_REG_EXT_OUT];
            break;

            case E_PROC_KINS_SHUTDOWN:
                m_running = false;
            break;

            case E_PROC_KINS_PRINTL:
                _temp = m_REGS[ins_low] & 0xFF;
                printAppend(reinterpret_cast<char&>(_temp));
            break;
            case E_PROC_KINS_PRINTH:
                _temp = (m_REGS[ins_low] >> 8) & 0xFF;
                printAppend(reinterpret_cast<char&>(_temp));
            break;
            case E_PROC_KINS_PRINTFLUSH:
                printFlush();
            break;

            default: interrupt(E_PROC_ERROR_BAD_INS);
        }
    }
    // ALU processes are just built different.
    else if(ins_high >= E_PROC_INS_ALU_LOW && ins_high <= E_PROC_INS_ALU_HIGH) {
        ALU(static_cast<PROC_INSTRUCTIONS>(ins_high), ins_low);
    }
    else {
        uint16_t _TEMP;
        uint16_t reg1, reg2;
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
                    reg1 = getReg(_TEMP & 0xFF);
                    reg2 = getReg(ins_low);
                    priv_setReg(ins_low, reg1);
                    priv_setReg(_TEMP & 0xFF, reg2);
                }
                else {
                    setReg(ins_low, getReg(_TEMP & 0xFF));
                }
            break;

            case E_PROC_INS_INC:
                _TEMP = getReg(ins_low);
                priv_setReg(ins_low, ++_TEMP);
                setALUFlag(_TEMP == 0x00, E_PROC_ALU_FLAG_OVERFLOW);
            break;
            case E_PROC_INS_DEC:
                _TEMP = getReg(ins_low);
                priv_setReg(ins_low, --_TEMP);
                setALUFlag(_TEMP == 0xFFFF, E_PROC_ALU_FLAG_OVERFLOW);
            break;

            case E_PROC_INS_CALL:
                _TEMP = getExtData();
                stackPush(m_program_counter);
                m_program_counter = _TEMP;
            break;
            case E_PROC_INS_RET:
                m_program_counter = stackPop();
            break;

            case E_PROC_INS_LD:
                reg1 = getReg(ins_low);
                priv_setReg(ins_low, m_memory[getAddress(reg1)]);
            break;

            case E_PROC_INS_RAISE:
                throw (ins_low & 0x3F) + 1;
            break;

            default: interrupt(E_PROC_ERROR_BAD_INS);
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
        executeNextInstruction();
    }
    // Interupts
    catch(PROC_ERRORS e) {
        if(e == E_PROC_ERROR_BAD_INS) {
            std::cout << "BAD INS! " << e << std::endl;
        }
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
    while(m_running) {
        step();
    }
};

void Processor::reset() {
    m_flags = E_PROC_FLAG_KERNEL;
    m_program_counter = 0x00;
    for(uint8_t i = 0; i < 0xFF; i ++) { m_REGS[i] = 0; }
    m_REGS[255] = 0xFF;
    m_REGS[E_PROC_REG_NUM_PORT] = m_ports.size();
}

uint16_t Processor::getReg(uint8_t reg) {
    if(!(m_flags & E_PROC_FLAG_KERNEL) && !(reg & 0x80)) interrupt(E_PROC_ERROR_MEM_ACC);
    return m_REGS[reg];
}
uint16_t Processor::priv_getReg(uint8_t reg) {
    return m_REGS[reg];
}

void Processor::setReg(uint8_t reg, uint16_t value)
{
    if(!(m_flags & E_PROC_FLAG_KERNEL) && !(reg & 0x80)) interrupt(E_PROC_ERROR_MEM_ACC);
    priv_setReg(reg, value);
}
void Processor::priv_setReg(uint8_t reg, uint16_t value) {
    if(reg == 255) return;
    m_REGS[reg] = value;
}
void Processor::setALUFlag(bool value, uint8_t bit) {
    if(value) {
        m_REGS[E_PROC_REG_ALU_STATUS] |= (1 << bit);
    }
    else {
        m_REGS[E_PROC_REG_ALU_STATUS] &= ~(1 << bit);
    }
}

void Processor::printFlush() {
    m_printBuffer[printSize++] = '\0';
    std::cout << m_printBuffer << std::flush;
    printSize = 0;
}
void Processor::printAppend(char c) {
    m_printBuffer[printSize++] = c;
    if(c == '\n' || printSize >= Processor_PRINT_BUFFER_SIZE) printFlush();
}

void Processor::stackPush(uint16_t x) {
    if(m_REGS[E_PROC_REG_STACK_SIZE] >= 0XFF) interrupt(E_PROC_ERROR_STACK_OVERFLOW);
    m_STACK[m_REGS[E_PROC_REG_STACK_SIZE]] = x;
    ++m_REGS[E_PROC_REG_STACK_SIZE];
}
uint16_t Processor::stackPop() {
    if(m_REGS[E_PROC_REG_STACK_SIZE] == 0) interrupt(E_PROC_ERROR_STACK_UNDERFLOW);
    return m_STACK[--m_REGS[E_PROC_REG_STACK_SIZE]];
}

void Processor::PUSH(uint8_t x) {
    stackPush(m_REGS[x]);
}
void Processor::POP(uint8_t x) {
    priv_setReg(x, stackPop());
}

// The ALU component.
void Processor::ALU(PROC_INSTRUCTIONS opcode, uint8_t x)
{
    priv_setReg(E_PROC_REG_ALU_STATUS, 0x00);

    // Special case.
    if(opcode == E_PROC_INS_ALU_BNOT) {
        priv_setReg(x, !getReg(x)); // We can use priv here because getReg performs a memcheck
        return;
    }

    // Normal ALU operations
    if(opcode < E_PROC_INS_ALU_START_FLOAT) {
        uint16_t ext = getExtData();
        uint16_t a = getReg(ext >> 8), b = getReg(ext & 0xFF);
        uint16_t res;
        switch(opcode) {
            case E_PROC_INS_ALU_ADD: res = a + b; break;
            case E_PROC_INS_ALU_SUB: res = a - b; break;
            case E_PROC_INS_ALU_DIV: res = a / b; break;
            case E_PROC_INS_ALU_MOD: res = a % b; break;

            case E_PROC_INS_ALU_RSHIFT: res = a >> b; break;
            case E_PROC_INS_ALU_LSHIFT: res = a << b; break;

            case E_PROC_INS_ALU_AND: res = a & b; break;
            case E_PROC_INS_ALU_OR: res = a | b; break;
            case E_PROC_INS_ALU_XOR: res = a ^ b; break;

            case E_PROC_INS_ALU_BAND: res = a && b; break;
            case E_PROC_INS_ALU_BOR: res = a || b; break;
            case E_PROC_INS_ALU_BXOR: res = (!a) != (!b); break;

            case E_PROC_INS_ALU_EQ: res = a == b; break;
            case E_PROC_INS_ALU_GTR: res = a > b; break;
            case E_PROC_INS_ALU_GTEQ: res = a >= b; break;

            default: interrupt(E_PROC_ERROR_BAD_INS);
        }
        setALUFlag((res & 0x80 != a & 0x80) && (a & 0x80 == b & 0x80), E_PROC_ALU_FLAG_OVERFLOW);
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
            
            default: interrupt(E_PROC_ERROR_BAD_INS);
        }
        setReg(x, res >> 16);
        setReg(x+1, res & 0xFFFF);
    }
    // Single register modification.
    else {
        uint16_t a = getReg(x), b = getExtData();
        switch(opcode) {
            case E_PROC_INS_ALU_XORI: priv_setReg(x, a ^ b); break;
            case E_PROC_INS_ALU_ANDI: priv_setReg(x, a & b); break;
            case E_PROC_INS_ALU_ORI: priv_setReg(x, a | b); break;

            case E_PROC_INS_ALU_EQI: priv_setReg(x, a == b); break;
            case E_PROC_INS_ALU_GTRI: priv_setReg(
                x, reinterpret_cast<int16_t&>(a) > reinterpret_cast<int16_t&>(b)); break;
            case E_PROC_INS_ALU_GTEQI: priv_setReg(
                x, reinterpret_cast<int16_t&>(a) >= reinterpret_cast<int16_t&>(b)); break;
            case E_PROC_INS_ALU_LSEQI: priv_setReg(
                x, reinterpret_cast<int16_t&>(a) <= reinterpret_cast<int16_t&>(b)); break;
            case E_PROC_INS_ALU_LSSI: priv_setReg(
                x, reinterpret_cast<int16_t&>(a) < reinterpret_cast<int16_t&>(b)); break;

            default: interrupt(E_PROC_ERROR_BAD_INS);
        }
    }
}

void Processor::interrupt(PROC_ERRORS err) {
    stackPush(m_program_counter);
    throw err;
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


// Stackoverflow : https://stackoverflow.com/questions/5840148/how-can-i-get-a-files-size-in-c
#include <sys/stat.h>
long GetFileSize(std::string filename)
{
    struct stat stat_buf;
    int rc = stat(filename.c_str(), &stat_buf);
    return rc == 0 ? stat_buf.st_size : -1;
}

// Load a file as an io port.
void Processor::newPort(std::string fname) {
    long fsize = GetFileSize(fname);
    if(fsize < 0 || fsize >= 0xFFFFFFFF) throw E_PROC_ERROR_FAILED_EXT_ACCESS;
    IO_Port a;
    a.size = fsize;
    a.bytes = new uint8_t[a.size];
    std::ifstream data(fname, std::ios::binary);
    char c;
    uint32_t i = 0;
    while(data.get(c)) {
        a.bytes[i] = reinterpret_cast<uint8_t&>(c);
        ++i;
    }
    addPort(a);
    data.close();
}

void Processor::addPort(IO_Port& port) {
    m_ports.push_back(port);
    m_REGS[E_PROC_REG_NUM_PORT] = m_ports.size();
}

