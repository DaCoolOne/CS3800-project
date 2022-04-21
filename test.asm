
__INTER_INIT:
    SET 1 __ALLOC_0
    SET 2 0
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_2_print:
    MOV 6 5
    MOV 0 6
    SET 6 6
    RAISE 6
    RET

__FCALL_3_setChar:
    MOV 12 9
    SET 13 1
    RSHIFT 13 11 13
    ADD 12 12 13
    LD 12
    SET 13 1
    AND 13 11 13
    CJMP 13 __IF_9_C0_BODY
    SET 13 8
    LSHIFT 13 10 13
    OR 12 13 12
    JMP __IF_9_END
__IF_9_C0_BODY:
    SET 13 255
    AND 13 10 13
    OR 12 13 12
__IF_9_END:
    MOV 13 9
    SET 14 1
    RSHIFT 14 11 14
    ADD 15 13 14
    ST 12 15
    RET

__FCALL_2_uncheckedBuffer:
    MOV 9 1
    MOV 11 2
    MOV 10 8
    CALL __FCALL_3_setChar
    INC 2
    RET

__FCALL_2_bufferflush:
    SET 8 0
    CALL __FCALL_2_uncheckedBuffer
    MOV 8 1
    SET 9 6
    RAISE 9
    SET 2 0
    RET

__FCALL_2_printU:
    SET 6 1
    JMP __LOOP_17_EVAL
__LOOP_17_BODY:
    SET 7 10
    LMUL 6 6 7
__LOOP_17_EVAL:
    SET 7 10
    DIV 7 5 7
    GTEQ 7 7 6
    CJMP 7 __LOOP_17_BODY
    JMP __LOOP_18_EVAL
__LOOP_18_BODY:
    DIV 7 5 6
    SET 8 48
    ADD 8 7 8
    PRINTL 8
    LMUL 8 7 6
    SUB 5 5 8
    SET 8 10
    DIV 6 6 8
__LOOP_18_EVAL:
    SET 8 0
    GTR 8 6 8
    CJMP 8 __LOOP_18_BODY
    CALL __FCALL_2_bufferflush
    RET

__FCALL_1_main:
    SET 3 1
    SET 4 0
    SET 5 __STR_CONST_0
    CALL __FCALL_2_print
    JMP __LOOP_16_EVAL
__LOOP_16_BODY:
    MOV 5 3
    CALL __FCALL_2_printU
    MOV 5 3
    ADD 3 3 4
    MOV 4 5
__LOOP_16_EVAL:
    SET 6 10000
    GTR 6 6 3
    CJMP 6 __LOOP_16_BODY
    RET

__STR_CONST_0:
    .TEXT "Fibonacci Sequence"
__ALLOC_0:
    .ALLOC 10
__BINEND: