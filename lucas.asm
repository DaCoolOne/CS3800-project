
__INTER_INIT:
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_2_print:
    MOV 5 4
    MOV 0 5
    SET 5 6
    RAISE 5
    RET

__FCALL_2_printU:
    MOV 0 4
    SET 5 8
    RAISE 5
    RET

__FCALL_1_main:
    SET 2 2
    SET 3 1
    SET 4 __STR_CONST_0
    CALL __FCALL_2_print
    JMP __LOOP_21_EVAL
__LOOP_21_BODY:
    MOV 4 2
    CALL __FCALL_2_printU
    ADD 4 2 3
    MOV 2 3
    MOV 3 4
__LOOP_21_EVAL:
    SET 5 10000
    GTR 5 5 2
    CJMP 5 __LOOP_21_BODY
    RET

__STR_CONST_0:
    .TEXT "Lucas Number"

__BINEND: