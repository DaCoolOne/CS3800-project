
    JMP __INTER_INIT
    JMP __INTER_0_TimerTick
    JMP __INTER_0_BadMemAccess
    JMP __INTER_0_StackOverflow
    JMP __INTER_0_StackUnderflow
    JMP __INTER_0_BadIns
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_UserDefined1
    JMP __INTER_0_UserDefined2
    JMP __INTER_0_UserDefined3
    JMP __INTER_0_UserDefined4
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

__FCALL_11_getProcessState:
    ADD 40 23 39
    LD 40
    SET 41 0
    ADD 40 40 41
    LD 40
    RET

__FCALL_4_getNextProcess:
    MOV 28 27
    INC 28
    SET 29 10
    MOD 28 28 29
    SET 29 -1
    JMP __LOOP_18_EVAL
__LOOP_18_BODY:
    ADD 30 23 28
    LD 30

    SET 31 -1
    EQ 30 30 31
    CJMP 30 __IF_12_C0_BODY
    MOV 39 28
    CALL __FCALL_11_getProcessState
    MOV 30 40
    SET 31 0
    EQ 30 30 31
    CJMP 30 __IF_13_C0_BODY
    JMP __IF_13_END
__IF_13_C0_BODY:
    MOV 29 28
__IF_13_END:
    JMP __IF_12_END
__IF_12_C0_BODY:
__IF_12_END:
    MOV 30 28
    INC 30
    SET 31 10
    MOD 28 30 31
__LOOP_18_EVAL:
    SET 30 -1
    EQ 30 29 30
    EQ 31 27 28
    SET 32 0
    EQ 31 31 32
    BAND 30 30 31
    CJMP 30 __LOOP_18_BODY
    RET

__FCALL_3_getChar:
    MOV 47 45
    SET 48 1
    RSHIFT 48 46 48
    ADD 47 47 48
    LD 47
    SET 48 1
    AND 48 46 48
    CJMP 48 __IF_0_C0_BODY
    SET 48 8
    RSHIFT 47 47 48
    JMP __IF_0_END
__IF_0_C0_BODY:
    SET 48 255
    AND 47 47 48
__IF_0_END:
    RET

__FCALL_2_print:
    SET 43 0
    MOV 46 43
    MOV 45 42
    CALL __FCALL_3_getChar
    MOV 44 47
    JMP __LOOP_3_EVAL
__LOOP_3_BODY:
    PRINTL 44
    INC 43
    MOV 46 43
    MOV 45 42
    CALL __FCALL_3_getChar
    MOV 44 47
__LOOP_3_EVAL:
    MOV 45 44
    CJMP 45 __LOOP_3_BODY
    RET

__FCALL_2_printU:
    SET 43 1
    JMP __LOOP_6_EVAL
__LOOP_6_BODY:
    SET 44 10
    LMUL 43 43 44
__LOOP_6_EVAL:
    SET 44 10
    DIV 44 42 44
    GTEQ 44 44 43
    CJMP 44 __LOOP_6_BODY
    JMP __LOOP_7_EVAL
__LOOP_7_BODY:
    DIV 44 42 43
    SET 45 48
    ADD 45 44 45
    PRINTL 45
    LMUL 45 44 43
    SUB 42 42 45
    SET 45 10
    DIV 43 43 45
__LOOP_7_EVAL:
    SET 45 0
    GTR 45 43 45
    CJMP 45 __LOOP_7_BODY
    RET

__FCALL_2_newline:
    SET 42 10
    PRINTL 42
    RET

__FCALL_8_unlockMemory:
    LOCK 16
    INC 30
    SET 31 1
    SET 32 1
    JMP __LOOP_12_EVAL
__LOOP_12_BODY:
    SET 33 0
    JMP __LOOP_13_EVAL
__LOOP_13_BODY:
    ADD 34 24 33
    LD 34
    SET 35 8
    RSHIFT 34 34 35
    EQ 34 34 30
    ADD 35 24 33
    LD 35
    SET 36 15
    AND 35 35 36
    EQ 35 35 31
    BAND 36 34 35
    CJMP 36 __IF_8_C0_BODY
    JMP __IF_8_END
__IF_8_C0_BODY:
    UNLOCK 33
    INC 31
    SET 36 __STR_CONST_27
    MOV 42 36
    CALL __FCALL_2_print
    MOV 42 33
    CALL __FCALL_2_printU
    SET 36 __STR_CONST_28
    MOV 42 36
    CALL __FCALL_2_print
    MOV 42 30
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
__IF_8_END:
    SET 36 256
    DEC 36
    EQ 36 33 36
    CJMP 36 __IF_9_C0_BODY
    JMP __IF_9_END
__IF_9_C0_BODY:
    SET 32 0
__IF_9_END:
    INC 33
__LOOP_13_EVAL:
    SET 36 256
    GTR 36 36 33
    CJMP 36 __LOOP_13_BODY
__LOOP_12_EVAL:
    MOV 36 32
    CJMP 36 __LOOP_12_BODY
    RET

__FCALL_11_setProcessState:
    ADD 44 23 42
    LD 44
    SET 45 0
    ADD 46 44 45
    ST 43 46
    RET

__FCALL_10_emptyStack:
    POP 32
    JMP __LOOP_14_EVAL
__LOOP_14_BODY:
    POP 33
__LOOP_14_EVAL:
    MOV 34 17
    CJMP 34 __LOOP_14_BODY
    PUSH 32
    RET

__FCALL_10_loadStackAndRun:
    ADD 31 23 30
    LD 31
    CALL __FCALL_10_emptyStack
    SET 32 18
    ADD 32 31 32
    LD 32
    MOV 33 32
    JMP __LOOP_15_EVAL
__LOOP_15_BODY:
    SET 34 18
    ADD 34 34 33
    ADD 34 31 34
    LD 34
    PUSH 34
    DEC 33
__LOOP_15_EVAL:
    SET 34 0
    GTR 34 33 34
    CJMP 34 __LOOP_15_BODY
    SET 34 1
    MOV 43 34
    MOV 42 30
    CALL __FCALL_11_setProcessState
    RETI
    RET

__FCALL_9_saveUserRegisters:
    ADD 39 23 38
    LD 39
    SET 40 0
    SET 41 2
    ADD 42 39 41
    ST 0 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 1 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 2 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 3 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 4 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 5 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 6 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 7 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 8 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 9 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 10 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 11 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 12 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 13 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 14 42
    INC 40
    SET 41 2
    ADD 41 41 40
    ADD 42 39 41
    ST 15 42
    RET

__FCALL_9_loadUserRegisters:
    ADD 31 23 30
    LD 31
    SET 32 0
    SET 33 2
    ADD 0 31 33
    LD 0
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 1 31 33
    LD 1
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 2 31 33
    LD 2
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 3 31 33
    LD 3
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 4 31 33
    LD 4
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 5 31 33
    LD 5
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 6 31 33
    LD 6
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 7 31 33
    LD 7
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 8 31 33
    LD 8
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 9 31 33
    LD 9
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 10 31 33
    LD 10
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 11 31 33
    LD 11
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 12 31 33
    LD 12
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 13 31 33
    LD 13
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 14 31 33
    LD 14
    INC 32
    SET 33 2
    ADD 33 33 32
    ADD 15 31 33
    LD 15
    RET


__FCALL_4_switchProcess:
    EQ 30 28 29
    CJMP 30 __IF_15_C0_BODY
    SET 30 -1
    EQ 30 28 30
    CJMP 30 __IF_16_C0_BODY
    ADD 30 23 28
    LD 30

    SET 31 -1
    EQ 30 30 31
    CJMP 30 __IF_17_C0_BODY
    SET 30 0
    MOV 43 30
    MOV 42 28
    CALL __FCALL_11_setProcessState
    MOV 38 28
    CALL __FCALL_9_saveUserRegisters
    JMP __IF_17_END
