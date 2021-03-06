#ifndef ProcessorConsts
#define ProcessorConsts

enum PROC_ERRORS {
    E_PROC_ERROR_RESET,
    E_PROC_TIMER_TICK,
    E_PROC_ERROR_MEM_ACC,
    E_PROC_ERROR_STACK_OVERFLOW,
    E_PROC_ERROR_STACK_UNDERFLOW,
    E_PROC_ERROR_BAD_INS,
    E_PROC_ERROR_FAILED_EXT_ACCESS,
};

enum PROC_INSTRUCTIONS {
    E_PROC_INS_RJMP,
    E_PROC_INS_JMP,
    E_PROC_INS_SET_LITERAL,
    E_PROC_INS_SET_MOV,

    E_PROC_INS_CALL,
    E_PROC_INS_RET,

    E_PROC_INS_INC,
    E_PROC_INS_DEC,
    
    E_PROC_INS_LD,
    E_PROC_INS_ST,

    E_PROC_INS_RETI = 0x15,

    E_PROC_INS_RAISE = 0x3F,

    E_PROC_INS_ALU_LOW = 0x40,

    E_PROC_INS_ALU_ADD = 0x40, // 0100 0000
    E_PROC_INS_ALU_SUB = 0x41,
    E_PROC_INS_ALU_LMUL = 0x42,
    E_PROC_INS_ALU_DIV = 0x43,
    E_PROC_INS_ALU_LSHIFT = 0x44,
    E_PROC_INS_ALU_RSHIFT = 0x45,
    E_PROC_INS_ALU_AND = 0x46,
    E_PROC_INS_ALU_OR = 0x47,
    E_PROC_INS_ALU_XOR = 0x48,
    E_PROC_INS_ALU_BAND = 0x49,
    E_PROC_INS_ALU_BOR = 0x4A,
    E_PROC_INS_ALU_BXOR = 0x4B,
    E_PROC_INS_ALU_MOD = 0x4C,
    E_PROC_INS_ALU_GTR = 0x4D,
    E_PROC_INS_ALU_EQ = 0x4E,
    E_PROC_INS_ALU_GTEQ = 0x4F,

    E_PROC_INS_ALU_START_FLOAT = 0x60,

    E_PROC_INS_ALU_FADD = 0x60, // 0110 0000
    E_PROC_INS_ALU_FSUB = 0x61,
    E_PROC_INS_ALU_MUL = 0x62,
    E_PROC_INS_ALU_FMUL = 0x63,
    E_PROC_INS_ALU_FDIV = 0x64,
    E_PROC_INS_ALU_DIVMOD = 0x65,

    E_PROC_INS_ALU_START_SINGLE = 0x60,

    E_PROC_INS_ALU_XORI = 0x70, // 0111 0000
    E_PROC_INS_ALU_ANDI = 0x71,
    E_PROC_INS_ALU_ORI = 0x72,
    E_PROC_INS_ALU_BNOT = 0x73,
    E_PROC_INS_ALU_EQI = 0x74,
    E_PROC_INS_ALU_GTRI = 0x75,
    E_PROC_INS_ALU_GTEQI = 0x76,
    E_PROC_INS_ALU_LSSI = 0x77,
    E_PROC_INS_ALU_LSEQI = 0x78,
    E_PROC_INS_ALU_RSHIFTI = 0x79,
    E_PROC_INS_ALU_LSHIFTI = 0x7A,
    E_PROC_INS_ALU_ADDI = 0x7B,

    E_PROC_INS_ALU_HIGH = 0x7F,
    
};

enum PROC_KERN_INSTRUCTIONS {
    E_PROC_KINS_LOCK = 0x80,
    E_PROC_KINS_UNLOCK,
    E_PROC_KINS_STACK_PUSH,
    E_PROC_KINS_STACK_POP,

    E_PROC_KINS_USR_ADDR,
    
    E_PROC_KINS_EXTFETCH,
    E_PROC_KINS_EXTWRITE,
    E_PROC_KINS_SETTIMER,

    E_PROC_KINS_PRINTL = 0xFC,
    E_PROC_KINS_PRINTH = 0xFD,
    E_PROC_KINS_PRINTFLUSH = 0xFE,

    E_PROC_KINS_SHUTDOWN = 0xFF,
};

enum PROC_SPECIAL_REGS {
    E_PROC_REG_PAGE_STACK_SIZE = 0x10,
    E_PROC_REG_STACK_SIZE,
    E_PROC_REG_EXT_IN,
    E_PROC_REG_EXT_OUT,
    E_PROC_REG_ALU_STATUS,
    E_PROC_REG_NUM_PORT,
    E_PROC_REG_PREV_INS,
};

enum PROC_ALU_STATUS {
    E_PROC_ALU_FLAG_OVERFLOW,
};

#endif