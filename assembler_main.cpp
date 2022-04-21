// For use in quickly building dummy applications for the processor.

#include <iostream>
#include <fstream>
#include "Assembler.h"
#include "ProcessorConsts.h"

int main(int argc, char** argv) {

    std::string input_file = "";
    std::string output_file = "";

    bool userProg = false;

    for(int i = 1; i < argc; i ++) {
        std::string carg = argv[i];
        if(carg.rfind("-", 0) == 0) {
            if(carg == "-u" || carg == "--userprogram") {
                userProg = true;
            }
            else {
                std::cout << "Unknown flag \"" << argv[i] << '"' << std::endl;
                return 1;
            }
        }
        else {
            if(input_file == "") {
                input_file = carg;
            }
            else if(output_file == "") {
                output_file = carg;
            }
            else {
                std::cout << "Unknown arg \"" << argv[i] << '"' << std::endl;
                return 1;
            }
        }
    }

    std::ifstream input(input_file, std::ios::binary);
    std::ofstream output(output_file, std::ios::binary);

    try {
        if(!input.is_open() || !output.is_open()) throw RESPONSE_CODE_COULD_NOT_OPEN_FILE;

        Assembler a;
        
        std::string line;
        while(std::getline(input, line)) {
            // std::cout << "PROCESS LINE " << line_count << std::endl;
            a.newCommand(line);
        }

        a.compile(output, userProg);
    }
    catch(AssemblerErrorAtLine e) {
        std::cout << "ERROR! Line " << e.line << ": " << ASM_ERROR_NAME(e.code) << std::endl;

        input.close();
        output.close();

        return e.code;
    }
    catch(ASSEMBLER_RESPOSE_CODES e) {
        std::cout << "ERROR! " << ASM_ERROR_NAME(e) << std::endl;
    }

    input.close();
    output.close();

    return 0;
}

