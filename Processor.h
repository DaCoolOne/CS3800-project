#ifndef PROCESSOR_H
#define PROCESSOR_H

#include <iostream>
#include <iomanip>
#include <cstdint>
#include "ProcessorConsts.h"

const uint16_t Processor_MEMORY_MAX_SIZE = 65535; // Max addressable by 16 bits

enum PROC_FLAGS {
    E_PROC_FLAG_KERNEL = 0x1,
};

class Processor {
    uint16_t m_program_counter = 0;

    uint16_t m_REGS[256]; // Registers.

    uint16_t m_STACK[256]; // Function stack.

    uint16_t m_pageLocks[256];

    uint16_t m_memory[Processor_MEMORY_MAX_SIZE]; // Memory.

    uint8_t m_flags = 0;

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

    void UNLOCK(uint8_t x);
    void LOCK(uint8_t x);

    void PUSH(uint8_t x);
    void POP(uint8_t x);

    uint16_t getReg(uint8_t reg);
    void setReg(uint8_t reg, uint16_t value);

    uint16_t priv_getReg(uint8_t reg);
    void priv_setReg(uint8_t reg, uint16_t value);
    
    void ALU(PROC_INSTRUCTIONS opcode, uint8_t x);
    void reset();

public:
    void dumpState();
    void step();
    void run();
    void load(std::istream& s);
    Processor() { reset(); }
};

#endif