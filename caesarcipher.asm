
__INTER_INIT:
    SET 2 __STR_CONST_0
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_3_setChar:
    MOV 10 7
    SET 11 1
    RSHIFT 11 9 11
    ADD 10 10 11
    LD 10
    SET 11 1
    AND 11 9 11
    CJMP 11 __IF_29_C0_BODY
    SET 11 8
    LSHIFT 11 8 11
    SET 12 255
    AND 12 10 12
    OR 10 11 12
    JMP __IF_29_END
__IF_29_C0_BODY:
    SET 11 255
    AND 11 8 11
    SET 12 65280
    AND 12 10 12
    OR 10 11 12
__IF_29_END:
    MOV 11 7
    SET 12 1
    RSHIFT 12 9 12
    ADD 13 11 12
    ST 10 13
    RET

__FCALL_3_getChar:
    MOV 11 9
    SET 12 1
    RSHIFT 12 10 12
    ADD 11 11 12
    LD 11
    SET 12 1
    AND 12 10 12
    CJMP 12 __IF_27_C0_BODY
    SET 12 8
    RSHIFT 11 11 12
    JMP __IF_27_END
__IF_27_C0_BODY:
    SET 12 255
    AND 11 11 12
__IF_27_END:
    RET

__FCALL_3_strLen:
    SET 8 0
    JMP __LOOP_23_EVAL
__LOOP_23_BODY:
    INC 8
__LOOP_23_EVAL:
    MOV 10 8
    MOV 9 7
    CALL __FCALL_3_getChar
    MOV 9 11
    CJMP 9 __LOOP_23_BODY
    RET


__FCALL_1_encode:
    SET 5 0
    JMP __LOOP_24_EVAL
__LOOP_24_BODY:
    MOV 10 5
    MOV 9 2
    CALL __FCALL_3_getChar
    MOV 6 11
    SET 7 32
    GTEQ 7 6 7
    SET 8 126
    GTEQ 8 8 6
    BAND 7 7 8
    CJMP 7 __IF_30_C0_BODY
    JMP __IF_30_END
__IF_30_C0_BODY:
    SET 7 32
    SUB 7 6 7
    ADD 7 7 4
    SET 8 95
    MOD 7 7 8
    SET 8 32
    ADD 6 7 8
    MOV 9 5
    MOV 8 6
    MOV 7 2
    CALL __FCALL_3_setChar
__IF_30_END:
    INC 5
__LOOP_24_EVAL:
    MOV 7 2
    CALL __FCALL_3_strLen
    MOV 7 8
    GTR 7 7 5
    CJMP 7 __LOOP_24_BODY
    RET

__FCALL_2_print:
    MOV 5 4
    MOV 0 5
    SET 5 6
    RAISE 5
    RET




__FCALL_1_decode:
    SET 5 0
    JMP __LOOP_22_EVAL
__LOOP_22_BODY:
    MOV 10 5
    MOV 9 2
    CALL __FCALL_3_getChar
    MOV 6 11
    SET 7 32
    GTEQ 7 6 7
    SET 8 126
    GTEQ 8 8 6
    BAND 7 7 8
    CJMP 7 __IF_28_C0_BODY
    JMP __IF_28_END
__IF_28_C0_BODY:
    SET 7 32
    SUB 7 6 7
    SET 8 95
    SUB 8 8 4
    ADD 7 7 8
    SET 8 95
    MOD 7 7 8
    SET 8 32
    ADD 6 7 8
    MOV 9 5
    MOV 8 6
    MOV 7 2
    CALL __FCALL_3_setChar
__IF_28_END:
    INC 5
__LOOP_22_EVAL:
    MOV 7 2
    CALL __FCALL_3_strLen
    MOV 7 8
    GTR 7 7 5
    CJMP 7 __LOOP_22_BODY
    RET

__FCALL_2_printTaggedNum:
    MOV 6 4
    MOV 0 6
    MOV 1 5
    SET 6 10
    RAISE 6
    RET

__FCALL_1_main:
    SET 3 __STR_CONST_1
    MOV 4 3
    CALL __FCALL_2_print
    MOV 4 2
    CALL __FCALL_2_print
    SET 3 0
    JMP __LOOP_21_EVAL
__LOOP_21_BODY:
    SET 4 2
    MOD 4 3 4
    SET 5 0
    EQ 4 4 5
    CJMP 4 __IF_26_C0_BODY
    MOV 4 3
    CALL __FCALL_1_decode
    JMP __IF_26_END
__IF_26_C0_BODY:
    MOV 4 3
    CALL __FCALL_1_encode
__IF_26_END:
    SET 4 __STR_CONST_2
    CALL __FCALL_2_print
    SET 4 11100
    ADD 4 4 3
    MOV 5 4
    MOV 4 2
    CALL __FCALL_2_printTaggedNum
    INC 3
__LOOP_21_EVAL:
    SET 4 95
    GTR 4 4 3
    CJMP 4 __LOOP_21_BODY
    SET 3 94
    JMP __LOOP_25_EVAL
__LOOP_25_BODY:
    SET 4 2
    MOD 4 3 4
    SET 5 0
    EQ 4 4 5
    CJMP 4 __IF_31_C0_BODY
    MOV 4 3
    CALL __FCALL_1_encode
    JMP __IF_31_END
__IF_31_C0_BODY:
    MOV 4 3
    CALL __FCALL_1_decode
__IF_31_END:
    SET 4 __STR_CONST_3
    CALL __FCALL_2_print
    SET 4 11100
    ADD 4 4 3
    MOV 5 4
    MOV 4 2
    CALL __FCALL_2_printTaggedNum
    DEC 3
__LOOP_25_EVAL:
    SET 4 0
    GTEQ 4 3 4
    CJMP 4 __LOOP_25_BODY
    RET

__STR_CONST_0:
    .TEXT "Hello World!"
__STR_CONST_1:
    .TEXT "Caesar Cipher"
__STR_CONST_2:
    .TEXT "Encoding"
__STR_CONST_3:
    .TEXT "Decoding"

__BINEND: