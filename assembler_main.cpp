// For use in quickly building dummy applications for the processor.

#include <iostream>
#include <fstream>
#include "Assembler.h"
#include "ProcessorConsts.h"

int main(int argc, char** argv) {
    if(argc != 3) return 1;

    std::ifstream input(argv[1], std::ios::binary);
    std::ofstream output(argv[2], std::ios::binary);

    int line_count;
    try {
        if(!input.is_open() || !output.is_open()) throw RESPONSE_CODE_COULD_NOT_OPEN_FILE;

        Assembler a;
        
        std::string line;
        while(std::getline(input, line)) {
            ++line_count;
            a.newCommand(line, output);
        }

    }
    catch(ASSEMBLER_RESPOSE_CODES e) {
        std::cout << "ERROR! Line " << line_count << ": " << ASM_ERROR_NAME(e) << std::endl;

        input.close();
        output.close();

        return e;
    }

    input.close();
    output.close();

    return 0;
}

