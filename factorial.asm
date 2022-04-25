
__INTER_INIT:
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_2_printU:
    MOV 0 4
    SET 5 8
    RAISE 5
    RET

__FCALL_2_print:
    MOV 2 1
    MOV 0 2
    SET 2 6
    RAISE 2
    RET

__FCALL_1_main:
    SET 1 __STR_CONST_0
    CALL __FCALL_2_print
    SET 1 0
    JMP __LOOP_20_EVAL
__LOOP_20_BODY:
    SET 2 1
    SET 3 1
    GTEQ 3 2 3
    CJMP 3 __IF_23_C0_BODY
    JMP __IF_23_END
__IF_23_C0_BODY:
    SET 3 0
    JMP __LOOP_21_EVAL
__LOOP_21_BODY:
    LMUL 2 1 3
    INC 3
__LOOP_21_EVAL:
    GTR 4 1 3
    CJMP 4 __LOOP_21_BODY
__IF_23_END:
    MOV 4 2
    CALL __FCALL_2_printU
    INC 1
__LOOP_20_EVAL:
    SET 4 9
    GTR 4 4 1
    CJMP 4 __LOOP_20_BODY
    RET

__STR_CONST_0:
    .TEXT "Factorial 1 to 8"

__BINEND: