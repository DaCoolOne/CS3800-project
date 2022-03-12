#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include <string>
#include <map>
#include <vector>
#include <cstdint>
#include <fstream>

enum ASM_DIRECTIVES {
    E_ASM_DIR_RJMP,
    E_ASM_DIR_CJMP,
    E_ASM_DIR_JMP,
    E_ASM_DIR_SET,
    E_ASM_DIR_MOV,
    E_ASM_DIR_SWP, // Swap

    E_ASM_DIR_INC,
    E_ASM_DIR_DEC,

    E_ASM_DIR_CALL,
    E_ASM_DIR_RET,

    E_ASM_DIR_ADD,
    E_ASM_DIR_SUB,
    E_ASM_DIR_DIV,
    E_ASM_DIR_LSHIFT,
    E_ASM_DIR_RSHIFT,
    E_ASM_DIR_AND,
    E_ASM_DIR_OR,
    E_ASM_DIR_XOR,
    E_ASM_DIR_BAND,
    E_ASM_DIR_BOR,
    E_ASM_DIR_BXOR,
    E_ASM_DIR_MOD,
    
    E_ASM_DIR_FADD,
    E_ASM_DIR_FSUB,
    E_ASM_DIR_MUL,
    E_ASM_DIR_FMUL,
    E_ASM_DIR_FDIV,
    E_ASM_DIR_DIVMOD,
    E_ASM_DIR_XORI,
    E_ASM_DIR_ORI,
    E_ASM_DIR_ANDI,
    E_ASM_DIR_NOT,

    E_ASM_DIR_RAISE,

    // Kernel mode only commands
    E_ASM_DIR_UNLOCK,
    E_ASM_DIR_LOCK,
    E_ASM_DIR_PUSH,
    E_ASM_DIR_POP,
    E_ASM_DIR_USR_ADDR,

    // Shorthand for common commands that are implemented strangely.
    E_ASM_DIR_BNOT,
    E_ASM_DIR_HALT,
    E_ASM_DIR_NOP,

    // Assembler directives
    E_ASM_DOT_ALIAS,
    E_ASM_DOT_DATA,
};