__IF_17_C0_BODY:
__IF_17_END:
    JMP __IF_16_END
__IF_16_C0_BODY:
__IF_16_END:
    MOV 30 29
    CALL __FCALL_9_loadUserRegisters
    MOV 30 29
    CALL __FCALL_8_unlockMemory
    MOV 30 29
    CALL __FCALL_10_loadStackAndRun
    JMP __IF_15_END
__IF_15_C0_BODY:
    MOV 30 29
    CALL __FCALL_10_loadStackAndRun
__IF_15_END:
    RET




__FCALL_4_getCurrentlyRunningProcess:
    SET 26 -1
    SET 27 1
    SET 28 0
    JMP __LOOP_16_EVAL
__LOOP_16_BODY:
    ADD 29 23 28
    LD 29

    SET 30 -1
    EQ 29 29 30
    CJMP 29 __IF_10_C0_BODY
    MOV 39 28
    CALL __FCALL_11_getProcessState
    MOV 29 40
    SET 30 1
    EQ 29 29 30
    CJMP 29 __IF_11_C0_BODY
    JMP __IF_11_END
__IF_11_C0_BODY:
    MOV 26 28
    SET 27 0
__IF_11_END:
    JMP __IF_10_END
__IF_10_C0_BODY:
__IF_10_END:
    INC 28
__LOOP_16_EVAL:
    SET 29 10
    GTR 29 29 28
    BAND 29 27 29
    CJMP 29 __LOOP_16_BODY
    RET

__FCALL_10_saveStack:
    POP 27
    ADD 28 23 26
    LD 28
    SET 29 18
    ADD 30 28 29
    ST 17 30
    SET 29 0
    JMP __LOOP_17_EVAL
__LOOP_17_BODY:
    POP 30
    SET 31 19
    ADD 31 31 29
    ADD 32 28 31
    ST 30 32
    INC 29
__LOOP_17_EVAL:
    MOV 30 17
    CJMP 30 __LOOP_17_BODY
    PUSH 27
    RET


__INTER_0_TimerTick:
    CALL __FCALL_4_getCurrentlyRunningProcess
    MOV 25 26
    MOV 26 25
    CALL __FCALL_10_saveStack
    MOV 27 25
    CALL __FCALL_4_getNextProcess
    MOV 26 29
    SET 27 -1
    EQ 27 26 27
    CJMP 27 __IF_14_C0_BODY
    JMP __IF_14_END
__IF_14_C0_BODY:
    MOV 26 25
__IF_14_END:
    SET 27 80
    SETTIMER 27
    CALL __FCALL_2_newline
    SET 27 __STR_CONST_29
    MOV 42 27
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    SET 27 __STR_CONST_30
    MOV 42 27
    CALL __FCALL_2_print
    MOV 42 26
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    MOV 29 26
    MOV 28 25
    CALL __FCALL_4_switchProcess
    RETI




__FCALL_8_freeMemory:
    INC 28
    SET 29 0
    JMP __LOOP_19_EVAL
__LOOP_19_BODY:
    ADD 30 24 29
    LD 30
    SET 31 8
    RSHIFT 30 30 31
    EQ 30 30 28
    CJMP 30 __IF_19_C0_BODY
    JMP __IF_19_END
__IF_19_C0_BODY:
    SET 30 0
    ADD 31 24 29
    ST 30 31
__IF_19_END:
    INC 29
__LOOP_19_EVAL:
    SET 30 256
    GTR 30 30 29
    CJMP 30 __LOOP_19_BODY
    RET

__FCALL_4_killProcess:
    MOV 28 27
    CALL __FCALL_8_freeMemory
    SET 28 -1

    ADD 29 23 27
    ST 28 29
    RET



__FCALL_2_printS:
    SET 29 15
    RSHIFT 29 28 29
    CJMP 29 __IF_20_C0_BODY
    JMP __IF_20_END
__IF_20_C0_BODY:
    SET 29 45
    PRINTL 29
    SET 29 0
    SUB 28 29 28
__IF_20_END:
    MOV 42 28
    CALL __FCALL_2_printU
    RET


__FCALL_1_killProcessInterrupt:
    CALL __FCALL_4_getCurrentlyRunningProcess
    SET 27 -1
    EQ 27 26 27
    CJMP 27 __IF_18_C0_BODY
    MOV 27 26
    CALL __FCALL_4_killProcess
    JMP __IF_18_END
__IF_18_C0_BODY:
__IF_18_END:
    MOV 27 26
    CALL __FCALL_4_getNextProcess
    MOV 27 29
    CALL __FCALL_2_newline
    SET 28 __STR_CONST_32
    MOV 42 28
    CALL __FCALL_2_print
    MOV 28 26
    CALL __FCALL_2_printS
    SET 28 __STR_CONST_33
    MOV 42 28
    CALL __FCALL_2_print
    MOV 28 27
    CALL __FCALL_2_printS
    CALL __FCALL_2_newline
    SET 28 -1
    EQ 28 27 28
    CJMP 28 __IF_21_C0_BODY
    JMP __IF_21_END
__IF_21_C0_BODY:
    SET 28 __STR_CONST_34
    MOV 42 28
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SHUTDOWN
__IF_21_END:
    SET 28 16
    SETTIMER 28
    MOV 29 27
    MOV 28 26
    CALL __FCALL_4_switchProcess
    RET


__INTER_0_BadMemAccess:
    SET 25 __STR_CONST_31
    MOV 42 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    RETI



__INTER_0_StackOverflow:
    SET 25 __STR_CONST_35
    MOV 42 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    RETI



__INTER_0_StackUnderflow:
    SET 25 __STR_CONST_36
    MOV 42 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    RETI


__FCALL_2_printHex:
    SET 38 61440
    SET 39 0
    JMP __LOOP_4_EVAL
__LOOP_4_BODY:
    AND 40 38 37
    SET 41 3
    SUB 41 41 39
    SET 42 2
    LSHIFT 41 41 42
    RSHIFT 40 40 41
    SET 41 9
    GTEQ 41 41 40
    CJMP 41 __IF_1_C0_BODY
    SET 41 55
    ADD 41 40 41
    PRINTL 41
    JMP __IF_1_END
__IF_1_C0_BODY:
    SET 41 48
    ADD 41 40 41
    PRINTL 41
__IF_1_END:
    SET 41 4
    RSHIFT 38 38 41
    INC 39
__LOOP_4_EVAL:
    SET 41 4
    GTR 41 41 39
    CJMP 41 __LOOP_4_BODY
    RET


__INTER_0_BadIns:
    SET 25 0

    ADD 25 25 22
    LD 25
    SET 26 65280
    XOR 26 25 26
    CJMP 26 __IF_22_C0_BODY
    JMP __IF_22_END
__IF_22_C0_BODY:
    SET 26 __STR_CONST_37
    MOV 42 26
    CALL __FCALL_2_print
    MOV 37 25
    CALL __FCALL_2_printHex
    CALL __FCALL_2_newline
__IF_22_END:
    CALL __FCALL_1_killProcessInterrupt
    RETI



__INTER_0_UserDefined1:
    MOV 25 0
    USR_ADDR 25
    MOV 26 25
    CJMP 26 __IF_23_C0_BODY
    SET 26 __STR_CONST_38
    MOV 42 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    JMP __IF_23_END
__IF_23_C0_BODY:
    MOV 26 25

    MOV 42 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
__IF_23_END:
    RETI


__INTER_0_UserDefined2:
    MOV 28 0
    CALL __FCALL_2_printS
    CALL __FCALL_2_newline
    RETI


__INTER_0_UserDefined3:
    MOV 42 0
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    RETI


__INTER_0_UserDefined4:
    MOV 37 0
    CALL __FCALL_2_printHex
    CALL __FCALL_2_newline
    RETI
__INTER_0_defaultInterrupt:
    RETI





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



__FCALL_10_defaultStack:
    ADD 38 23 37
    LD 38
    SET 39 1
    SET 40 18
    ADD 41 38 40
    ST 39 41
    SET 39 0
    SET 40 19
    ADD 41 38 40
    ST 39 41
    RET




__FCALL_3_min:
    GTR 39 37 38
    CJMP 39 __IF_7_C0_BODY
    JMP __IF_7_END
__IF_7_C0_BODY:
    MOV 37 38
__IF_7_END:
    RET

__FCALL_6_setProgramCounter:
    ADD 39 23 37
    LD 39
    SET 40 1
    ADD 41 39 40
    ST 38 41
    RET



__FCALL_8_allocateNextBlock:
    SET 36 1
    SET 37 -1
    SET 38 0
    JMP __LOOP_9_EVAL
__LOOP_9_BODY:
    ADD 39 24 38
    LD 39
    SET 40 0
    EQ 39 39 40
    CJMP 39 __IF_6_C0_BODY
    JMP __IF_6_END
__IF_6_C0_BODY:
    SET 39 8
    LSHIFT 39 34 39
    OR 39 39 35
    ADD 40 24 38
    ST 39 40
    MOV 37 38
    SET 36 0
__IF_6_END:
    INC 38
__LOOP_9_EVAL:
    SET 39 256
    GTR 39 39 38
    BAND 39 36 39
    CJMP 39 __LOOP_9_BODY
    RET

__FCALL_4_findOpenProcessSlot:
    SET 30 1
    SET 31 -1
    SET 32 0
    JMP __LOOP_8_EVAL
__LOOP_8_BODY:
    ADD 33 23 32
    LD 33

    SET 34 -1
    EQ 33 33 34
    CJMP 33 __IF_3_C0_BODY
    JMP __IF_3_END
__IF_3_C0_BODY:
    MOV 31 32
    SET 30 0
__IF_3_END:
    INC 32
__LOOP_8_EVAL:
    SET 33 10
    GTR 33 33 32
    BAND 33 30 33
    CJMP 33 __LOOP_8_BODY
    RET

__FCALL_8_getNumberOfOpenMemBlocks:
    SET 31 0
    SET 32 0
    JMP __LOOP_5_EVAL
__LOOP_5_BODY:
    ADD 33 24 32
    LD 33
    SET 34 0
    EQ 33 33 34
    CJMP 33 __IF_2_C0_BODY
    JMP __IF_2_END
__IF_2_C0_BODY:
    INC 31
__IF_2_END:
    INC 32
__LOOP_5_EVAL:
    SET 33 256
    GTR 33 33 32
    CJMP 33 __LOOP_5_BODY
    RET


__FCALL_7_extFetch:
    SET 38 1
    LSHIFT 38 37 38
    SET 39 0
    EXTFETCH 36 39 38
    MOV 39 18
    SET 40 0
    MOV 41 38
    INC 41
    EXTFETCH 36 40 41
    SET 40 8
    LSHIFT 40 39 40
    OR 39 40 18
    RET

