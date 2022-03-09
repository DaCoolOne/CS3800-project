#ifndef LISP_INTERP
#define LISP_INTERP

#include <cstdint>

const uint32_t MAX_STACK_SIZE = 255;

class LISP_KERNEL {
    
};

class LispInterp {
    char* m_mem;
    uint32_t m_currentChar;
    
    uint32_t m_maxBound;

    uint32_t m_stack[MAX_STACK_SIZE];
    uint32_t m_stackSize;

    void stackPush(uint32_t newVal);
    uint32_t stackPop();

public:
    LispInterp(char* mem, uint32_t memStart, uint32_t memEnd):
        m_currentChar(memStart), m_maxBound(memEnd), m_mem(mem), m_stackSize(0) {}
};

#endif