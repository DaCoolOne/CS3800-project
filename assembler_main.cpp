// For use in quickly building dummy applications for the processor.

#include <iostream>
#include <fstream>
#include "Assembler.h"
#include "ProcessorConsts.h"

int main(int argc, char** argv) {
    if(argc != 3) return 1;

    std::ifstream input(argv[1], std::ios::binary);
    std::ofstream output(argv[2], std::ios::binary);

    try {
        if(!input.is_open() || !output.is_open()) throw RESPONSE_CODE_COULD_NOT_OPEN_FILE;

        Assembler a;
        
        std::string line;
        while(std::getline(input, line)) {
            // std::cout << "PROCESS LINE " << line_count << std::endl;
            a.newCommand(line);
        }

        a.compile(output);
    }
    catch(AssemblerErrorAtLine e) {
        std::cout << "ERROR! Line " << e.line << ": " << ASM_ERROR_NAME(e.code) << std::endl;

        input.close();
        output.close();

        return e.code;
    }

    input.close();
    output.close();

    return 0;
}

