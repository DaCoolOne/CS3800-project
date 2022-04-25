
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

__FCALL_2_printTaggedNum:
    MOV 5 3
    MOV 0 5
    MOV 1 4
    SET 5 10
    RAISE 5
    RET

__FCALL_1_main:
    SET 2 1
    SET 3 __STR_CONST_0
    CALL __FCALL_2_print
    JMP __LOOP_23_EVAL
__LOOP_23_BODY:
    SET 3 15
    MOD 3 2 3
    SET 4 0
    EQ 3 3 4
    CJMP 3 __IF_26_C0_BODY
    SET 3 3
    MOD 3 2 3
    SET 4 0
    EQ 3 3 4
    CJMP 3 __IF_26_C1_BODY
    SET 3 5
    MOD 3 2 3
    SET 4 0
    EQ 3 3 4
    CJMP 3 __IF_26_C2_BODY
    MOV 3 2
    CALL __FCALL_2_printU
    JMP __IF_26_END
__IF_26_C0_BODY:
    SET 3 __STR_CONST_1
    MOV 4 2
    CALL __FCALL_2_printTaggedNum
    JMP __IF_26_END
__IF_26_C1_BODY:
    SET 3 __STR_CONST_2
    MOV 4 2
    CALL __FCALL_2_printTaggedNum
    JMP __IF_26_END
__IF_26_C2_BODY:
    SET 3 __STR_CONST_3
    MOV 4 2
    CALL __FCALL_2_printTaggedNum
__IF_26_END:
    INC 2
__LOOP_23_EVAL:
    SET 3 100
    GTEQ 3 3 2
    CJMP 3 __LOOP_23_BODY
    RET

__STR_CONST_0:
    .TEXT "FizzBuzz Program"
__STR_CONST_1:
    .TEXT "FizzBuzz, "
__STR_CONST_2:
    .TEXT "Fizz, "
__STR_CONST_3:
    .TEXT "Buzz, "

__BINEND: