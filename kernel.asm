
    JMP __INTER_INIT
    JMP __INTER_0_TimerTick
    JMP __INTER_0_defaultInterrupt
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

__FCALL_3_getChar:
    MOV 42 40
    SET 43 1
    RSHIFT 43 41 43
    ADD 42 42 43
    LD 42
    SET 43 1
    AND 43 41 43
    CJMP 43 __IF_0_C0_BODY
    SET 43 8
    RSHIFT 42 42 43
    JMP __IF_0_END
__IF_0_C0_BODY:
    SET 43 255
    AND 42 42 43
__IF_0_END:
    RET

__FCALL_2_print:
    SET 38 0
    MOV 41 38
    MOV 40 37
    CALL __FCALL_3_getChar
    MOV 39 42
    JMP __LOOP_3_EVAL
__LOOP_3_BODY:
    PRINTL 39
    INC 38
    MOV 41 38
    MOV 40 37
    CALL __FCALL_3_getChar
    MOV 39 42
__LOOP_3_EVAL:
    MOV 40 39
    CJMP 40 __LOOP_3_BODY
    RET

__FCALL_4_getProcessState:
    ADD 38 23 37
    LD 38
    SET 39 0
    ADD 38 38 39
    LD 38
    RET

__FCALL_4_getNextProcess:
    MOV 27 26
    INC 27
    SET 28 10
    MOD 27 27 28
    SET 28 -1
    JMP __LOOP_17_EVAL
__LOOP_17_BODY:
    ADD 29 23 27
    LD 29

    SET 30 -1
    EQ 29 29 30
    CJMP 29 __IF_10_C0_BODY
    MOV 37 27
    CALL __FCALL_4_getProcessState
    MOV 29 38
    SET 30 0
    EQ 29 29 30
    CJMP 29 __IF_11_C0_BODY
    JMP __IF_11_END
__IF_11_C0_BODY:
    MOV 28 27
__IF_11_END:
    JMP __IF_10_END
__IF_10_C0_BODY:
__IF_10_END:
    MOV 29 27
    INC 29
    SET 30 10
    MOD 27 29 30
__LOOP_17_EVAL:
    SET 29 -1
    EQ 29 28 29
    EQ 30 26 28
    SET 31 0
    EQ 30 30 31
    BAND 29 29 30
    CJMP 29 __LOOP_17_BODY
    RET

__FCALL_4_saveStack:
    POP 27
    ADD 28 23 26
    LD 28
    SET 29 18
    ADD 30 28 29
    ST 17 30
    SET 29 0
    JMP __LOOP_16_EVAL
__LOOP_16_BODY:
    POP 30
    SET 31 19
    ADD 31 31 29
    ADD 32 28 31
    ST 30 32
    INC 29
__LOOP_16_EVAL:
    MOV 30 17
    DEC 30
    CJMP 30 __LOOP_16_BODY
    PUSH 27
    RET


__FCALL_4_getCurrentlyRunningProcess:
    SET 25 -1
    SET 26 1
    SET 27 0
    JMP __LOOP_15_EVAL
__LOOP_15_BODY:
    MOV 37 27
    CALL __FCALL_4_getProcessState
    MOV 28 38
    SET 29 1
    EQ 28 28 29
    CJMP 28 __IF_9_C0_BODY
    JMP __IF_9_END
__IF_9_C0_BODY:
    MOV 25 27
    SET 26 0
__IF_9_END:
    INC 27
__LOOP_15_EVAL:
    SET 28 10
    GTR 28 28 27
    BAND 28 26 28
    CJMP 28 __LOOP_15_BODY
    RET

__FCALL_2_newline:
    SET 37 10
    PRINTL 37
    RET

__FCALL_4_unlockMemory:
    LOCK 16
    INC 29
    SET 30 0
    JMP __LOOP_12_EVAL
__LOOP_12_BODY:
    ADD 31 24 30
    LD 31
    SET 32 8
    RSHIFT 31 31 32
    EQ 31 31 29
    ADD 32 24 30
    LD 32
    SET 33 255
    AND 32 32 33
    BAND 31 31 32
    CJMP 31 __IF_8_C0_BODY
    JMP __IF_8_END
__IF_8_C0_BODY:
    UNLOCK 30
__IF_8_END:
    INC 30
__LOOP_12_EVAL:
    SET 31 256
    GTR 31 31 30
    CJMP 31 __LOOP_12_BODY
    RET

__FCALL_4_saveUserRegisters:
    ADD 38 23 37
    LD 38
    SET 39 0
    SET 40 2
    ADD 41 38 40
    ST 0 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 1 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 2 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 3 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 4 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 5 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 6 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 7 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 8 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 9 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 10 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 11 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 12 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 13 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 14 41
    INC 39
    SET 40 2
    ADD 40 40 39
    ADD 41 38 40
    ST 15 41
    RET

__FCALL_4_loadUserRegisters:
    ADD 30 23 29
    LD 30
    SET 31 0
    SET 32 2
    ADD 0 30 32
    LD 0
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 1 30 32
    LD 1
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 2 30 32
    LD 2
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 3 30 32
    LD 3
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 4 30 32
    LD 4
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 5 30 32
    LD 5
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 6 30 32
    LD 6
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 7 30 32
    LD 7
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 8 30 32
    LD 8
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 9 30 32
    LD 9
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 10 30 32
    LD 10
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 11 30 32
    LD 11
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 12 30 32
    LD 12
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 13 30 32
    LD 13
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 14 30 32
    LD 14
    INC 31
    SET 32 2
    ADD 32 32 31
    ADD 15 30 32
    LD 15
    RET

__FCALL_4_setProcessState:
    ADD 42 23 40
    LD 42
    SET 43 0
    ADD 44 42 43
    ST 41 44
    RET

__FCALL_4_emptyStack:
    POP 31
    JMP __LOOP_13_EVAL
__LOOP_13_BODY:
    POP 32
__LOOP_13_EVAL:
    MOV 33 17
    CJMP 33 __LOOP_13_BODY
    PUSH 31
    RET


__FCALL_4_loadStackAndRun:
    ADD 30 23 29
    LD 30
    CALL __FCALL_4_emptyStack
    SET 31 18
    ADD 31 30 31
    LD 31
    MOV 32 31
    JMP __LOOP_14_EVAL
__LOOP_14_BODY:
    SET 33 18
    ADD 33 33 32
    ADD 33 30 33
    LD 33
    PUSH 33
    DEC 32
__LOOP_14_EVAL:
    SET 33 0
    GTR 33 32 33
    CJMP 33 __LOOP_14_BODY
    SET 33 1
    MOV 41 33
    MOV 40 29
    CALL __FCALL_4_setProcessState
    RETI
    RET

__FCALL_4_switchProcess:
    EQ 29 27 28
    CJMP 29 __IF_13_C0_BODY
    SET 29 0
    MOV 41 29
    MOV 40 27
    CALL __FCALL_4_setProcessState
    MOV 37 27
    CALL __FCALL_4_saveUserRegisters
    MOV 29 28
    CALL __FCALL_4_loadUserRegisters
    MOV 29 28
    CALL __FCALL_4_unlockMemory
    MOV 29 28
    CALL __FCALL_4_loadStackAndRun
    JMP __IF_13_END
__IF_13_C0_BODY:
    MOV 29 28
    CALL __FCALL_4_loadStackAndRun
__IF_13_END:
    RET

__INTER_0_TimerTick:
    SET 25 __STR_CONST_14
    MOV 37 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_4_getCurrentlyRunningProcess
    MOV 26 25
    CALL __FCALL_4_saveStack
    MOV 26 25
    CALL __FCALL_4_getNextProcess
    MOV 26 28
    SET 27 -1
    EQ 27 26 27
    CJMP 27 __IF_12_C0_BODY
    JMP __IF_12_END
__IF_12_C0_BODY:
    MOV 26 25
__IF_12_END:
    SET 27 16
    SETTIMER 27
    MOV 28 26
    MOV 27 25
    CALL __FCALL_4_switchProcess
    RETI


__FCALL_4_freeMemory:
    SET 28 0
    JMP __LOOP_18_EVAL
__LOOP_18_BODY:
    ADD 29 24 28
    LD 29
    SET 30 8
    RSHIFT 29 29 30
    EQ 29 29 27
    CJMP 29 __IF_14_C0_BODY
    JMP __IF_14_END
__IF_14_C0_BODY:
    SET 29 0
    ADD 30 24 28
    ST 29 30
__IF_14_END:
    INC 28
__LOOP_18_EVAL:
    SET 29 256
    GTR 29 29 28
    CJMP 29 __LOOP_18_BODY
    RET

__FCALL_4_killProcess:
    MOV 27 26
    CALL __FCALL_4_freeMemory
    SET 27 -1

    ADD 28 23 26
    ST 27 28
    RET




__FCALL_1_killProcessInterrupt:
    CALL __FCALL_4_getCurrentlyRunningProcess
    MOV 26 25
    CALL __FCALL_4_killProcess
    MOV 26 25
    CALL __FCALL_4_getNextProcess
    MOV 26 28
    SET 27 -1
    EQ 27 26 27
    CJMP 27 __IF_15_C0_BODY
    JMP __IF_15_END
__IF_15_C0_BODY:
    SET 27 __STR_CONST_15
    MOV 37 27
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SHUTDOWN
__IF_15_END:
    SET 27 16
    SETTIMER 27
    MOV 28 26
    MOV 27 25
    CALL __FCALL_4_switchProcess
    RET

__INTER_0_StackOverflow:
    CALL __FCALL_1_killProcessInterrupt
    RETI

__INTER_0_StackUnderflow:
    CALL __FCALL_1_killProcessInterrupt
    RETI


__FCALL_2_printHex:
    SET 38 61440
    SET 39 0
    JMP __LOOP_7_EVAL
__LOOP_7_BODY:
    AND 40 38 37
    SET 41 3
    SUB 41 41 39
    SET 42 2
    LSHIFT 41 41 42
    RSHIFT 40 40 41
    SET 41 9
    GTEQ 41 41 40
    CJMP 41 __IF_2_C0_BODY
    SET 41 55
    ADD 41 40 41
    PRINTL 41
    JMP __IF_2_END
__IF_2_C0_BODY:
    SET 41 48
    ADD 41 40 41
    PRINTL 41
__IF_2_END:
    SET 41 4
    RSHIFT 38 38 41
    INC 39
__LOOP_7_EVAL:
    SET 41 4
    GTR 41 41 39
    CJMP 41 __LOOP_7_BODY
    RET

__INTER_0_BadIns:
    SET 25 __STR_CONST_16
    MOV 37 25
    CALL __FCALL_2_print
    MOV 37 22
    CALL __FCALL_2_printHex
    CALL __FCALL_1_killProcessInterrupt
    RETI


__INTER_0_UserDefined1:
    MOV 25 0
    USR_ADDR 25


    MOV 37 25
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    RETI
__FCALL_2_printU:
    SET 38 1
    JMP __LOOP_5_EVAL
__LOOP_5_BODY:
    SET 39 10
    LMUL 38 38 39
__LOOP_5_EVAL:
    SET 39 10
    DIV 39 37 39
    GTEQ 39 39 38
    CJMP 39 __LOOP_5_BODY
    JMP __LOOP_6_EVAL
__LOOP_6_BODY:
    DIV 39 37 38
    SET 40 48
    ADD 40 39 40
    PRINTL 40
    LMUL 40 39 38
    SUB 37 37 40
    SET 40 10
    DIV 38 38 40
__LOOP_6_EVAL:
    SET 40 0
    GTR 40 38 40
    CJMP 40 __LOOP_6_BODY
    RET

__FCALL_2_printS:
    SET 26 15
    RSHIFT 26 25 26
    CJMP 26 __IF_16_C0_BODY
    JMP __IF_16_END
__IF_16_C0_BODY:
    SET 26 45
    PRINTL 26
    SET 26 0
    SUB 25 26 25
__IF_16_END:
    MOV 37 25
    CALL __FCALL_2_printU
    RET


__INTER_0_UserDefined2:
    MOV 25 0
    CALL __FCALL_2_printS
    CALL __FCALL_2_newline
    RETI


__INTER_0_UserDefined3:
    MOV 37 0
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





__FCALL_3_min:
    GTR 39 37 38
    CJMP 39 __IF_7_C0_BODY
    JMP __IF_7_END
__IF_7_C0_BODY:
    MOV 37 38
__IF_7_END:
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



__FCALL_4_getNumberOfOpenMemBlocks:
    SET 31 0
    SET 32 0
    JMP __LOOP_4_EVAL
__LOOP_4_BODY:
    ADD 33 24 32
    LD 33
    SET 34 0
    EQ 33 33 34
    CJMP 33 __IF_1_C0_BODY
    JMP __IF_1_END
__IF_1_C0_BODY:
    INC 31
__IF_1_END:
    INC 32
__LOOP_4_EVAL:
    SET 33 256
    GTR 33 33 32
    CJMP 33 __LOOP_4_BODY
    RET

__FCALL_4_defaultStack:
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

__FCALL_4_allocateNextBlock:
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


__FCALL_4_extFetch:
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

__FCALL_4_setProgramCounter:
    ADD 39 23 37
    LD 39
    SET 40 1
    ADD 41 39 40
    ST 38 41
    RET




__FCALL_4_createProcess:
    SET 27 0
    SET 28 __STR_CONST_1
    MOV 37 28
    CALL __FCALL_2_print
    SET 28 __BINEND

    MOV 37 28
    CALL __FCALL_2_printHex
    SET 28 0
    MOV 37 28
    MOV 36 26
    CALL __FCALL_4_extFetch
    MOV 28 39
    SET 29 __STR_CONST_2
    MOV 37 29
    CALL __FCALL_2_print
    MOV 37 28
    CALL __FCALL_2_printHex
    SET 29 8
    RSHIFT 29 28 29
    INC 29
    CALL __FCALL_4_findOpenProcessSlot
    MOV 30 31
    SET 31 -1
    EQ 31 30 31
    CJMP 31 __IF_4_C0_BODY
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    GTR 31 31 29
    CJMP 31 __IF_5_C0_BODY
    SET 31 __STR_CONST_3
    MOV 37 31
    CALL __FCALL_2_print
    SET 27 2
    JMP __IF_5_END
__IF_5_C0_BODY:
    MOV 31 30
    INC 31
    SET 32 0
    MOV 35 32
    MOV 34 31
    CALL __FCALL_4_allocateNextBlock
    MOV 31 37
    SET 32 1
    CALL __FCALL_2_newline
    SET 33 __STR_CONST_4
    MOV 37 33
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 33 1
    JMP __LOOP_10_EVAL
__LOOP_10_BODY:
    MOV 34 30
    INC 34
    MOV 35 33
    CALL __FCALL_4_allocateNextBlock
    MOV 34 37
    MOV 37 28
    CALL __FCALL_2_printU
    MOV 35 33
    DEC 35
    SET 36 8
    LSHIFT 35 35 36
    MOV 37 35
    CALL __FCALL_2_printU
    SET 35 0
    JMP __LOOP_11_EVAL
__LOOP_11_BODY:
    MOV 37 32
    MOV 36 26
    CALL __FCALL_4_extFetch
    MOV 36 39
    MOV 37 36
    CALL __FCALL_2_printHex
    SET 37 __STR_CONST_5
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
    MOV 41 37
    MOV 40 30
    CALL __FCALL_4_setProcessState
    MOV 37 30
    CALL __FCALL_4_saveUserRegisters
    SET 37 0
    MOV 38 37
    MOV 37 30
    CALL __FCALL_4_setProgramCounter
    MOV 37 30
    CALL __FCALL_4_defaultStack
    SET 37 __STR_CONST_6
    CALL __FCALL_2_print
    MOV 37 30
    CALL __FCALL_2_printU
    SET 37 __STR_CONST_7
    CALL __FCALL_2_print
    MOV 37 31
    CALL __FCALL_2_printU
    SET 37 __STR_CONST_8
    CALL __FCALL_2_print
    MOV 37 30
    CALL __FCALL_4_getProcessState
    MOV 37 38
    CALL __FCALL_2_printU
__IF_5_END:
    JMP __IF_4_END
__IF_4_C0_BODY:
    SET 37 __STR_CONST_9
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


__FCALL_1_main:
    CALL __FCALL_1_initializeProcessArray
    CALL __FCALL_1_initializeMemoryBlocks
    SET 25 __STR_CONST_0
    MOV 37 25
    CALL __FCALL_2_print
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    MOV 25 31
    MOV 37 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 25 0
    MOV 26 25
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_10
    MOV 37 26
    CALL __FCALL_2_print
    MOV 37 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 0
    CALL __FCALL_4_createProcess
    MOV 25 27
    SET 26 __STR_CONST_11
    MOV 37 26
    CALL __FCALL_2_print
    MOV 37 25
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_12
    MOV 37 26
    CALL __FCALL_2_print
    CALL __FCALL_4_getNumberOfOpenMemBlocks
    MOV 26 31
    MOV 37 26
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_13
    MOV 37 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 26 16
    SETTIMER 26
    SET 26 0
    MOV 29 26
    CALL __FCALL_4_unlockMemory
    SET 26 0
    MOV 29 26
    CALL __FCALL_4_loadStackAndRun
    RET

__STR_CONST_0:
    .TEXT "Number of open memory blocks: "
__STR_CONST_1:
    .TEXT "KERNEL Memory BINEND: "
__STR_CONST_2:
    .TEXT " Prog Size Byte: "
__STR_CONST_3:
    .TEXT "ERROR in createProcess(): Not enough memory to load program"
__STR_CONST_4:
    .TEXT "Allocating..."
__STR_CONST_5:
    .TEXT " "
__STR_CONST_6:
    .TEXT " Process Index: "
__STR_CONST_7:
    .TEXT " Memory Index: "
__STR_CONST_8:
    .TEXT " Process State: "
__STR_CONST_9:
    .TEXT "ERROR in createProcess(): Could not find process slot."
__STR_CONST_10:
    .TEXT " Creation Status: "
__STR_CONST_11:
    .TEXT " Creation Status: "
__STR_CONST_12:
    .TEXT "Number of open memory blocks: "
__STR_CONST_13:
    .TEXT "LAUNCH PROCESS"
__STR_CONST_14:
    .TEXT "TIMER TICK"
__STR_CONST_15:
    .TEXT "All tasks finished, shutting down."
__STR_CONST_16:
    .TEXT "Bad Instruction!"
__ALLOC_0:
    .ALLOC 10
__ALLOC_1:
    .ALLOC 256
__BINEND: