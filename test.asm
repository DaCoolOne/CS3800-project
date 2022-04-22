
__INTER_INIT:
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_2_print:
    MOV 4 3
    MOV 0 4
    SET 4 6
    RAISE 4
    RET

__FCALL_2_printU:
    MOV 0 3
    SET 4 8
    RAISE 4
    RET

__FCALL_1_main:
    SET 1 0
    SET 2 1
    SET 3 __STR_CONST_0
    CALL __FCALL_2_print
    JMP __LOOP_19_EVAL
__LOOP_19_BODY:
    MOV 3 1
    CALL __FCALL_2_printU
    ADD 3 1 2
    MOV 1 2
    MOV 2 3
__LOOP_19_EVAL:
    SET 4 10000
    GTR 4 4 1
    CJMP 4 __LOOP_19_BODY
    RET

__STR_CONST_0:
    .TEXT "Fibonacci Sequence"

__BINEND: