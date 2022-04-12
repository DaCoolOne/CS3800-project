# CS3800-project
CS3800 project thingy

# Processor

run `make processor` (this is the default make option)

This will generate a file called `processor.exe`

You can run the processor with the command:

`processor.exe INPUT_MEM`

# Processor specifications

69 registers for storing any data. When in user mode, only the bottom 16 regs may be used.

Some of the registers have special meanings. First of all, in kernel mode the user registers can be accessed
using KERNEL.int_UserRegN where N is 0-F (KERNEL.int_UserReg0 KERNEL.int_UserReg1 ... KERNEL.int_UserRegF).

Reg 0x10 -> Page stack size. (KERNEL.int_PageStackSize)

Reg 0x11 -> Stack size. (KERNEL.int_StackSize)

Reg 0x12 -> KERNEL.int_ExtBufferIn, most recently read word from ext buffer.

Reg 0x13 -> KERNEL.int_ExtBufferOut, word to be written to EXT file.

Reg 0x14 -> ALU status register. (KERNEL.int_AluStatus)

Reg 0x15 -> Number of external devices. (KERNEL.int_ExtDevices)

Reg 0x16 -> The most recent instruction executed in user mode. This is useful for times when a user command triggers some interrupt that causes the instruction to fail (e.g, bad memory access). The kernel can take steps to remedy this failure and return the program's execution so that it attempts the instruction again (and hopefully doesn't fail this time). (KERNEL.int_LastUserIns)

Reg 0xFF -> A virtual register that is always 0xFF. Writing to this register is a NOP.

## Bytecode. A word is an 8 bit op code followed by an 8 bit specifier and an optional 16 bit address or value.

### Jump
RJMP 0000 0000 xxxx xxxx - Add X to the PC

CJMP 0000 0001 xxxx xxxx yyyy yyyy yyyy yyyy - Jump to literal position if Reg X is not 0

JMP  0000 0001 1111 1111 yyyy yyyy yyyy yyyy - Jump to literal position

REGJMP 0000 1111 xxxx xxxx - Jump to literal position in register. (TODO)

### Direct Reg manip
SET 0000 0010 xxxx xxxx yyyy yyyy yyyy yyyy - Literal set reg x to y.

MOV 0000 0011 xxxx xxxx 0000 0000 yyyy yyyy - Move Register y to x.

SWP 0000 0011 xxxx xxxx 0000 0001 yyyy yyyy - Swap regs x and y.

LD 0000 1000 xxxx xxxx - Load value from memory at reg x to reg x

ST 0000 1001 xxxx xxxx ---- ---- yyyy yyyy - Store value in reg x at reg y

### Functions
CALL 0000 0100 ---- ---- yyyy yyyy yyyy yyyy - Call function at address, place return value in reg

RET 0000 0101 ---- ---- - Return from function

RETI 0001 0101 ---- ---- - Return from function and enter user mode

INC 0000 0110 xxxx xxxx - Inc register.

DEC 0000 0111 xxxx xxxx - Dec register.

### ALU Operations:
010A AAAA xxxx xxxx yyyy yyyy zzzz zzzz - Perform ALU operation A on registers Y, Z. Place result in X.

The alu operations are as follows:

ADD, SUB, LMUL, DIV, LSHIFT, RSHIFT, AND, OR, XOR, BAND, BOR, BXOR, MOD, 
GTR, EQ, GTEQ

**Note: There is no less than comparison. This is because `LSS X Y Z` can be trivially rewritten `GTR X Z Y`, so there is no reason to write such a command. Same reasoning goes for less than or equal to. There are less than comparisons for the immediate (one reg) instructions, but this is because these commands cannot be reversed easily.**

Two reg ALU operations:

0110 AAAA xxxx xxxx yyyy yyyy zzzz zzzz - Same as normal ALU operations, but uses two sequential registers.

FADD, FSUB, MUL, FMUL, FDIV,
DIVMOD

Special notes:

MUL and DIVMOD take as right hand arguments Y and Z that are single register, but the output is two registers large.

DIVMOD places the result of int division in reg X, and the result of modulus in X+1

Literal ALU operations:

0111 AAAA xxxx xxxx yyyy yyyy yyyy yyyy - Perform operation on reg X with value Y.

XORI - Bitwise xor with a literal value. Bitwise not can be run using XORI R 0xFF

ANDI - Bitwise and with a literal value.

ORI - Bitwise or with a literal value.

BNOT - Binary not, does not have a y argument.

EQI - Computes Reg[x] == y

GTRI - Computes Reg[x] > y

GTEQI - Computes Reg[x] >= y

LSSI - Computes Reg[x] < y

LSEQI - Computes Reg[x] <= y

RSHIFTI - Computes Reg[x] >> y

LSHIFTI - Computes Reg[x] << y

### Interupts

RAISE 0011 1111 ---- xxxx - Throw interrupt X+1. (In assembly you throw the error that corresponds to the error table, e.g, RAISE 3 will raise a stack overflow).

## Kernel mode functions, processor must be in kernel mode.

LOCK   1000 0001 xxxx xxxx - Lock the last X pages of memory. Place last unlocked page into the accumulator.

UNLOCK 1000 0000 xxxx xxxx - Unlock page X of memory. Locked pages cannot be accessed by the processor.

PUSH 1000 0010 xxxx xxxx - Push data in Reg X to stack

POP  1000 0011 xxxx xxxx - Pop data from stack, place in Reg X

USR_ADDR 1000 0100 xxxx xxxx - Convert the address in reg X from user space to kernel space.

EXTFETCH 1000 0101 xxxx xxxx yyyy yyyy zzzz zzzz - Read device Reg[X] at address Reg[Y] & Reg[Z], place into EXT_BUFFER_IN. Raise FAILED_EXT_ACCESS if file could not be found.

EXTWRITE 1000 0110 xxxx xxxx yyyy yyyy zzzz zzzz - Write to device Reg[X] at address Reg[Y] & Reg[Z], place into EXT_BUFFER_OUT.

SETTIMER 1000 0111 xxxx xxxx - Sets the processor's internal timer to Reg[X]. The internal timer determines the next time a TimerInterrupt will be triggered.

PRINTH 1111 1101 xxxx xxxx - Print high bits of register X

PRINTL 1111 1100 xxxx xxxx - Print low bits of register X

PRINTFLUSH 1111 1110 ---- ---- Flush print buffer. The print buffer is also flushed whenever a new line is printed or the print buffer runs out of space.

SHUTDOWN 1111 1111 xxxx xxxx - Shutdown the machine. (Optional: machine returns status code xxxx xxxx?)

When accessing heap addresses, the processor considers locked pages to not exist. For example, if page 0
is locked and page 1 is not locked, any attempt by the processor to access a page 0 address will result
in it reading a page 2 address.

In order to use locked pages, you need to be in kernel mode. In kernel mode, all pages are considered unlocked.

The CPU starts in kernel mode with all pages locked.

## Additional assembly

There are a few functions that are not supported natively by the processor that can still be implemented trivially in asm. The following are the commands:

`NOT Rx` - Bitwise not operation on register.

`NOP` - Do nothing.

`HALT` - Stops the processor.

Additionally there are several assembler directives which provide additional control over the output binary:

`.ALIAS` - Assigns an alias to a specific data element

`.DATA` - Writes pure binary data into memory.

`.TEXT` - Writes ASCII strings (NTCAs) into memory.

`.ALLOC` - Allocates 2 * N bytes of zeros in memory.

## Process slots



## Memory layout



## Interrupts

Whenever an interupt occurs, the processor enters kernel mode. The function that is executed
and corresponds to the following table:

0x0000 -> RESET (Cannot write a callback for in lisp)

0x0002 -> KERNEL.TimerTick

0x0004 -> KERNEL.BadMemAccess

0x0006 -> KERNEL.StackOverflow

0x0008 -> KERNEL.StackUnderflow

0x000A -> KERNEL.BadIns

0x000C -> KERNEL.FailedExtAccess (Typically thrown when reached EOF)

0x000E - 0x0022 -> KERNEL.UserDefined1 - KERNEL.UserDefined10

These can be accessed in kernel-lisp scripts by writing function definitions.

