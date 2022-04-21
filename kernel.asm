
    JMP __INTER_INIT
    JMP __INTER_0_TimerTick
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
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

__INTER_0_TimerTick:
__LOOP_15_BODY:
    JMP __LOOP_15_BODY
    SET 25 4
    SETTIMER 25
    RETI
__FCALL_2_newline:
    SET 26 10
    PRINTL 26
    RET

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

__INTER_0_UserDefined1:
    MOV 25 0
    USR_ADDR 25


    MOV 36 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    RETI
__INTER_0_defaultInterrupt:
    RETI

__FCALL_4_unlockMemory:
    LOCK 16
    SET 27 0
    JMP __LOOP_12_EVAL
__LOOP_12_BODY:
    ADD 28 24 27
    LD 28
    SET 29 8
    RSHIFT 28 28 29
    EQ 28 28 26
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
    SET 31 0
    SET 32 0
    JMP __LOOP_4_EVAL
__LOOP_4_BODY:
    ADD 33 24 32
    LD 33
    SET 34 0
    EQ 33 33 34
    CJMP 33 __IF_1_C0_BODY
    JMP __IF_1_END
__IF_1_C0_BODY:
    INC 31
__IF_1_END:
    INC 32
__LOOP_4_EVAL:
    SET 33 256
    GTR 33 33 32
    CJMP 33 __LOOP_4_BODY
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

__FCALL_4_findOpenProcessSlot:
    SET 30 1
    SET 31 -1
    SET 32 0
    JMP __LOOP_8_EVAL
__LOOP_8_BODY:
    ADD 33 23 32
    LD 33

    SET 34 -1
    EQ 33 33 34
    CJMP 33 __IF_3_C0_BODY
    JMP __IF_3_END
__IF_3_C0_BODY:
    MOV 31 32
    SET 30 0
__IF_3_END:
    INC 32
__LOOP_8_EVAL:
    SET 33 10
    GTR 33 33 32
    BAND 33 30 33
    CJMP 33 __LOOP_8_BODY
    RET

__FCALL_2_printHex:
    SET 29 61440
    SET 30 0
    JMP __LOOP_7_EVAL
__LOOP_7_BODY:
    AND 31 29 28
    SET 32 3
    SUB 32 32 30
    SET 33 2
    LSHIFT 32 32 33
    RSHIFT 31 31 32
    SET 32 9
    GTEQ 32 32 31
    CJMP 32 __IF_2_C0_BODY
    SET 32 55
    ADD 32 31 32
    PRINTL 32
    JMP __IF_2_END
__IF_2_C0_BODY:
    SET 32 48
    ADD 32 31 32
    PRINTL 32
__IF_2_END:
    SET 32 4
    RSHIFT 29 29 32
    INC 30
__LOOP_7_EVAL:
    SET 32 4
    GTR 32 32 30
    CJMP 32 __LOOP_7_BODY
    RET

__FCALL_3_min:
    GTR 38 36 37
    CJMP 38 __IF_7_C0_BODY
    JMP __IF_7_END
__IF_7_C0_BODY:
    MOV 36 37
__IF_7_END:
    RET

__FCALL_4_setProcessState:
    ADD 38 23 36
    LD 38
    SET 39 0
    ADD 40 38 39
    ST 37 40
    RET


__FCALL_4_setProgramCounter:
    ADD 38 23 36
    LD 38
    SET 39 1
    ADD 40 38 39
    ST 37 40
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

__FCALL_4_getProcessState:
    ADD 37 23 36
    LD 37
    SET 38 0
    ADD 37 37 38
    LD 37
    RET

__FCALL_4_allocateNextBlock:
    SET 36 1
    SET 37 -1
    SET 38 0
    JMP __LOOP_9_EVAL
__LOOP_9_BODY:
    ADD 39 24 38
    LD 39
    SET 40 0
    EQ 39 39 40
    CJMP 39 __IF_6_C0_BODY
    JMP __IF_6_END
__IF_6_C0_BODY:
    SET 39 8
    LSHIFT 39 34 39
    OR 39 39 35
    ADD 40 24 38
    ST 39 40
    MOV 37 38
    SET 36 0
__IF_6_END:
    INC 38
__LOOP_9_EVAL:
    SET 39 256
    GTR 39 39 38
    BAND 39 36 39
    CJMP 39 __LOOP_9_BODY
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

__FCALL_4_extFetch:
    SET 38 0
    EXTFETCH 36 38 37
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

__FCALL_4_createProcess:
    SET 27 0
    SET 28 __STR_CONST_1
    MOV 36 28
    CALL __FCALL_2_print
    SET 28 __BINEND

    CALL __FCALL_2_printHex
    SET 28 0
    MOV 37 28
    MOV 36 26
    CALL __FCALL_4_extFetch
    MOV 28 18
    SET 29 8
    RSHIFT 29 18 29
    INC 29
    CALL __FCALL_4_findOpenProcessSlot
    MOV 30 31
    SET 31 -1
    EQ 31 30 31
    CJMP 31 __IF_4_C0_BODY
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    GTR 31 31 29
    CJMP 31 __IF_5_C0_BODY
    SET 31 __STR_CONST_2
    MOV 36 31
    CALL __FCALL_2_print
    SET 27 2
    JMP __IF_5_END
__IF_5_C0_BODY:
    MOV 31 30
    INC 31
    SET 32 0
    MOV 35 32
    MOV 34 31
    CALL __FCALL_4_allocateNextBlock
    MOV 31 37
    SET 32 1
    SET 33 1
    JMP __LOOP_10_EVAL
__LOOP_10_BODY:
    MOV 34 30
    INC 34
    MOV 35 33
    CALL __FCALL_4_allocateNextBlock
    MOV 34 37
    SET 35 0
    JMP __LOOP_11_EVAL
__LOOP_11_BODY:
    MOV 37 32
    MOV 36 26
    CALL __FCALL_4_extFetch
    SET 36 8
    LSHIFT 36 34 36

    ADD 37 36 35
    ST 18 37
    INC 32
    INC 35
__LOOP_11_EVAL:
    SET 36 8
    LSHIFT 36 33 36
    SUB 36 28 36
    SET 37 256
    CALL __FCALL_3_min
    GTR 36 36 35
    CJMP 36 __LOOP_11_BODY
    INC 33
__LOOP_10_EVAL:
    GTEQ 36 29 33
    CJMP 36 __LOOP_10_BODY
    SET 36 8
    LSHIFT 36 31 36

    ADD 37 23 30
    ST 36 37
    SET 36 0
    MOV 37 36
    MOV 36 30
    CALL __FCALL_4_setProcessState
    MOV 36 30
    CALL __FCALL_4_saveUserRegisters
    SET 36 0
    MOV 37 36
    MOV 36 30
    CALL __FCALL_4_setProgramCounter
    MOV 36 30
    CALL __FCALL_4_defaultStack
    SET 36 __STR_CONST_3
    CALL __FCALL_2_print
    MOV 36 30
    CALL __FCALL_2_printU
    SET 36 __STR_CONST_4
    CALL __FCALL_2_print
    MOV 36 31
    CALL __FCALL_2_printU
    SET 36 __STR_CONST_5
    CALL __FCALL_2_print
    MOV 36 30
    CALL __FCALL_4_getProcessState
    MOV 36 37
    CALL __FCALL_2_printU
__IF_5_END:
    JMP __IF_4_END
__IF_4_C0_BODY:
    SET 36 __STR_CONST_6
    CALL __FCALL_2_print
    SET 27 1
__IF_4_END:
    RET


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
    JMP __LOOP_13_EVAL
__LOOP_13_BODY:
    POP 28
__LOOP_13_EVAL:
    MOV 29 17
    CJMP 29 __LOOP_13_BODY
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

__FCALL_1_main:
    CALL __FCALL_1_initializeProcessArray
    CALL __FCALL_1_initializeMemoryBlocks
    SET 25 __STR_CONST_0
    MOV 36 25
    CALL __FCALL_2_print
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    MOV 25 31
    MOV 36 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 25 0
    MOV 26 25
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_7
    MOV 36 26
    CALL __FCALL_2_print
    MOV 36 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_8
    MOV 36 26
    CALL __FCALL_2_print
    MOV 36 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_9
    MOV 36 26
    CALL __FCALL_2_print
    MOV 36 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_10
    MOV 36 26
    CALL __FCALL_2_print
    MOV 36 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_11
    MOV 36 26
    CALL __FCALL_2_print
    MOV 36 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_12
    MOV 36 26
    CALL __FCALL_2_print
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    MOV 26 31
    MOV 36 26
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 256
    SETTIMER 26
    SET 26 1
    CALL __FCALL_4_unlockMemory
    SET 26 1
    CALL __FCALL_4_loadStackAndRun
    RET

__STR_CONST_0:
    .TEXT "Number of open memory blocks: "
__STR_CONST_1:
    .TEXT "KERNEL Memory BINEND: "
__STR_CONST_2:
    .TEXT "ERROR in createProcess(): Not enough memory to load program"
__STR_CONST_3:
    .TEXT " Process Index: "
__STR_CONST_4:
    .TEXT " Memory Index: "
__STR_CONST_5:
    .TEXT " Process State: "
__STR_CONST_6:
    .TEXT "ERROR in createProcess(): Could not find process slot."
__STR_CONST_7:
    .TEXT " Creation Status: "
__STR_CONST_8:
    .TEXT " Creation Status: "
__STR_CONST_9:
    .TEXT " Creation Status: "
__STR_CONST_10:
    .TEXT " Creation Status: "
__STR_CONST_11:
    .TEXT " Creation Status: "
__STR_CONST_12:
    .TEXT "Number of open memory blocks: "
__ALLOC_0:
    .ALLOC 10
__ALLOC_1:
    .ALLOC 256
__BINEND: