
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

__FCALL_3_getChar:
    MOV 32 30
    SET 33 1
    RSHIFT 33 31 33
    ADD 32 32 33
    LD 32
    SET 33 1
    AND 33 31 33
    CJMP 33 __IF_0_C0_BODY
    SET 33 8
    RSHIFT 32 32 33
    JMP __IF_0_END
__IF_0_C0_BODY:
    SET 33 255
    AND 32 32 33
__IF_0_END:
    RET

__FCALL_2_print:
    SET 28 0
    MOV 31 28
    MOV 30 27
    CALL __FCALL_3_getChar
    MOV 29 32
    JMP __LOOP_3_EVAL
__LOOP_3_BODY:
    PRINTL 29
    INC 28
    MOV 31 28
    MOV 30 27
    CALL __FCALL_3_getChar
    MOV 29 32
__LOOP_3_EVAL:
    MOV 30 29
    CJMP 30 __LOOP_3_BODY
    RET

__FCALL_2_newline:
    SET 27 10
    PRINTL 27
    RET

__INTER_0_TimerTick:
    SET 25 __STR_CONST_6
    MOV 27 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 25 32768
    SETTIMER 25
    RETI


__INTER_0_UserDefined1:
    MOV 25 0
    USR_ADDR 25


    MOV 27 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    RETI
__INTER_0_defaultInterrupt:
    RETI


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


__FCALL_4_setProcessState:
    ADD 29 23 27
    LD 29
    SET 30 0
    ADD 31 29 30
    ST 28 31
    RET

__FCALL_4_getProcessState:
    ADD 28 23 27
    LD 28
    SET 29 0
    ADD 28 28 29
    LD 28
    RET

__FCALL_4_findOpenProcessSlot:
    SET 25 1
    SET 26 -1
    SET 27 0
    JMP __LOOP_5_EVAL
__LOOP_5_BODY:
    ADD 28 23 27
    LD 28

    SET 29 -1
    EQ 28 28 29
    CJMP 28 __IF_2_C0_BODY
    JMP __IF_2_END
__IF_2_C0_BODY:
    MOV 26 27
    SET 25 0
__IF_2_END:
    INC 27
__LOOP_5_EVAL:
    SET 28 10
    GTR 28 28 27
    BAND 28 25 28
    CJMP 28 __LOOP_5_BODY
    RET

__FCALL_4_setProgramCounter:
    ADD 29 23 27
    LD 29
    SET 30 1
    ADD 31 29 30
    ST 28 31
    RET

__FCALL_2_printU:
    SET 28 1
    JMP __LOOP_7_EVAL
__LOOP_7_BODY:
    SET 29 10
    LMUL 28 28 29
__LOOP_7_EVAL:
    SET 29 10
    DIV 29 27 29
    GTR 29 29 28
    CJMP 29 __LOOP_7_BODY
    JMP __LOOP_8_EVAL
__LOOP_8_BODY:
    DIV 29 27 28
    SET 30 48
    ADD 30 29 30
    PRINTL 30
    LMUL 30 29 28
    SUB 27 27 30
    SET 30 10
    DIV 28 28 30
__LOOP_8_EVAL:
    SET 30 0
    GTR 30 28 30
    CJMP 30 __LOOP_8_BODY
    RET


__FCALL_4_allocateNextBlock:
    SET 27 1
    SET 28 -1
    SET 29 0
    JMP __LOOP_6_EVAL
__LOOP_6_BODY:
    ADD 30 24 29
    LD 30
    SET 31 0
    EQ 30 30 31
    CJMP 30 __IF_4_C0_BODY
    JMP __IF_4_END
__IF_4_C0_BODY:
    SET 30 8
    LSHIFT 30 26 30
    ADD 31 24 29
    ST 30 31
    MOV 28 29
    SET 27 0
__IF_4_END:
    INC 29
__LOOP_6_EVAL:
    SET 30 256
    GTR 30 30 29
    BAND 30 27 30
    CJMP 30 __LOOP_6_BODY
    RET

__FCALL_4_setUserRegisters:
    ADD 28 23 27
    LD 28
    SET 29 0
    SET 30 2
    ADD 31 28 30
    ST 0 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 1 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 2 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 3 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 4 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 5 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 6 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 7 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 8 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 9 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 10 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 11 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 12 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 13 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 14 31
    INC 29
    SET 30 2
    ADD 30 30 29
    ADD 31 28 30
    ST 15 31
    RET

__FCALL_2_printHex:
    SET 26 61440
    SET 27 0
    JMP __LOOP_4_EVAL
__LOOP_4_BODY:
    AND 28 26 25
    SET 29 3
    SUB 29 29 27
    SET 30 2
    LSHIFT 29 29 30
    RSHIFT 28 28 29
    SET 29 9
    GTR 29 29 28
    CJMP 29 __IF_1_C0_BODY
    SET 29 38
    ADD 29 28 29
    PRINTL 29
    JMP __IF_1_END
__IF_1_C0_BODY:
    SET 29 48
    ADD 29 28 29
    PRINTL 29
__IF_1_END:
    SET 29 4
    RSHIFT 26 26 29
    INC 27
__LOOP_4_EVAL:
    SET 29 4
    GTR 29 29 27
    CJMP 29 __LOOP_4_BODY
    RET

__FCALL_4_createProcess:
    SET 25 __STR_CONST_0
    MOV 27 25
    CALL __FCALL_2_print
    SET 25 __BINEND

    CALL __FCALL_2_printHex
    CALL __FCALL_4_findOpenProcessSlot
    MOV 25 26
    SET 26 -1
    EQ 26 25 26
    CJMP 26 __IF_3_C0_BODY
    MOV 26 25
    INC 26
    CALL __FCALL_4_allocateNextBlock
    MOV 26 28
    SET 27 -1
    EQ 27 26 27
    CJMP 27 __IF_5_C0_BODY
    SET 27 8
    LSHIFT 27 26 27

    ADD 28 23 25
    ST 27 28
    SET 27 0
    MOV 28 27
    MOV 27 25
    CALL __FCALL_4_setProcessState
    MOV 27 25
    CALL __FCALL_4_setUserRegisters
    SET 27 0
    MOV 28 27
    MOV 27 25
    CALL __FCALL_4_setProgramCounter
    SET 27 __STR_CONST_1
    CALL __FCALL_2_print
    MOV 27 25
    CALL __FCALL_2_printU
    SET 27 __STR_CONST_2
    CALL __FCALL_2_print
    MOV 27 26
    CALL __FCALL_2_printU
    SET 27 __STR_CONST_3
    CALL __FCALL_2_print
    MOV 27 25
    CALL __FCALL_4_getProcessState
    MOV 27 28
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    JMP __IF_5_END
__IF_5_C0_BODY:
    SET 27 __STR_CONST_4
    CALL __FCALL_2_print
__IF_5_END:
    JMP __IF_3_END
__IF_3_C0_BODY:
    SET 27 __STR_CONST_5
    CALL __FCALL_2_print
__IF_3_END:
    RET

__FCALL_1_main:
    CALL __FCALL_1_initializeProcessArray
    CALL __FCALL_1_initializeMemoryBlocks
    CALL __FCALL_4_createProcess
    CALL __FCALL_4_createProcess
    CALL __FCALL_4_createProcess
    CALL __FCALL_4_createProcess
    CALL __FCALL_4_createProcess
    CALL __FCALL_2_newline
__LOOP_9_BODY:
    JMP __LOOP_9_BODY
    RET

__STR_CONST_0:
    .TEXT "KERNEL Memory BINEND: "
__STR_CONST_1:
    .TEXT " Process Index: "
__STR_CONST_2:
    .TEXT " Memory Index: "
__STR_CONST_3:
    .TEXT " Process State: "
__STR_CONST_4:
    .TEXT "ERROR in createProcess(): Could not find memory block to allocate."
__STR_CONST_5:
    .TEXT "ERROR in createProcess(): Could not find process slot."
__STR_CONST_6:
    .TEXT "UwU"
__ALLOC_0:
    .ALLOC 10
__ALLOC_1:
    .ALLOC 256
__BINEND: