
__INTER_INIT:
    SET 2 __ALLOC_0
    SET 3 849
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_2_print:
    MOV 12 11
    MOV 0 12
    SET 12 6
    RAISE 12
    RET


__FCALL_2_printTaggedNum:
    MOV 11 9
    MOV 0 11
    MOV 1 10
    SET 11 10
    RAISE 11
    RET

__FCALL_1_printArray:
    SET 8 __STR_CONST_1
    MOV 11 8
    CALL __FCALL_2_print
    SET 8 0
    JMP __LOOP_22_EVAL
__LOOP_22_BODY:
    SET 9 __STR_CONST_2
    ADD 10 2 8
    LD 10
    CALL __FCALL_2_printTaggedNum
    INC 8
__LOOP_22_EVAL:
    SET 9 30
    GTR 9 9 8
    CJMP 9 __LOOP_22_BODY
    RET

__FCALL_3_hash16:
    SET 7 0
    SET 8 0
    MUL 7 5 6
    XOR 5 8 7
    RET

__FCALL_3_randInt:
    SET 5 64533
    ADD 3 3 5
    SET 5 683
    MOV 6 5
    MOV 5 3
    CALL __FCALL_3_hash16
    RET

__FCALL_1_main:
    SET 4 0
    JMP __LOOP_21_EVAL
__LOOP_21_BODY:
    CALL __FCALL_3_randInt
    SET 6 100
    MOD 5 5 6
    ADD 6 2 4
    ST 5 6
    INC 4
__LOOP_21_EVAL:
    SET 5 30
    GTR 5 5 4
    CJMP 5 __LOOP_21_BODY
    SET 5 __STR_CONST_0
    MOV 11 5
    CALL __FCALL_2_print
    CALL __FCALL_1_printArray
    SET 5 0
    JMP __LOOP_23_EVAL
__LOOP_23_BODY:
    SET 5 1
    SET 4 1
    JMP __LOOP_24_EVAL
__LOOP_24_BODY:
    MOV 6 4
    DEC 6
    ADD 6 2 6
    LD 6
    ADD 7 2 4
    LD 7
    GTR 8 6 7
    CJMP 8 __IF_27_C0_BODY
    JMP __IF_27_END
__IF_27_C0_BODY:
    SET 5 0
    ADD 8 2 4
    ST 6 8
    MOV 8 4
    DEC 8
    ADD 9 2 8
    ST 7 9
__IF_27_END:
    INC 4
__LOOP_24_EVAL:
    SET 8 30
    GTR 8 8 4
    CJMP 8 __LOOP_24_BODY
__LOOP_23_EVAL:
    SET 8 0
    EQ 8 5 8
    CJMP 8 __LOOP_23_BODY
    SET 8 __STR_CONST_3
    MOV 11 8
    CALL __FCALL_2_print
    CALL __FCALL_1_printArray
    RET

__STR_CONST_0:
    .TEXT "Unsorted array:"
__STR_CONST_1:
    .TEXT "Array:"
__STR_CONST_2:
    .TEXT " -> "
__STR_CONST_3:
    .TEXT "Sorted array:"
__ALLOC_0:
    .ALLOC 30
__BINEND: