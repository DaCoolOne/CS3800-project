

#include "LispInterp.h"
#include <stdexcept>

void LispInterp::stackPush(uint32_t newVal) {
    if(m_stackSize >= MAX_STACK_SIZE) throw std::range_error("STACK OVERFLOW");
    m_stack[m_stackSize++] = newVal;
}

uint32_t LispInterp::stackPop() {
    if(m_stackSize <= 0) throw std::range_error("STACK UNDERFLOW");
    return m_stack[--m_stackSize];
}