__FCALL_4_createProcess:
    SET 27 0
    SET 28 0
    MOV 37 28
    MOV 36 26
    CALL __FCALL_7_extFetch
    MOV 28 39
    SET 29 __STR_CONST_3
    MOV 42 29
    CALL __FCALL_2_print
    MOV 37 28
    CALL __FCALL_2_printHex
    CALL __FCALL_2_newline
    SET 29 __STR_CONST_4
    MOV 42 29
    CALL __FCALL_2_print
    MOV 42 28
    CALL __FCALL_2_printU
    SET 29 __STR_CONST_5
    MOV 42 29
    CALL __FCALL_2_print
    SET 29 8
    RSHIFT 29 28 29
    INC 29
    CALL __FCALL_4_findOpenProcessSlot
    MOV 30 31
    SET 31 -1
    EQ 31 30 31
    CJMP 31 __IF_4_C0_BODY
    CALL __FCALL_8_getNumberOfOpenMemBlocks
    GTR 31 31 29
    CJMP 31 __IF_5_C0_BODY
    SET 31 __STR_CONST_6
    MOV 42 31
    CALL __FCALL_2_print
    SET 27 2
    JMP __IF_5_END
__IF_5_C0_BODY:
    MOV 31 30
    INC 31
    SET 32 0
    MOV 35 32
    MOV 34 31
    CALL __FCALL_8_allocateNextBlock
    MOV 31 37
    SET 32 1
    CALL __FCALL_2_newline
    SET 33 __STR_CONST_7
    MOV 42 33
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 33 1
    JMP __LOOP_10_EVAL
__LOOP_10_BODY:
    MOV 34 30
    INC 34
    MOV 35 33
    CALL __FCALL_8_allocateNextBlock
    MOV 34 37
    SET 35 0
    JMP __LOOP_11_EVAL
__LOOP_11_BODY:
    MOV 37 32
    MOV 36 26
    CALL __FCALL_7_extFetch
    MOV 36 39
    MOV 37 36
    CALL __FCALL_2_printHex
    SET 37 __STR_CONST_8
    MOV 42 37
    CALL __FCALL_2_print
    SET 37 8
    LSHIFT 37 34 37

    ADD 38 37 35
    ST 36 38
    INC 32
    INC 35
__LOOP_11_EVAL:
    MOV 37 33
    DEC 37
    SET 38 8
    LSHIFT 37 37 38
    SUB 37 28 37
    SET 38 256
    CALL __FCALL_3_min
    GTR 37 37 35
    CJMP 37 __LOOP_11_BODY
    CALL __FCALL_2_newline
    INC 33
__LOOP_10_EVAL:
    GTEQ 37 29 33
    CJMP 37 __LOOP_10_BODY
    SET 37 8
    LSHIFT 37 31 37

    ADD 38 23 30
    ST 37 38
    SET 37 0
    MOV 43 37
    MOV 42 30
    CALL __FCALL_11_setProcessState
    MOV 38 30
    CALL __FCALL_9_saveUserRegisters
    SET 37 0
    MOV 38 37
    MOV 37 30
    CALL __FCALL_6_setProgramCounter
    MOV 37 30
    CALL __FCALL_10_defaultStack
    SET 37 __STR_CONST_9
    MOV 42 37
    CALL __FCALL_2_print
    MOV 42 30
    CALL __FCALL_2_printU
    SET 37 __STR_CONST_10
    MOV 42 37
    CALL __FCALL_2_print
    MOV 42 31
    CALL __FCALL_2_printU
    SET 37 __STR_CONST_11
    MOV 42 37
    CALL __FCALL_2_print
    MOV 39 30
    CALL __FCALL_11_getProcessState
    MOV 37 40
    MOV 42 37
    CALL __FCALL_2_printU
__IF_5_END:
    JMP __IF_4_END
__IF_4_C0_BODY:
    CALL __FCALL_2_newline
    SET 37 __STR_CONST_12
    MOV 42 37
    CALL __FCALL_2_print
    SET 27 1
__IF_4_END:
    RET

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



