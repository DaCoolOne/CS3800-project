

default: processor

processor:
	g++ main.cpp Processor.cpp -o processor.exe

assembler:
	g++ Assembler.cpp assembler_main.cpp -o assembler.exe

