

#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>
#include "Processor.h"

int main(int argc, char** argv) {

    std::string filename = "";
    bool stepwise = false;

    Processor proc;
    
    for(int i = 1; i < argc; i ++) {
        std::string carg = argv[i];
        if(carg == "--filename" || carg == "-f") {
            if(argc == i + 1) {
                std::cout << "Expected file name after --filename flag" << std::endl;
                return 1;
            }
            filename = argv[++i];
        }
        else if(carg == "--stepwise" || carg == "-s") {
            stepwise = true;
        }
        else if(carg == "-c" || carg == "--connect") {
            if(argc == i + 1) {
                std::cout << "Expected file name after --connect flag" << std::endl;
                return 1;
            }
            proc.newPort(argv[++i]);
        }
        else {
            std::cout << "Unknown flag \"" << argv[i] << '"' << std::endl;
            return 1;
        }
    }

    std::cout << std::hex;

    std::ifstream memFile(filename, std::ios::binary);
    proc.load(memFile);
    memFile.close();

    if(stepwise) {
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
    }
    else {
        proc.run();
    }
    return 0;
}

