

#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>
#include "Processor.h"

int main(int argc, char** argv) {
    if(argc != 2) return 1;

    std::cout << std::hex;

    Processor proc;
    
    std::ifstream memFile(argv[1], std::ios::binary);
    proc.load(memFile);
    memFile.close();

    std::string nextWord;
    while(std::cin >> nextWord)
    {
        if(nextWord == "step") {
            std::cout << "STEP EXECUTE INSTRUCTION" << std::endl;
            proc.step();
        }
        else if(nextWord == "run") {
            proc.run();
        }
        else if(nextWord == "dump") {
            proc.dumpState();
        }
        else if(nextWord == "exit" || nextWord == "quit" || nextWord == "Quit") {
            return 0;
        }

        if(!proc.isRunning()) {
            return 0;
        }
    }
    return 0;
}