__FCALL_1_main:
    CALL __FCALL_2_newline
    CALL __FCALL_1_initializeProcessArray
    CALL __FCALL_1_initializeMemoryBlocks
    SET 25 __STR_CONST_0
    MOV 42 25
    CALL __FCALL_2_print
    SET 25 __BINEND

    MOV 37 25
    CALL __FCALL_2_printHex
    CALL __FCALL_2_newline
    SET 25 __STR_CONST_1
    MOV 42 25
    CALL __FCALL_2_print
    CALL __FCALL_8_getNumberOfOpenMemBlocks
    MOV 25 31
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    CALL __FCALL_2_newline
    SET 25 __STR_CONST_2
    MOV 42 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 25 0
    MOV 26 25
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_13
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_14
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_15
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_16
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_17
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_18
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_19
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_20
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_21
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_22
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_23
    MOV 42 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 26 1
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_24
    MOV 42 26
    CALL __FCALL_2_print
    MOV 42 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_25
    MOV 42 26
    CALL __FCALL_2_print
    CALL __FCALL_8_getNumberOfOpenMemBlocks
    MOV 26 31
    MOV 42 26
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_26
    MOV 42 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 26 16
    SETTIMER 26
    SET 26 0
    MOV 30 26
    CALL __FCALL_8_unlockMemory
    SET 26 0
    MOV 30 26
    CALL __FCALL_10_loadStackAndRun
    RET

__STR_CONST_0:
    .TEXT "KERNEL Memory BINARY END: 0x"
__STR_CONST_1:
    .TEXT "Number of open memory blocks (After Kernel Allocation): "
__STR_CONST_2:
    .TEXT "Creating Process 0"
__STR_CONST_3:
    .TEXT "Program Size Byte: 0x"
__STR_CONST_4:
    .TEXT "Program Size: "
__STR_CONST_5:
    .TEXT " bytes"
__STR_CONST_6:
    .TEXT "ERROR in createProcess(): Not enough memory to load program"
__STR_CONST_7:
    .TEXT "Allocating Memory..."
__STR_CONST_8:
    .TEXT " "
__STR_CONST_9:
    .TEXT "Process Index: "
__STR_CONST_10:
    .TEXT " Memory Index: "
__STR_CONST_11:
    .TEXT " Process State: "
__STR_CONST_12:
    .TEXT "ERROR in createProcess(): Could not find process slot."
__STR_CONST_13:
    .TEXT " Creation Status: "
__STR_CONST_14:
    .TEXT " Creation Status: "
__STR_CONST_15:
    .TEXT " Creation Status: "
__STR_CONST_16:
    .TEXT " Creation Status: "
__STR_CONST_17:
    .TEXT " Creation Status: "
__STR_CONST_18:
    .TEXT " Creation Status: "
__STR_CONST_19:
    .TEXT " Creation Status: "
__STR_CONST_20:
    .TEXT " Creation Status: "
__STR_CONST_21:
    .TEXT " Creation Status: "
__STR_CONST_22:
    .TEXT " Creation Status: "
__STR_CONST_23:
    .TEXT "Creating Process 1"
__STR_CONST_24:
    .TEXT " Creation Status: "
__STR_CONST_25:
    .TEXT "Number of open memory blocks (After Process Allocation): "
__STR_CONST_26:
    .TEXT "LAUNCH PROCESS"
__STR_CONST_27:
    .TEXT "Unlocked block "
__STR_CONST_28:
    .TEXT " for process "
__STR_CONST_29:
    .TEXT "Switching from Process "
__STR_CONST_30:
    .TEXT " to "
__STR_CONST_31:
    .TEXT "Bad Mem Access!"
__STR_CONST_32:
    .TEXT "Killing "
__STR_CONST_33:
    .TEXT " and switching to "
__STR_CONST_34:
    .TEXT "All tasks finished, shutting down."
__STR_CONST_35:
    .TEXT "Stack Overflow!"
__STR_CONST_36:
    .TEXT "Stack Underflow!"
__STR_CONST_37:
    .TEXT "Bad Instruction! "
__STR_CONST_38:
    .TEXT "Bad request, cannot print"
__ALLOC_0:
    .ALLOC 10
__ALLOC_1:
    .ALLOC 256
__BINEND: