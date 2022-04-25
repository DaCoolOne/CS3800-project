
__INTER_INIT:
    SET 2 849
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_2_printTaggedNum:
    MOV 10 8
    MOV 0 10
    MOV 1 9
    SET 10 10
    RAISE 10
    RET

__FCALL_1_hash16:
    SET 6 0
    SET 7 0
    MUL 6 4 5
    SET 8 __STR_CONST_0
    MOV 9 6
    CALL __FCALL_2_printTaggedNum
    SET 8 __STR_CONST_1
    MOV 9 7
    CALL __FCALL_2_printTaggedNum
    XOR 4 7 6
    RET

__FCALL_1_randInt:
    SET 4 64533
    ADD 2 2 4
    SET 4 683
    MOV 5 4
    MOV 4 2
    CALL __FCALL_1_hash16
    RET

__FCALL_2_printU:
    MOV 0 4
    SET 5 8
    RAISE 5
    RET

__FCALL_1_main:
    SET 3 0
    JMP __LOOP_21_EVAL
__LOOP_21_BODY:
    CALL __FCALL_1_randInt
    CALL __FCALL_2_printU
    INC 3
__LOOP_21_EVAL:
    SET 4 50
    GTR 4 4 3
    CJMP 4 __LOOP_21_BODY
    RET

__STR_CONST_0:
    .TEXT "Hash low "
__STR_CONST_1:
    .TEXT "Hash high "

__BINEND: