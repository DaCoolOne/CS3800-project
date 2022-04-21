
    JMP __INTER_INIT
    JMP __INTER_0_TimerTick
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_BadIns
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_UserDefined1
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
__INTER_INIT:
    SET 23 __ALLOC_0
    SET 24 __ALLOC_1
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_3_getChar:
    MOV 41 39
    SET 42 1
    RSHIFT 42 40 42
    ADD 41 41 42
    LD 41
    SET 42 1
    AND 42 40 42
    CJMP 42 __IF_0_C0_BODY
    SET 42 8
    RSHIFT 41 41 42
    JMP __IF_0_END
__IF_0_C0_BODY:
    SET 42 255
    AND 41 41 42
__IF_0_END:
    RET

__FCALL_2_print:
    SET 37 0
    MOV 40 37
    MOV 39 36
    CALL __FCALL_3_getChar
    MOV 38 41
    JMP __LOOP_3_EVAL
__LOOP_3_BODY:
    PRINTL 38
    INC 37
    MOV 40 37
    MOV 39 36
    CALL __FCALL_3_getChar
    MOV 38 41
__LOOP_3_EVAL:
    MOV 39 38
    CJMP 39 __LOOP_3_BODY
    RET

__FCALL_2_newline:
    SET 36 10
    PRINTL 36
    RET

__INTER_0_TimerTick:
    SET 25 __STR_CONST_13
    MOV 36 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
__LOOP_15_BODY:
    JMP __LOOP_15_BODY
    SET 25 256
    SETTIMER 25
    RETI

__FCALL_2_printHex:
    SET 37 61440
    SET 38 0
    JMP __LOOP_7_EVAL
__LOOP_7_BODY:
    AND 39 37 36
    SET 40 3
    SUB 40 40 38
    SET 41 2
    LSHIFT 40 40 41
    RSHIFT 39 39 40
    SET 40 9
    GTEQ 40 40 39
    CJMP 40 __IF_2_C0_BODY
    SET 40 55
    ADD 40 39 40
    PRINTL 40
    JMP __IF_2_END
__IF_2_C0_BODY:
    SET 40 48
    ADD 40 39 40
    PRINTL 40
__IF_2_END:
    SET 40 4
    RSHIFT 37 37 40
    INC 38
__LOOP_7_EVAL:
    SET 40 4
    GTR 40 40 38
    CJMP 40 __LOOP_7_BODY
    RET

__INTER_0_BadIns:
    SET 25 __STR_CONST_14
    MOV 36 25
    CALL __FCALL_2_print
    MOV 36 22
    CALL __FCALL_2_printHex
    RETI


__INTER_0_UserDefined1:
    MOV 25 0
    USR_ADDR 25


    MOV 36 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    RETI
__INTER_0_defaultInterrupt:
    RETI

__FCALL_1_initializeMemoryBlocks:
    SET 25 0
    JMP __LOOP_1_EVAL
__LOOP_1_BODY:
    SET 26 0
    ADD 27 24 25
    ST 26 27
    INC 25
__LOOP_1_EVAL:
    SET 26 256
    GTR 26 26 25
    CJMP 26 __LOOP_1_BODY
    SET 25 0
    JMP __LOOP_2_EVAL
__LOOP_2_BODY:
    SET 26 1
    ADD 27 24 25
    ST 26 27
    INC 25
__LOOP_2_EVAL:
    SET 26 __BINEND

    SET 27 8
    RSHIFT 26 26 27
    GTEQ 26 26 25
    CJMP 26 __LOOP_2_BODY
    RET

__FCALL_4_emptyStack:
    POP 28
    JMP __LOOP_13_EVAL
__LOOP_13_BODY:
    POP 29
__LOOP_13_EVAL:
    MOV 30 17
    CJMP 30 __LOOP_13_BODY
    PUSH 28
    RET

__FCALL_4_loadStackAndRun:
    ADD 27 23 26
    LD 27
    CALL __FCALL_4_emptyStack
    SET 28 18
    ADD 28 27 28
    LD 28
    MOV 29 28
    JMP __LOOP_14_EVAL
__LOOP_14_BODY:
    SET 30 18
    ADD 30 30 29
    ADD 30 27 30
    LD 30
    PUSH 30
    DEC 29
__LOOP_14_EVAL:
    SET 30 0
    GTR 30 29 30
    CJMP 30 __LOOP_14_BODY
    RETI
    RET

__FCALL_2_printU:
    SET 37 1
    JMP __LOOP_5_EVAL
__LOOP_5_BODY:
    SET 38 10
    LMUL 37 37 38
__LOOP_5_EVAL:
    SET 38 10
    DIV 38 36 38
    GTEQ 38 38 37
    CJMP 38 __LOOP_5_BODY
    JMP __LOOP_6_EVAL
__LOOP_6_BODY:
    DIV 38 36 37
    SET 39 48
    ADD 39 38 39
    PRINTL 39
    LMUL 39 38 37
    SUB 36 36 39
    SET 39 10
    DIV 37 37 39
__LOOP_6_EVAL:
    SET 39 0
    GTR 39 37 39
    CJMP 39 __LOOP_6_BODY
    RET


__FCALL_4_unlockMemory:
    LOCK 16
    INC 26
    SET 27 0
    JMP __LOOP_12_EVAL
__LOOP_12_BODY:
    ADD 28 24 27
    LD 28
    SET 29 8
    RSHIFT 28 28 29
    EQ 28 28 26
    ADD 29 24 27
    LD 29
    SET 30 255
    AND 29 29 30
    BAND 28 28 29
    CJMP 28 __IF_8_C0_BODY
    JMP __IF_8_END
__IF_8_C0_BODY:
    UNLOCK 27
__IF_8_END:
    INC 27
__LOOP_12_EVAL:
    SET 28 256
    GTR 28 28 27
    CJMP 28 __LOOP_12_BODY
    RET

__FCALL_4_getNumberOfOpenMemBlocks:
    SET 30 0
    SET 31 0
    JMP __LOOP_4_EVAL
__LOOP_4_BODY:
    ADD 32 24 31
    LD 32
    SET 33 0
    EQ 32 32 33
    CJMP 32 __IF_1_C0_BODY
    JMP __IF_1_END
__IF_1_C0_BODY:
    INC 30
__IF_1_END:
    INC 31
__LOOP_4_EVAL:
    SET 32 256
    GTR 32 32 31
    CJMP 32 __LOOP_4_BODY
    RET

__FCALL_4_getProcessState:
    ADD 37 23 36
    LD 37
    SET 38 0
    ADD 37 37 38
    LD 37
    RET




__FCALL_4_allocateNextBlock:
    SET 35 1
    SET 36 -1
    SET 37 0
    JMP __LOOP_9_EVAL
__LOOP_9_BODY:
    ADD 38 24 37
    LD 38
    SET 39 0
    EQ 38 38 39
    CJMP 38 __IF_6_C0_BODY
    JMP __IF_6_END
__IF_6_C0_BODY:
    SET 38 8
    LSHIFT 38 33 38
    OR 38 38 34
    ADD 39 24 37
    ST 38 39
    MOV 36 37
    SET 35 0
__IF_6_END:
    INC 37
__LOOP_9_EVAL:
    SET 38 256
    GTR 38 38 37
    BAND 38 35 38
    CJMP 38 __LOOP_9_BODY
    RET

__FCALL_4_findOpenProcessSlot:
    SET 29 1
    SET 30 -1
    SET 31 0
    JMP __LOOP_8_EVAL
__LOOP_8_BODY:
    ADD 32 23 31
    LD 32

    SET 33 -1
    EQ 32 32 33
    CJMP 32 __IF_3_C0_BODY
    JMP __IF_3_END
__IF_3_C0_BODY:
    MOV 30 31
    SET 29 0
__IF_3_END:
    INC 31
__LOOP_8_EVAL:
    SET 32 10
    GTR 32 32 31
    BAND 32 29 32
    CJMP 32 __LOOP_8_BODY
    RET


__FCALL_4_saveUserRegisters:
    ADD 37 23 36
    LD 37
    SET 38 0
    SET 39 2
    ADD 40 37 39
    ST 0 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 1 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 2 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 3 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 4 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 5 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 6 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 7 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 8 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 9 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 10 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 11 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 12 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 13 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 14 40
    INC 38
    SET 39 2
    ADD 39 39 38
    ADD 40 37 39
    ST 15 40
    RET

__FCALL_4_setProgramCounter:
    ADD 38 23 36
    LD 38
    SET 39 1
    ADD 40 38 39
    ST 37 40
    RET


__FCALL_4_defaultStack:
    ADD 37 23 36
    LD 37
    SET 38 1
    SET 39 18
    ADD 40 37 39
    ST 38 40
    SET 38 0
    SET 39 19
    ADD 40 37 39
    ST 38 40
    RET

__FCALL_3_min:
    GTR 38 36 37
    CJMP 38 __IF_7_C0_BODY
    JMP __IF_7_END
__IF_7_C0_BODY:
    MOV 36 37
__IF_7_END:
    RET

__FCALL_4_extFetch:
    SET 37 1
    LSHIFT 37 36 37
    SET 38 0
    EXTFETCH 35 38 37
    MOV 38 18
    SET 39 0
    MOV 40 37
    INC 40
    EXTFETCH 35 39 40
    SET 39 8
    LSHIFT 39 38 39
    OR 38 39 18
    RET

__FCALL_4_setProcessState:
    ADD 38 23 36
    LD 38
    SET 39 0
    ADD 40 38 39
    ST 37 40
    RET

__FCALL_4_createProcess:
    SET 26 0
    SET 27 __STR_CONST_1
    MOV 36 27
    CALL __FCALL_2_print
    SET 27 __BINEND

    MOV 36 27
    CALL __FCALL_2_printHex
    SET 27 0
    MOV 36 27
    MOV 35 25
    CALL __FCALL_4_extFetch
    MOV 27 38
    SET 28 __STR_CONST_2
    MOV 36 28
    CALL __FCALL_2_print
    MOV 36 27
    CALL __FCALL_2_printHex
    SET 28 8
    RSHIFT 28 27 28
    INC 28
    CALL __FCALL_4_findOpenProcessSlot
    MOV 29 30
    SET 30 -1
    EQ 30 29 30
    CJMP 30 __IF_4_C0_BODY
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    GTR 30 30 28
    CJMP 30 __IF_5_C0_BODY
    SET 30 __STR_CONST_3
    MOV 36 30
    CALL __FCALL_2_print
    SET 26 2
    JMP __IF_5_END
__IF_5_C0_BODY:
    MOV 30 29
    INC 30
    SET 31 0
    MOV 34 31
    MOV 33 30
    CALL __FCALL_4_allocateNextBlock
    MOV 30 36
    SET 31 1
    CALL __FCALL_2_newline
    SET 32 __STR_CONST_4
    MOV 36 32
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 32 1
    JMP __LOOP_10_EVAL
__LOOP_10_BODY:
    MOV 33 29
    INC 33
    MOV 34 32
    CALL __FCALL_4_allocateNextBlock
    MOV 33 36
    MOV 36 27
    CALL __FCALL_2_printU
    MOV 34 32
    DEC 34
    SET 35 8
    LSHIFT 34 34 35
    MOV 36 34
    CALL __FCALL_2_printU
    SET 34 0
    JMP __LOOP_11_EVAL
__LOOP_11_BODY:
    MOV 36 31
    MOV 35 25
    CALL __FCALL_4_extFetch
    MOV 35 38
    MOV 36 35
    CALL __FCALL_2_printHex
    SET 36 __STR_CONST_5
    CALL __FCALL_2_print
    SET 36 8
    LSHIFT 36 33 36

    ADD 37 36 34
    ST 35 37
    INC 31
    INC 34
__LOOP_11_EVAL:
    MOV 36 32
    DEC 36
    SET 37 8
    LSHIFT 36 36 37
    SUB 36 27 36
    SET 37 256
    CALL __FCALL_3_min
    GTR 36 36 34
    CJMP 36 __LOOP_11_BODY
    CALL __FCALL_2_newline
    INC 32
__LOOP_10_EVAL:
    GTEQ 36 28 32
    CJMP 36 __LOOP_10_BODY
    SET 36 8
    LSHIFT 36 30 36

    ADD 37 23 29
    ST 36 37
    SET 36 0
    MOV 37 36
    MOV 36 29
    CALL __FCALL_4_setProcessState
    MOV 36 29
    CALL __FCALL_4_saveUserRegisters
    SET 36 0
    MOV 37 36
    MOV 36 29
    CALL __FCALL_4_setProgramCounter
    MOV 36 29
    CALL __FCALL_4_defaultStack
    SET 36 __STR_CONST_6
    CALL __FCALL_2_print
    MOV 36 29
    CALL __FCALL_2_printU
    SET 36 __STR_CONST_7
    CALL __FCALL_2_print
    MOV 36 30
    CALL __FCALL_2_printU
    SET 36 __STR_CONST_8
    CALL __FCALL_2_print
    MOV 36 29
    CALL __FCALL_4_getProcessState
    MOV 36 37
    CALL __FCALL_2_printU
__IF_5_END:
    JMP __IF_4_END
__IF_4_C0_BODY:
    SET 36 __STR_CONST_9
    CALL __FCALL_2_print
    SET 26 1
__IF_4_END:
    RET


__FCALL_1_initializeProcessArray:
    SET 25 0
    JMP __LOOP_0_EVAL
__LOOP_0_BODY:
    SET 26 -1

    ADD 27 23 25
    ST 26 27
    INC 25
__LOOP_0_EVAL:
    SET 26 10
    GTR 26 26 25
    CJMP 26 __LOOP_0_BODY
    RET

__FCALL_1_main:
    CALL __FCALL_1_initializeProcessArray
    CALL __FCALL_1_initializeMemoryBlocks
    SET 25 __STR_CONST_0
    MOV 36 25
    CALL __FCALL_2_print
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    MOV 25 30
    MOV 36 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 25 0
    CALL __FCALL_4_createProcess
    MOV 25 26
    SET 26 __STR_CONST_10
    MOV 36 26
    CALL __FCALL_2_print
    MOV 36 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_11
    MOV 36 26
    CALL __FCALL_2_print
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    MOV 26 30
    MOV 36 26
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_12
    MOV 36 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 26 256
    SETTIMER 26
    SET 26 0
    CALL __FCALL_4_unlockMemory
    SET 26 0
    CALL __FCALL_4_loadStackAndRun
    RET

__STR_CONST_0:
    .TEXT "Number of open memory blocks: "
__STR_CONST_1:
    .TEXT "KERNEL Memory BINEND: "
__STR_CONST_2:
    .TEXT " Prog Size Byte: "
__STR_CONST_3:
    .TEXT "ERROR in createProcess(): Not enough memory to load program"
__STR_CONST_4:
    .TEXT "Allocating..."
__STR_CONST_5:
    .TEXT " "
__STR_CONST_6:
    .TEXT " Process Index: "
__STR_CONST_7:
    .TEXT " Memory Index: "
__STR_CONST_8:
    .TEXT " Process State: "
__STR_CONST_9:
    .TEXT "ERROR in createProcess(): Could not find process slot."
__STR_CONST_10:
    .TEXT " Creation Status: "
__STR_CONST_11:
    .TEXT "Number of open memory blocks: "
__STR_CONST_12:
    .TEXT "LAUNCH PROCESS"
__STR_CONST_13:
    .TEXT "TIMER TICK"
__STR_CONST_14:
    .TEXT "Bad Instruction!"
__ALLOC_0:
    .ALLOC 10
__ALLOC_1:
    .ALLOC 256
__BINEND: