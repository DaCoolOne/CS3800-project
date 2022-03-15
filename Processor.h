#ifndef PROCESSOR_H
#define PROCESSOR_H

#include <iostream>
#include <iomanip>
#include <cstdint>
#include <vector>
#include "ProcessorConsts.h"

const uint16_t Processor_MEMORY_MAX_SIZE = 65535; // Max addressable by 16 bits

const uint16_t Processor_PRINT_BUFFER_SIZE = 1024;

enum PROC_FLAGS {
    E_PROC_FLAG_KERNEL = 0x1,
};

// IO ports are basically always files right?
// ... right?
struct IO_Port {
    uint32_t size;
    uint8_t * bytes;
    IO_Port(): bytes(nullptr) {}
};

class Processor {
    uint16_t m_program_counter = 0;
    
    bool m_running = true;

    std::vector<IO_Port> m_ports;

    uint16_t m_REGS[256]; // Registers.

    uint16_t m_STACK[256]; // Function stack.

    uint16_t m_pageLocks[256];

    uint16_t m_memory[Processor_MEMORY_MAX_SIZE]; // Memory.

    uint8_t m_flags = 0;

    char m_printBuffer[Processor_PRINT_BUFFER_SIZE+1];
    uint16_t printSize = 0;

    // Gets the address at addr
    uint16_t getUsrAddr(uint16_t addr) {
        if((addr >> 8) >= m_REGS[E_PROC_REG_PAGE_STACK_SIZE]) throw E_PROC_ERROR_MEM_ACC;
        return (m_pageLocks[addr >> 8] << 8) | addr & 0xFF;
    }
    uint16_t getAddress(uint16_t addr) {
        if(m_flags & E_PROC_FLAG_KERNEL) {
            return addr;
        }
        else {
            return getUsrAddr(addr);
        }
    }

    uint16_t getExtData();
    void executeNextInstruction();

    void addPort(IO_Port& port);

    void UNLOCK(uint8_t x);
    void LOCK(uint8_t x);

    void PUSH(uint8_t x);
    void POP(uint8_t x);

    void stackPush(uint16_t x);
    uint16_t stackPop();

    uint16_t getReg(uint8_t reg);
    void setReg(uint8_t reg, uint16_t value);

    uint16_t priv_getReg(uint8_t reg);
    void priv_setReg(uint8_t reg, uint16_t value);
    void setALUFlag(bool value, uint8_t bit);
    
    void ALU(PROC_INSTRUCTIONS opcode, uint8_t x);
    void reset();

    void printAppend(char c);
    void printFlush();

    void interrupt(PROC_ERRORS err);

public:
    bool isRunning() { return m_running; }
    void dumpState();
    void step();
    void run();
    void load(std::istream& s);
    void newPort(std::string fname);
    Processor() { reset(); }
    ~Processor() {
        for(auto p : m_ports) {
            delete[] p.bytes;
        }
    }
};

#endif