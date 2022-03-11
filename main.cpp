

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
    bool isRunning = true;
    while(std::cin >> nextWord && isRunning)
    {
        if(nextWord == "step") {
            proc.step();
        }
        else if(nextWord == "dump") {
            proc.dumpState();
        }
        else if(nextWord == "exit") {
            isRunning = false;
        }
    }
    return 0;
}

