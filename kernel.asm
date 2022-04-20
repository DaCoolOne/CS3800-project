
    JMP __INTER_INIT
    JMP __INTER_0_TimerTick
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
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
    MOV 35 33
    SET 36 1
    RSHIFT 36 34 36
    ADD 35 35 36
    LD 35
    SET 36 1
    AND 36 34 36
    CJMP 36 __IF_0_C0_BODY
    SET 36 8
    RSHIFT 35 35 36
    JMP __IF_0_END
__IF_0_C0_BODY:
    SET 36 255
    AND 35 35 36
__IF_0_END:
    RET

__FCALL_2_print:
    SET 31 0
    MOV 34 31
    MOV 33 30
    CALL __FCALL_3_getChar
    MOV 32 35
    JMP __LOOP_3_EVAL
__LOOP_3_BODY:
    PRINTL 32
    INC 31
    MOV 34 31
    MOV 33 30
    CALL __FCALL_3_getChar
    MOV 32 35
__LOOP_3_EVAL:
    MOV 33 32
    CJMP 33 __LOOP_3_BODY
    RET

__FCALL_2_newline:
    SET 30 10
    PRINTL 30
    RET

__INTER_0_TimerTick:
    SET 25 __STR_CONST_3
    MOV 30 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 25 32768
    SETTIMER 25
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


__FCALL_2_printU:
    SET 31 1
    JMP __LOOP_6_EVAL
__LOOP_6_BODY:
    SET 32 10
    LMUL 31 31 32
__LOOP_6_EVAL:
    SET 32 10
    DIV 32 30 32
    GTR 32 32 31
    CJMP 32 __LOOP_6_BODY
    JMP __LOOP_7_EVAL
__LOOP_7_BODY:
    DIV 32 30 31
    SET 33 48
    ADD 33 32 33
    PRINTL 33
    LMUL 33 32 31
    SUB 30 30 33
    SET 33 10
    DIV 31 31 33
__LOOP_7_EVAL:
    SET 33 0
    GTR 33 31 33
    CJMP 33 __LOOP_7_BODY
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


__FCALL_1_createProcess:
    SET 25 __STR_CONST_0
    MOV 30 25
    CALL __FCALL_2_print
    SET 25 __BINEND

    CALL __FCALL_2_printHex
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
    SET 28 0
    ADD 29 23 27
    ST 28 29
    MOV 26 27
    INC 26
    SET 25 0
__IF_2_END:
    INC 27
__LOOP_5_EVAL:
    SET 28 10
    GTR 28 28 27
    BAND 28 25 28
    CJMP 28 __LOOP_5_BODY
    SET 28 __STR_CONST_1
    MOV 30 28
    CALL __FCALL_2_print
    MOV 30 26
    CALL __FCALL_2_printU
    SET 28 1
    SET 29 -1
    SET 27 0
    JMP __LOOP_8_EVAL
__LOOP_8_BODY:
    ADD 30 24 27
    LD 30
    SET 31 0
    EQ 30 30 31
    CJMP 30 __IF_3_C0_BODY
    JMP __IF_3_END
__IF_3_C0_BODY:
    SET 30 8
    LSHIFT 30 26 30
    ADD 31 24 27
    ST 30 31
    MOV 29 27
    SET 28 0
__IF_3_END:
    INC 27
__LOOP_8_EVAL:
    SET 30 256
    GTR 30 30 27
    BAND 30 28 30
    CJMP 30 __LOOP_8_BODY
    SET 30 __STR_CONST_2
    CALL __FCALL_2_print
    MOV 30 29
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    RET

__FCALL_1_main:
    CALL __FCALL_1_initializeProcessArray
    CALL __FCALL_1_initializeMemoryBlocks
    CALL __FCALL_1_createProcess
    CALL __FCALL_1_createProcess
    CALL __FCALL_1_createProcess
    CALL __FCALL_1_createProcess
    CALL __FCALL_1_createProcess
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
    .TEXT "UwU"
__ALLOC_0:
    .ALLOC 10
__ALLOC_1:
    .ALLOC 256
__BINEND: