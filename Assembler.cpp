

#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
#include <cctype>

#include "Processor.h"
#include "Assembler.h"

int readStr(std::string s) {
    if(s.size() >= 3) {
        if(s[0] == '0' && s[1] == 'x') {
            return std::stoi(s.substr(2), nullptr, 16);
        }
        if(s[0] == '0' && s[1] == 'b') {
            return std::stoi(s.substr(2), nullptr, 2);
        }
    }
    return std::stoi(s);
}

void Assembler::newCommand(std::string cmd, std::ofstream& out) {
    // Remove comments
    auto pos = cmd.find_first_of(';');
    if(pos != std::string::npos) {
        cmd = cmd.substr(0, pos);
    }

    // Split by spaces.
    std::stringstream streamver(cmd);
    std::string token;
    std::vector<std::string> tokenGroup;
    while(streamver >> token) {
        tokenGroup.push_back(token);
    }

    /*
    std::cout << "V: ";
    for(auto c : tokenGroup) {
        std::cout << c << "\t";
    }
    std::cout << std::endl;
    */

    if(tokenGroup.size() == 0) return;
    
    // A wizard told me this would work. I believe that wizard.
    std::string COMMAND = tokenGroup.at(0);
    std::transform(COMMAND.begin(), COMMAND.end(), COMMAND.begin(),
        [](unsigned char c){ return std::toupper(c); });

    // DIRECTIVES, ASSEMBLE
    unsigned int size;
    try {
        uint8_t table[4];
        uint16_t _temp;
        ASM_DIRECTIVES a = ASM_STR_TO_DIR.at(COMMAND);
        switch(a) {
            case E_ASM_DIR_SET:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(0x02);
                table[1] = static_cast<char>(readStr(tokenGroup.at(1)));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_CJMP:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                token[0] = static_cast<char>(E_PROC_INS_JMP);
                token[1] = readStr(tokenGroup.at(1));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
            break;
            case E_ASM_DIR_JMP:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                token[0] = static_cast<char>(E_PROC_INS_JMP);
                token[1] = 0xFF; // Reg is always true by convention.
                _temp = readStr(tokenGroup.at(1));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
            break;

            case E_ASM_DIR_ADD:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_ADD);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_SUB:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_SUB);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_DIV:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_DIV);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_LSHIFT:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_LSHIFT);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_RSHIFT:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_RSHIFT);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_AND:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_AND);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_OR:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_OR);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_XOR:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_XOR);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_BAND:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_BAND);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_BOR:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_BOR);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_BXOR:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_BXOR);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_MOD:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_MOD);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            
            case E_ASM_DIR_FADD:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_FADD);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_FSUB:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_FSUB);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_FMUL:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_FMUL);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_FDIV:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_FDIV);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_MUL:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_MUL);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_DIVMOD:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_DIVMOD);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            
            case E_ASM_DIR_XORI:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_XORI);
                table[1] = readStr(tokenGroup.at(1));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_ANDI:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_ANDI);
                table[1] = readStr(tokenGroup.at(1));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_ORI:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_ORI);
                table[1] = readStr(tokenGroup.at(1));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_NOT:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_BNOT);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            case E_ASM_DIR_RAISE:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_RAISE);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            // Kernel operations:
            case E_ASM_DIR_UNLOCK:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_KINS_UNLOCK);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;
            case E_ASM_DIR_LOCK:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_KINS_LOCK);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            case E_ASM_DIR_PUSH:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_KINS_STACK_PUSH);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;
            case E_ASM_DIR_POP:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_KINS_STACK_POP);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            case E_ASM_DIR_USR_ADDR:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_KINS_USR_ADDR);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            // Special cases
            case E_ASM_DIR_BNOT:
                // Implement NOT as BXORI FFFF
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_ALU_XORI);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = 0xFF;
                table[3] = 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_HALT:
                // Implement halt as RJMP(-1)
                if(tokenGroup.size() != 1) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_RJMP);
                table[1] = 0xFF;
                size = 2;
            break;

            case E_ASM_DIR_NOP:
                // Implement halt as RJMP(0)
                if(tokenGroup.size() != 1) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<char>(E_PROC_INS_RJMP);
                table[1] = 0x00;
                size = 2;
            break;

            default:
                std::cerr << "I don't know what to do with this: " << a << std::endl;
                throw 0xff;
        }
        out.write(reinterpret_cast<char*>(table), size);
    }
    catch(std::out_of_range e) {
        throw RESPONSE_CODE_UNKNOWN_IDENTIFIER;
    }
}

std::string ASM_ERROR_NAME(ASSEMBLER_RESPOSE_CODES code)
{
    switch (code)
    {
        case RESPONSE_CODE_SUCCESS: return "SUCCESS";
        case RESPONSE_CODE_UNKNOWN_IDENTIFIER: return "UNKNOWN IDENTIFIER";
        case RESPONSE_CODE_WRONG_NUMBER_ARGS: return "WRONG NUMBER OF ARGS";
        case RESPONSE_CODE_COULD_NOT_OPEN_FILE: return "COULD NOT OPEN FILE";
    }
    return "UNKNOWN ERROR";
};
