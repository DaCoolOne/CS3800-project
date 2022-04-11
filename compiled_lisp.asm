
    JMP 0_init
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt
    JMP 0_defaultInterrupt

0_init:
    CALL __FCALL_main
    SHUTDOWN 0

0_defaultInterrupt:
    RETI

__FCALL_3_getChar:
    SET 28 1
    RSHIFT 28 27 28
    MOV 28 26
    ADD 28 28 28
    LD 28
    SET 29 1
    AND 29 27 29
    CJMP 29 __IF_0_C0_BODY
    SET 29 8
    RSHIFT 28 28 29
    JMP __IF_0_END
__IF_0_C0_BODY:
    SET 29 15
    AND 28 28 29
__IF_0_END:
    RET

__FCALL_2_print:
    SET 24 0
    MOV 27 24
    MOV 26 23
    CALL __FCALL_3_getChar
    MOV 25 28
    JMP __LOOP_0_EVAL
__LOOP_0_BODY:
    PRINTL 25
    INC 24
    MOV 27 24
    MOV 26 23
    CALL __FCALL_3_getChar
    MOV 25 28
__LOOP_0_EVAL:
    MOV 26 25
    CJMP 26 __LOOP_0_BODY
    RET

__FCALL_1_main:
    SET 23 __STR_CONST_0
    CALL __FCALL_2_print
    RET
__STR_CONST_0:
    .TEXT "Hello World"
