

#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
#include <cctype>

#include "ProcessorConsts.h"
#include "Assembler.h"

bool isValidIdent(std::string s) {
    for(int i = 0; i < s.size(); ++i) {
        char c = s[i];
        if(!(('A' <= c && 'Z' >= c) || ('a' <= c && 'z' >= c) || ('0' <= c && '9' >= c && i > 0) || c == '_'))
        {
            return false;
        }
    }
    return s.size() > 0;
}

int Assembler::readStr(std::string s, uint8_t size, uint8_t futurePosition, bool relative) {
    if(isValidIdent(s)) {
        if(futurePosition < 0xFF) {
            if(m_labels.count(s)) {
                return m_labels.at(s);
            }
            else {
                Assembler_Link_Future future;
                future.ident = s;
                future.start = bufferSize + futurePosition;
                future.size = size;
                future.relative = relative;
                future.line = lineNo;
                m_to_link.push_back(future);
                return 0;
            }
        }
        else {
            return m_labels.at(s);
        }
    }
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

void Assembler::newCommand(std::string cmd) {
    ++ lineNo;

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

    if(tokenGroup.size() == 0) return;

    std::string COMMAND = tokenGroup.at(0);
    while(COMMAND[COMMAND.size()-1] == ':') {
        std::string label = COMMAND.substr(0,COMMAND.size()-1);
        if(!isValidIdent(label)) throw RESPONSE_CODE_INVALID_IDENTIFIER;
        if(m_labels.count(label)) throw RESPONSE_CODE_IDENTIFIER_OVERWRITE;
        m_labels[label] = bufferSize / 2;
        resolveIdent(label, bufferSize / 2);

        tokenGroup.pop_back();
        if(tokenGroup.size() == 0) return;
        COMMAND = tokenGroup.at(0);
    }

    // A wizard told me this would work. I believe that wizard.
    std::transform(COMMAND.begin(), COMMAND.end(), COMMAND.begin(),
        [](unsigned char c){ return std::toupper(c); });

    // DIRECTIVES, ASSEMBLE
    unsigned int size;
    uint8_t table[4];
    uint16_t _temp;
    int _s_temp;
    std::size_t _size_temp;
    std::size_t _size_temp2;
    try {
        ASM_DIRECTIVES a = ASM_STR_TO_DIR.at(COMMAND);
        switch(a) {
            case E_ASM_DIR_SET:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_SET_LITERAL);
                table[1] = static_cast<uint8_t>(readStr(tokenGroup.at(1)));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_CJMP:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_JMP);
                table[1] = readStr(tokenGroup.at(1));
                _temp = readStr(tokenGroup.at(2), 2, 2);
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_JMP:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_JMP);
                table[1] = 0xFF; // Reg is always true by convention.
                _temp = readStr(tokenGroup.at(1), 2, 2);
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_RJMP:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_RJMP);
                _s_temp = readStr(tokenGroup.at(1), 1, 1, true) - static_cast<int>(bufferSize / 2) - 1;
                table[1] = _s_temp & 0xFF; // Reg is always true by convention.
                size = 2;
            break;

            case E_ASM_DIR_MOV:
                if(tokenGroup.size() != 3) throw RESPONSE_CODE_WRONG_NUMBER_ARGS;
                table[0] = static_cast<uint8_t>(E_PROC_INS_SET_MOV);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = 0x00;
                table[3] = readStr(tokenGroup.at(2));
                size = 4;
            break;
            case E_ASM_DIR_SWP:
                if(tokenGroup.size() != 3) throw RESPONSE_CODE_WRONG_NUMBER_ARGS;
                table[0] = static_cast<uint8_t>(E_PROC_INS_SET_MOV);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = 0x01;
                table[3] = readStr(tokenGroup.at(2));
                size = 4;
            break;
            case E_ASM_DIR_LD:
                if(tokenGroup.size() != 2) throw RESPONSE_CODE_WRONG_NUMBER_ARGS;
                table[0] = static_cast<uint8_t>(E_PROC_INS_LD);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;
            case E_ASM_DIR_ST:
                if(tokenGroup.size() != 3) throw RESPONSE_CODE_WRONG_NUMBER_ARGS;
                table[0] = static_cast<uint8_t>(E_PROC_INS_ST);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = 0x0;
                table[3] = readStr(tokenGroup.at(1));
                size = 4;
            break;

            case E_ASM_DIR_CALL:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_CALL);
                table[1] = 0x00;
                _temp = readStr(tokenGroup.at(1), 2, 2);
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_RET:
                if(tokenGroup.size() != 1) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_RET);
                table[1] = 0x00;
                size = 2;
            break;

            case E_ASM_DIR_INC:
                if(tokenGroup.size() != 2) throw RESPONSE_CODE_WRONG_NUMBER_ARGS;
                table[0] = static_cast<uint8_t>(E_PROC_INS_INC);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;
            case E_ASM_DIR_DEC:
                if(tokenGroup.size() != 2) throw RESPONSE_CODE_WRONG_NUMBER_ARGS;
                table[0] = static_cast<uint8_t>(E_PROC_INS_DEC);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            case E_ASM_DIR_ADD:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_ADD);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_SUB:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_SUB);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_DIV:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_DIV);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_LSHIFT:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_LSHIFT);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_RSHIFT:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_RSHIFT);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_AND:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_AND);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_OR:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_OR);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_XOR:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_XOR);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_BAND:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_BAND);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_BOR:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_BOR);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_BXOR:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_BXOR);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_MOD:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_MOD);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            
            case E_ASM_DIR_FADD:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_FADD);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_FSUB:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_FSUB);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_FMUL:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_FMUL);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_FDIV:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_FDIV);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_MUL:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_MUL);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_DIVMOD:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_DIVMOD);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            
            case E_ASM_DIR_XORI:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_XORI);
                table[1] = readStr(tokenGroup.at(1));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_ANDI:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_ANDI);
                table[1] = readStr(tokenGroup.at(1));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_ORI:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_ORI);
                table[1] = readStr(tokenGroup.at(1));
                _temp = readStr(tokenGroup.at(2));
                table[2] = _temp >> 8;
                table[3] = _temp & 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_NOT:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_BNOT);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            case E_ASM_DIR_RAISE:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_RAISE);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            // Kernel operations:
            case E_ASM_DIR_UNLOCK:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_UNLOCK);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;
            case E_ASM_DIR_LOCK:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_LOCK);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            case E_ASM_DIR_PUSH:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_STACK_PUSH);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;
            case E_ASM_DIR_POP:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_STACK_POP);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            case E_ASM_DIR_USR_ADDR:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_USR_ADDR);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;

            case E_ASM_DIR_EXTFETCH:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_EXTFETCH);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            case E_ASM_DIR_EXTWRITE:
                if(tokenGroup.size() != 4) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_EXTWRITE);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = readStr(tokenGroup.at(2));
                table[3] = readStr(tokenGroup.at(3));
                size = 4;
            break;
            
            case E_ASM_DIR_PRINTL:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_PRINTL);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;
            case E_ASM_DIR_PRINTH:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_PRINTH);
                table[1] = readStr(tokenGroup.at(1));
                size = 2;
            break;
            case E_ASM_DIR_PRINTFLUSH:
                if(tokenGroup.size() != 1) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_PRINTFLUSH);
                table[1] = 0x00;
                size = 2;
            break;

            case E_ASM_DIR_SHUTDOWN:
                if(tokenGroup.size() != 1) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_KINS_SHUTDOWN);
                table[1] = 0x0; // readStr(tokenGroup.at(1));
                size = 2;
            break;

            // Special cases
            case E_ASM_DIR_BNOT:
                // Implement NOT as BXORI FFFF
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_ALU_XORI);
                table[1] = readStr(tokenGroup.at(1));
                table[2] = 0xFF;
                table[3] = 0xFF;
                size = 4;
            break;
            case E_ASM_DIR_HALT:
                // Implement halt as RJMP(-1)
                if(tokenGroup.size() != 1) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_RJMP);
                table[1] = 0xFF;
                size = 2;
            break;

            case E_ASM_DIR_NOP:
                // Implement halt as RJMP(0)
                if(tokenGroup.size() != 1) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                table[0] = static_cast<uint8_t>(E_PROC_INS_RJMP);
                table[1] = 0x00;
                size = 2;
            break;

            // Assembler directives:
            case E_ASM_DOT_ALIAS:
                if(tokenGroup.size() != 3) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                if(!isValidIdent(tokenGroup.at(1))) throw RESPONSE_CODE_INVALID_IDENTIFIER;
                if(m_labels.count(tokenGroup.at(1))) throw RESPONSE_CODE_IDENTIFIER_OVERWRITE;
                m_labels.insert(std::pair<std::string, int>(tokenGroup.at(1), readStr(tokenGroup.at(2))));
                size = 0;
            break;
            
            case E_ASM_DOT_DATA:
                for(int i = 1; i < tokenGroup.size(); i ++) {
                    _temp = readStr(tokenGroup.at(1));
                    table[0] = _temp >> 8;
                    table[1] = _temp & 0xFF;
                    buffer(reinterpret_cast<char*>(table), 2);
                }
                size = 0;
            break;
            case E_ASM_DOT_TEXT:
                _size_temp = cmd.find_first_of('"');
                if(_size_temp == std::string::npos) throw RESPONSE_CODE_INVALID_SYNTAX;
                _size_temp2 = cmd.find_first_of('"', _size_temp+1);
                if(_size_temp2 == std::string::npos) throw RESPONSE_CODE_INVALID_SYNTAX;
                for(int i = _size_temp + 1; i < _size_temp2 + 1; i += 2) {
                    table[0] = i >= _size_temp2 ? '\0' : cmd.at(i);
                    table[1] = (i + 1) >= _size_temp2 ? '\0' : cmd.at(i+1);
                    buffer(reinterpret_cast<char*>(table), 2);
                }
                size = 0;
            break;

            case E_ASM_DOT_ORG:
                if(tokenGroup.size() != 2) { throw RESPONSE_CODE_WRONG_NUMBER_ARGS; }
                _s_temp = readStr(tokenGroup.at(1));
                if(_s_temp * 2 < bufferSize) throw RESPONSE_CODE_OVERLAP;
                table[0] = '\0';
                table[1] = '\0';
                for(int i = bufferSize; i < _s_temp * 2; i += 2) {
                    buffer(reinterpret_cast<char*>(table), 2);
                }
                size = 0;
            break;

            default:
                std::cerr << "I don't know what to do with this: " << a << std::endl;
                throw 0xff;
        }
        if(size) {
            buffer(reinterpret_cast<char*>(table), size);
        }
    }
    catch(std::out_of_range e) {
        throw AssemblerErrorAtLine(RESPONSE_CODE_UNKNOWN_IDENTIFIER, lineNo);
    }
    catch(ASSEMBLER_RESPOSE_CODES e) {
        throw AssemblerErrorAtLine(e, lineNo);
    }
}

void Assembler::compile(std::ofstream& out) {
    if(m_to_link.size() > 0) {
        auto link = m_to_link.at(0);
        throw AssemblerErrorAtLine(RESPONSE_CODE_UNKNOWN_IDENTIFIER, link.line);
    }

    out.write(outputBuffer, bufferSize);
}

void Assembler::expand(uint32_t newSize) {
    if(maxBufferSize <= newSize) {
        newSize = std::max(newSize, maxBufferSize * 2);
        char* _temp = new char[newSize];
        for(int i = 0; i < bufferSize; i ++) {
            _temp[i] = outputBuffer[i];
        }
        delete[] outputBuffer;
        outputBuffer = _temp;
        maxBufferSize = newSize;
    }
}
void Assembler::buffer(char* arr, uint8_t size) {
    expand(size + maxBufferSize);
    for(unsigned int i = 0; i < size; i ++) {
        // std::cout << std::hex << "NEW BUFF " << (int)reinterpret_cast<uint8_t&>(arr[i]) << std::endl;
        outputBuffer[i + bufferSize] = arr[i];
    }
    bufferSize += size;
}
void Assembler::resolveIdent(std::string ident, int value)
{
    for(int i = m_to_link.size() - 1; i >= 0; i--) {
        auto link = m_to_link.at(i);
        if(link.ident == ident) {
            for(unsigned int j = 0; j < link.size; j ++) {
                if(link.relative) {
                    uint32_t v = value - static_cast<int>(link.start / 2) - 1;
                    outputBuffer[link.start + j] = (v >> (8 * (link.size - 1 - j))) & 0xFF;
                }
                else {
                    outputBuffer[link.start + j] = (static_cast<uint32_t>(value) >> (8 * (link.size - 1 - j))) & 0xFF;
                }
            }

            std::swap(m_to_link.at(i), m_to_link.at(m_to_link.size()-1));
            m_to_link.pop_back();
        }
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
        case RESPONSE_CODE_INVALID_IDENTIFIER: return "INVALID IDENTIFIER";
        case RESPONSE_CODE_IDENTIFIER_OVERWRITE: return "CONFLICTING IDENTIFIER DEFINITIONS";
        case RESPONSE_CODE_OVERLAP: return "OVERLAPPING CODE SEGMENTS";
        case RESPONSE_CODE_INVALID_SYNTAX: return "INVALID SYNTAX";
    }
    return "UNKNOWN ERROR";
};