const std::map<ASM_DIRECTIVES, std::string> ASM_DIR_TO_STR = {
    { E_ASM_DIR_RJMP, "RJMP" },
    { E_ASM_DIR_CJMP, "CJMP" },
    { E_ASM_DIR_JMP, "JMP" },
    { E_ASM_DIR_SET, "SET" },
    { E_ASM_DIR_MOV, "MOV" },
    { E_ASM_DIR_SWP, "SWP" },

    { E_ASM_DIR_CALL, "CALL" },
    { E_ASM_DIR_RET, "RET" },

    { E_ASM_DIR_INC, "INC" },
    { E_ASM_DIR_DEC, "DEC" },

    { E_ASM_DIR_ADD, "ADD" },
    { E_ASM_DIR_SUB, "SUB" },
    { E_ASM_DIR_DIV, "DIV" },
    { E_ASM_DIR_LSHIFT, "LSHIFT" },
    { E_ASM_DIR_RSHIFT, "RSHIFT" },
    { E_ASM_DIR_AND, "AND" },
    { E_ASM_DIR_OR, "OR" },
    { E_ASM_DIR_XOR, "XOR" },
    { E_ASM_DIR_BAND, "BAND" },
    { E_ASM_DIR_BOR, "BOR" },
    { E_ASM_DIR_BXOR, "BXOR" },
    { E_ASM_DIR_MOD, "MOD" },
    { E_ASM_DIR_FADD, "FADD" },
    { E_ASM_DIR_FSUB, "FSUB" },
    { E_ASM_DIR_MUL, "MUL" },
    { E_ASM_DIR_FMUL, "FMUL" },
    { E_ASM_DIR_FDIV, "FDIV" },
    { E_ASM_DIR_DIVMOD, "DIVMOD" },
    { E_ASM_DIR_XORI, "XORI" },
    { E_ASM_DIR_ORI, "ORI" },
    { E_ASM_DIR_ANDI, "ANDI" },
    { E_ASM_DIR_NOT, "NOT" },
    { E_ASM_DIR_RAISE, "RAISE" },
    { E_ASM_DIR_UNLOCK, "UNLOCK" },
    { E_ASM_DIR_LOCK, "LOCK" },
    { E_ASM_DIR_PUSH, "PUSH" },
    { E_ASM_DIR_POP, "POP" },
    { E_ASM_DIR_USR_ADDR, "USR_ADDR" },

    { E_ASM_DIR_HALT, "HALT" },
    { E_ASM_DIR_BNOT, "BNOT" },
    { E_ASM_DIR_NOP, "NOP" },

    { E_ASM_DOT_ALIAS, ".ALIAS" },
    { E_ASM_DOT_DATA, ".DATA" },
};
const std::map<std::string, ASM_DIRECTIVES> ASM_STR_TO_DIR = {
    { "RJMP", E_ASM_DIR_RJMP },
    { "CJMP", E_ASM_DIR_CJMP },
    { "JMP", E_ASM_DIR_JMP },
    { "SET", E_ASM_DIR_SET },
    { "MOV", E_ASM_DIR_MOV },
    { "SWP", E_ASM_DIR_SWP },

    { "CALL", E_ASM_DIR_CALL },
    { "RET", E_ASM_DIR_RET },
    
    { "INC", E_ASM_DIR_INC },
    { "DEC", E_ASM_DIR_DEC },

    { "ADD", E_ASM_DIR_ADD },
    { "SUB", E_ASM_DIR_SUB },
    { "DIV", E_ASM_DIR_DIV },
    { "LSHIFT", E_ASM_DIR_LSHIFT },
    { "RSHIFT", E_ASM_DIR_RSHIFT },
    { "AND", E_ASM_DIR_AND },
    { "OR", E_ASM_DIR_OR },
    { "XOR", E_ASM_DIR_XOR },
    { "BAND", E_ASM_DIR_BAND },
    { "BOR", E_ASM_DIR_BOR },
    { "BXOR", E_ASM_DIR_BXOR },
    { "MOD", E_ASM_DIR_MOD },
    { "FADD", E_ASM_DIR_FADD },
    { "FSUB", E_ASM_DIR_FSUB },
    { "MUL", E_ASM_DIR_MUL },
    { "FMUL", E_ASM_DIR_FMUL },
    { "FDIV", E_ASM_DIR_FDIV },
    { "DIVMOD", E_ASM_DIR_DIVMOD },
    { "XORI", E_ASM_DIR_XORI },
    { "ORI", E_ASM_DIR_ORI },
    { "ANDI", E_ASM_DIR_ANDI },
    { "NOT", E_ASM_DIR_NOT },
    { "RAISE", E_ASM_DIR_RAISE },
    { "UNLOCK", E_ASM_DIR_UNLOCK },
    { "LOCK", E_ASM_DIR_LOCK },
    { "PUSH", E_ASM_DIR_PUSH },
    { "POP", E_ASM_DIR_POP },
    { "USR_ADDR", E_ASM_DIR_USR_ADDR },
    
    { "BNOT", E_ASM_DIR_BNOT },
    { "HALT", E_ASM_DIR_HALT },
    { "NOP", E_ASM_DIR_NOP },

    { ".ALIAS", E_ASM_DOT_ALIAS },
    { ".DATA", E_ASM_DOT_DATA },
};

enum ASSEMBLER_RESPOSE_CODES {
    RESPONSE_CODE_SUCCESS,
    RESPONSE_CODE_UNKNOWN_IDENTIFIER,
    RESPONSE_CODE_WRONG_NUMBER_ARGS,
    RESPONSE_CODE_COULD_NOT_OPEN_FILE,
    RESPONSE_CODE_INVALID_IDENTIFIER,
    RESPONSE_CODE_IDENTIFIER_OVERWRITE,
};

std::string ASM_ERROR_NAME(ASSEMBLER_RESPOSE_CODES code);

struct Assembler_Link_Future
{
    std::string ident;
    uint32_t start;
    uint8_t size;
};

// Assembler class.
class Assembler
{
    std::map<std::string, int> m_labels;
    std::vector<Assembler_Link_Future> m_to_link;
    char* outputBuffer;
    uint32_t bufferSize = 0;
    uint32_t maxBufferSize = 0xFF;

    int readStr(std::string s, uint8_t size, uint32_t futurePosition);
    void expand(uint32_t newSize);
    void buffer(char* arr, uint8_t size);
    Assembler(Assembler& other);
public:
    Assembler(): outputBuffer(new char[maxBufferSize]) {}
    void newCommand(std::string cmd);
    void compile(std::ofstream& out);
};

#endif