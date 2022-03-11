

default: processor

processor:
	g++ main.cpp Processor.cpp -o processor.exe

lisp_compiler:
	g++ LispInterp.cpp lisp_main.cpp -o lisp_compiler.exe

assembler:
	g++ Assember.cpp assembler_main.cpp -0 assembler.exe

