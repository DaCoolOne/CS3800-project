
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
    JMP __INTER_0_UserDefined5
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
__INTER_INIT:
    SET 23 __ALLOC_0
    SET 24 __ALLOC_1
    SET 25 0
    CALL __FCALL_1_main
    SHUTDOWN

__FCALL_2_printU:
    SET 49 1
    JMP __LOOP_6_EVAL
__LOOP_6_BODY:
    SET 50 10
    LMUL 49 49 50
__LOOP_6_EVAL:
    SET 50 10
    DIV 50 48 50
    GTEQ 50 50 49
    CJMP 50 __LOOP_6_BODY
    JMP __LOOP_7_EVAL
__LOOP_7_BODY:
    DIV 50 48 49
    SET 51 48
    ADD 51 50 51
    PRINTL 51
    LMUL 51 50 49
    SUB 48 48 51
    SET 51 10
    DIV 49 49 51
__LOOP_7_EVAL:
    SET 51 0
    GTR 51 49 51
    CJMP 51 __LOOP_7_BODY
    RET

__FCALL_2_newline:
    SET 48 10
    PRINTL 48
    RET

__FCALL_3_getChar:
    MOV 53 51
    SET 54 1
    RSHIFT 54 52 54
    ADD 53 53 54
    LD 53
    SET 54 1
    AND 54 52 54
    CJMP 54 __IF_0_C0_BODY
    SET 54 8
    RSHIFT 53 53 54
    JMP __IF_0_END
__IF_0_C0_BODY:
    SET 54 255
    AND 53 53 54
__IF_0_END:
    RET

__FCALL_2_print:
    SET 49 0
    MOV 52 49
    MOV 51 48
    CALL __FCALL_3_getChar
    MOV 50 53
    JMP __LOOP_3_EVAL
__LOOP_3_BODY:
    PRINTL 50
    INC 49
    MOV 52 49
    MOV 51 48
    CALL __FCALL_3_getChar
    MOV 50 53
__LOOP_3_EVAL:
    MOV 51 50
    CJMP 51 __LOOP_3_BODY
    RET

__FCALL_8_unlockMemory:
    LOCK 16
    INC 32
    SET 33 1
    SET 34 1
    JMP __LOOP_13_EVAL
__LOOP_13_BODY:
    SET 35 0
    JMP __LOOP_14_EVAL
__LOOP_14_BODY:
    ADD 36 24 35
    LD 36
    SET 37 8
    RSHIFT 36 36 37
    EQ 36 36 32
    ADD 37 24 35
    LD 37
    SET 38 15
    AND 37 37 38
    EQ 37 37 33
    BAND 38 36 37
    CJMP 38 __IF_8_C0_BODY
    JMP __IF_8_END
__IF_8_C0_BODY:
    UNLOCK 35
    INC 33
    SET 38 __STR_CONST_14
    MOV 48 38
    CALL __FCALL_2_print
    MOV 48 35
    CALL __FCALL_2_printU
    SET 38 __STR_CONST_15
    MOV 48 38
    CALL __FCALL_2_print
    MOV 48 32
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
__IF_8_END:
    SET 38 256
    DEC 38
    EQ 38 35 38
    CJMP 38 __IF_9_C0_BODY
    JMP __IF_9_END
__IF_9_C0_BODY:
    SET 34 0
__IF_9_END:
    INC 35
__LOOP_14_EVAL:
    SET 38 256
    GTR 38 38 35
    CJMP 38 __LOOP_14_BODY
__LOOP_13_EVAL:
    MOV 38 34
    CJMP 38 __LOOP_13_BODY
    RET

__FCALL_9_loadUserRegisters:
    ADD 33 23 32
    LD 33
    SET 34 0
    SET 35 2
    ADD 0 33 35
    LD 0
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 1 33 35
    LD 1
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 2 33 35
    LD 2
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 3 33 35
    LD 3
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 4 33 35
    LD 4
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 5 33 35
    LD 5
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 6 33 35
    LD 6
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 7 33 35
    LD 7
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 8 33 35
    LD 8
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 9 33 35
    LD 9
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 10 33 35
    LD 10
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 11 33 35
    LD 11
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 12 33 35
    LD 12
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 13 33 35
    LD 13
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 14 33 35
    LD 14
    INC 34
    SET 35 2
    ADD 35 35 34
    ADD 15 33 35
    LD 15
    RET

__FCALL_9_saveUserRegisters:
    ADD 43 23 42
    LD 43
    SET 44 0
    SET 45 2
    ADD 46 43 45
    ST 0 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 1 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 2 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 3 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 4 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 5 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 6 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 7 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 8 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 9 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 10 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 11 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 12 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 13 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 14 46
    INC 44
    SET 45 2
    ADD 45 45 44
    ADD 46 43 45
    ST 15 46
    RET

__FCALL_11_setProcessState:
    ADD 50 23 48
    LD 50
    SET 51 0
    ADD 52 50 51
    ST 49 52
    RET

__FCALL_10_emptyStack:
    POP 34
    JMP __LOOP_15_EVAL
__LOOP_15_BODY:
    POP 35
__LOOP_15_EVAL:
    MOV 36 17
    CJMP 36 __LOOP_15_BODY
    PUSH 34
    RET

__FCALL_10_loadStackAndRun:
    ADD 33 23 32
    LD 33
    CALL __FCALL_10_emptyStack
    SET 34 18
    ADD 34 33 34
    LD 34
    MOV 35 34
    JMP __LOOP_16_EVAL
__LOOP_16_BODY:
    SET 36 18
    ADD 36 36 35
    ADD 36 33 36
    LD 36
    PUSH 36
    DEC 35
__LOOP_16_EVAL:
    SET 36 0
    GTR 36 35 36
    CJMP 36 __LOOP_16_BODY
    SET 36 1
    MOV 49 36
    MOV 48 32
    CALL __FCALL_11_setProcessState
    RETI
    RET


__FCALL_4_switchProcess:
    EQ 32 30 31
    CJMP 32 __IF_16_C0_BODY
    SET 32 -1
    EQ 32 30 32
    CJMP 32 __IF_17_C0_BODY
    ADD 32 23 30
    LD 32

    SET 33 -1
    EQ 32 32 33
    CJMP 32 __IF_18_C0_BODY
    SET 32 0
    MOV 49 32
    MOV 48 30
    CALL __FCALL_11_setProcessState
    MOV 42 30
    CALL __FCALL_9_saveUserRegisters
    JMP __IF_18_END
__IF_18_C0_BODY:
__IF_18_END:
    JMP __IF_17_END
__IF_17_C0_BODY:
__IF_17_END:
    MOV 32 31
    CALL __FCALL_9_loadUserRegisters
    MOV 32 31
    CALL __FCALL_8_unlockMemory
    MOV 32 31
    CALL __FCALL_10_loadStackAndRun
    JMP __IF_16_END
__IF_16_C0_BODY:
    MOV 32 31
    CALL __FCALL_10_loadStackAndRun
__IF_16_END:
    RET

__FCALL_10_saveStack:
    POP 28
    ADD 29 23 27
    LD 29
    SET 30 18
    ADD 31 29 30
    ST 17 31
    SET 30 0
    JMP __LOOP_18_EVAL
__LOOP_18_BODY:
    POP 31
    SET 32 19
    ADD 32 32 30
    ADD 33 29 32
    ST 31 33
    INC 30
__LOOP_18_EVAL:
    MOV 31 17
    CJMP 31 __LOOP_18_BODY
    PUSH 28
    RET



__FCALL_11_getProcessState:
    ADD 45 23 44
    LD 45
    SET 46 0
    ADD 45 45 46
    LD 45
    RET

__FCALL_4_getNextProcess:
    MOV 30 29
    INC 30
    SET 31 10
    MOD 30 30 31
    SET 31 -1
    JMP __LOOP_19_EVAL
__LOOP_19_BODY:
    ADD 32 23 30
    LD 32

    SET 33 -1
    EQ 32 32 33
    CJMP 32 __IF_12_C0_BODY
    MOV 44 30
    CALL __FCALL_11_getProcessState
    MOV 32 45
    SET 33 0
    EQ 32 32 33
    CJMP 32 __IF_13_C0_BODY
    JMP __IF_13_END
__IF_13_C0_BODY:
    MOV 31 30
__IF_13_END:
    JMP __IF_12_END
__IF_12_C0_BODY:
__IF_12_END:
    MOV 32 30
    INC 32
    SET 33 10
    MOD 30 32 33
__LOOP_19_EVAL:
    SET 32 -1
    EQ 32 31 32
    EQ 33 29 30
    SET 34 0
    EQ 33 33 34
    BAND 32 32 33
    CJMP 32 __LOOP_19_BODY
    RET


__FCALL_4_getCurrentlyRunningProcess:
    SET 28 -1
    SET 29 1
    SET 30 0
    JMP __LOOP_17_EVAL
__LOOP_17_BODY:
    ADD 31 23 30
    LD 31

    SET 32 -1
    EQ 31 31 32
    CJMP 31 __IF_10_C0_BODY
    MOV 44 30
    CALL __FCALL_11_getProcessState
    MOV 31 45
    SET 32 1
    EQ 31 31 32
    CJMP 31 __IF_11_C0_BODY
    JMP __IF_11_END
__IF_11_C0_BODY:
    MOV 28 30
    SET 29 0
__IF_11_END:
    JMP __IF_10_END
__IF_10_C0_BODY:
__IF_10_END:
    INC 30
__LOOP_17_EVAL:
    SET 31 10
    GTR 31 31 30
    BAND 31 29 31
    CJMP 31 __LOOP_17_BODY
    RET


__INTER_0_TimerTick:
    CALL __FCALL_4_getCurrentlyRunningProcess
    MOV 26 28
    MOV 27 26
    CALL __FCALL_10_saveStack
    MOV 29 26
    CALL __FCALL_4_getNextProcess
    MOV 27 31
    SET 28 -1
    EQ 28 27 28
    CJMP 28 __IF_14_C0_BODY
    JMP __IF_14_END
__IF_14_C0_BODY:
    MOV 27 26
__IF_14_END:
    SET 28 80
    SETTIMER 28
    XOR 28 26 27
    CJMP 28 __IF_15_C0_BODY
    JMP __IF_15_END
__IF_15_C0_BODY:
    SET 28 __STR_CONST_16
    MOV 48 28
    CALL __FCALL_2_print
    MOV 48 26
    CALL __FCALL_2_printU
    SET 28 __STR_CONST_17
    MOV 48 28
    CALL __FCALL_2_print
    MOV 48 27
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
__IF_15_END:
    MOV 31 27
    MOV 30 26
    CALL __FCALL_4_switchProcess
    RETI


__FCALL_8_freeMemory:
    INC 30
    SET 31 0
    JMP __LOOP_20_EVAL
__LOOP_20_BODY:
    ADD 32 24 31
    LD 32
    SET 33 8
    RSHIFT 32 32 33
    EQ 32 32 30
    CJMP 32 __IF_20_C0_BODY
    JMP __IF_20_END
__IF_20_C0_BODY:
    SET 32 0
    ADD 33 24 31
    ST 32 33
__IF_20_END:
    INC 31
__LOOP_20_EVAL:
    SET 32 256
    GTR 32 32 31
    CJMP 32 __LOOP_20_BODY
    RET

__FCALL_4_killProcess:
    MOV 30 29
    CALL __FCALL_8_freeMemory
    SET 30 -1

    ADD 31 23 29
    ST 30 31
    RET

__FCALL_2_printHex:
    SET 33 61440
    SET 34 0
    JMP __LOOP_4_EVAL
__LOOP_4_BODY:
    AND 35 33 32
    SET 36 3
    SUB 36 36 34
    SET 37 2
    LSHIFT 36 36 37
    RSHIFT 35 35 36
    SET 36 9
    GTEQ 36 36 35
    CJMP 36 __IF_1_C0_BODY
    SET 36 55
    ADD 36 35 36
    PRINTL 36
    JMP __IF_1_END
__IF_1_C0_BODY:
    SET 36 48
    ADD 36 35 36
    PRINTL 36
__IF_1_END:
    SET 36 4
    RSHIFT 33 33 36
    INC 34
__LOOP_4_EVAL:
    SET 36 4
    GTR 36 36 34
    CJMP 36 __LOOP_4_BODY
    RET


__FCALL_8_allocateNextBlock:
    SET 39 1
    SET 40 -1
    SET 41 0
    JMP __LOOP_10_EVAL
__LOOP_10_BODY:
    ADD 42 24 41
    LD 42
    SET 43 0
    EQ 42 42 43
    CJMP 42 __IF_6_C0_BODY
    JMP __IF_6_END
__IF_6_C0_BODY:
    SET 42 8
    LSHIFT 42 37 42
    OR 42 42 38
    ADD 43 24 41
    ST 42 43
    MOV 40 41
    SET 39 0
__IF_6_END:
    INC 41
__LOOP_10_EVAL:
    SET 42 256
    GTR 42 42 41
    BAND 42 39 42
    CJMP 42 __LOOP_10_BODY
    RET



__FCALL_6_setProgramCounter:
    ADD 42 23 40
    LD 42
    SET 43 1
    ADD 44 42 43
    ST 41 44
    RET

__FCALL_10_defaultStack:
    ADD 41 23 40
    LD 41
    SET 42 1
    SET 43 18
    ADD 44 41 43
    ST 42 44
    SET 42 0
    SET 43 19
    ADD 44 41 43
    ST 42 44
    RET

__FCALL_7_extFetch:
    SET 41 1
    LSHIFT 41 40 41
    SET 42 0
    EXTFETCH 39 42 41
    MOV 42 18
    SET 43 0
    MOV 44 41
    INC 44
    EXTFETCH 39 43 44
    SET 43 8
    LSHIFT 43 42 43
    OR 42 43 18
    RET


__FCALL_4_findOpenProcessSlot:
    SET 33 1
    SET 34 -1
    SET 35 0
    JMP __LOOP_9_EVAL
__LOOP_9_BODY:
    ADD 36 23 35
    LD 36

    SET 37 -1
    EQ 36 36 37
    CJMP 36 __IF_3_C0_BODY
    JMP __IF_3_END
__IF_3_C0_BODY:
    MOV 34 35
    SET 33 0
__IF_3_END:
    INC 35
__LOOP_9_EVAL:
    SET 36 10
    GTR 36 36 35
    BAND 36 33 36
    CJMP 36 __LOOP_9_BODY
    RET

__FCALL_8_getNumberOfOpenMemBlocks:
    SET 34 0
    SET 35 0
    JMP __LOOP_5_EVAL
__LOOP_5_BODY:
    ADD 36 24 35
    LD 36
    SET 37 0
    EQ 36 36 37
    CJMP 36 __IF_2_C0_BODY
    JMP __IF_2_END
__IF_2_C0_BODY:
    INC 34
__IF_2_END:
    INC 35
__LOOP_5_EVAL:
    SET 36 256
    GTR 36 36 35
    CJMP 36 __LOOP_5_BODY
    RET

__FCALL_3_min:
    GTR 42 40 41
    CJMP 42 __IF_7_C0_BODY
    JMP __IF_7_END
__IF_7_C0_BODY:
    MOV 40 41
__IF_7_END:
    RET



__FCALL_4_createProcess:
    SET 30 0
    SET 31 0
    MOV 40 31
    MOV 39 29
    CALL __FCALL_7_extFetch
    MOV 31 42
    CALL __FCALL_2_newline
    SET 32 __STR_CONST_3
    MOV 48 32
    CALL __FCALL_2_print
    MOV 32 31
    CALL __FCALL_2_printHex
    SET 32 __STR_CONST_4
    MOV 48 32
    CALL __FCALL_2_print
    MOV 48 31
    CALL __FCALL_2_printU
    SET 32 __STR_CONST_5
    MOV 48 32
    CALL __FCALL_2_print
    SET 32 8
    RSHIFT 32 31 32
    INC 32
    CALL __FCALL_4_findOpenProcessSlot
    MOV 33 34
    SET 34 -1
    EQ 34 33 34
    CJMP 34 __IF_4_C0_BODY
    CALL __FCALL_8_getNumberOfOpenMemBlocks
    GTR 34 34 32
    CJMP 34 __IF_5_C0_BODY
    SET 34 __STR_CONST_6
    MOV 48 34
    CALL __FCALL_2_print
    SET 30 2
    JMP __IF_5_END
__IF_5_C0_BODY:
    MOV 34 33
    INC 34
    SET 35 0
    MOV 38 35
    MOV 37 34
    CALL __FCALL_8_allocateNextBlock
    MOV 34 40
    SET 35 1
    CALL __FCALL_2_newline
    SET 36 __STR_CONST_7
    MOV 48 36
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 36 1
    JMP __LOOP_11_EVAL
__LOOP_11_BODY:
    MOV 37 33
    INC 37
    MOV 38 36
    CALL __FCALL_8_allocateNextBlock
    MOV 37 40
    SET 38 0
    JMP __LOOP_12_EVAL
__LOOP_12_BODY:
    MOV 40 35
    MOV 39 29
    CALL __FCALL_7_extFetch
    MOV 39 42
    SET 40 8
    LSHIFT 40 37 40

    ADD 41 40 38
    ST 39 41
    INC 35
    INC 38
__LOOP_12_EVAL:
    MOV 40 36
    DEC 40
    SET 41 8
    LSHIFT 40 40 41
    SUB 40 31 40
    SET 41 256
    CALL __FCALL_3_min
    GTR 40 40 38
    CJMP 40 __LOOP_12_BODY
    INC 36
__LOOP_11_EVAL:
    GTEQ 40 32 36
    CJMP 40 __LOOP_11_BODY
    SET 40 8
    LSHIFT 40 34 40

    ADD 41 23 33
    ST 40 41
    SET 40 0
    MOV 49 40
    MOV 48 33
    CALL __FCALL_11_setProcessState
    MOV 42 33
    CALL __FCALL_9_saveUserRegisters
    SET 40 0
    MOV 41 40
    MOV 40 33
    CALL __FCALL_6_setProgramCounter
    MOV 40 33
    CALL __FCALL_10_defaultStack
    SET 40 __STR_CONST_8
    MOV 48 40
    CALL __FCALL_2_print
    MOV 48 33
    CALL __FCALL_2_printU
    SET 40 __STR_CONST_9
    MOV 48 40
    CALL __FCALL_2_print
    MOV 48 34
    CALL __FCALL_2_printU
    SET 40 __STR_CONST_10
    MOV 48 40
    CALL __FCALL_2_print
    MOV 44 33
    CALL __FCALL_11_getProcessState
    MOV 40 45
    MOV 48 40
    CALL __FCALL_2_printU
__IF_5_END:
    JMP __IF_4_END
__IF_4_C0_BODY:
    CALL __FCALL_2_newline
    SET 40 __STR_CONST_11
    MOV 48 40
    CALL __FCALL_2_print
    SET 30 1
__IF_4_END:
    RET

__FCALL_12_getNextFile:
    MOD 29 25 21
    INC 25
    RET

__FCALL_12_hasNextFile:
    SET 29 1
    LMUL 29 21 29
    GTR 29 29 25
    RET

__FCALL_1_allocateEmptySlots:
    SET 28 0
    JMP __LOOP_8_EVAL
__LOOP_8_BODY:
    CALL __FCALL_12_getNextFile
    CALL __FCALL_4_createProcess
    MOV 28 30
__LOOP_8_EVAL:
    CALL __FCALL_12_hasNextFile
    SET 30 0
    EQ 30 28 30
    BAND 29 29 30
    CJMP 29 __LOOP_8_BODY
    RET




__FCALL_2_printS:
    SET 31 15
    RSHIFT 31 30 31
    CJMP 31 __IF_21_C0_BODY
    JMP __IF_21_END
__IF_21_C0_BODY:
    SET 31 45
    PRINTL 31
    SET 31 0
    SUB 30 31 30
__IF_21_END:
    MOV 48 30
    CALL __FCALL_2_printU
    RET


__FCALL_1_killProcessInterrupt:
    CALL __FCALL_1_allocateEmptySlots
    CALL __FCALL_4_getCurrentlyRunningProcess
    SET 29 -1
    EQ 29 28 29
    CJMP 29 __IF_19_C0_BODY
    MOV 29 28
    CALL __FCALL_4_killProcess
    JMP __IF_19_END
__IF_19_C0_BODY:
__IF_19_END:
    MOV 29 28
    CALL __FCALL_4_getNextProcess
    MOV 29 31
    CALL __FCALL_2_newline
    SET 30 __STR_CONST_19
    MOV 48 30
    CALL __FCALL_2_print
    MOV 30 28
    CALL __FCALL_2_printS
    SET 30 __STR_CONST_20
    MOV 48 30
    CALL __FCALL_2_print
    MOV 30 29
    CALL __FCALL_2_printS
    CALL __FCALL_2_newline
    SET 30 -1
    EQ 30 29 30
    CJMP 30 __IF_22_C0_BODY
    JMP __IF_22_END
__IF_22_C0_BODY:
    SET 30 __STR_CONST_21
    MOV 48 30
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SHUTDOWN
__IF_22_END:
    SET 30 16
    SETTIMER 30
    MOV 31 29
    MOV 30 28
    CALL __FCALL_4_switchProcess
    RET



__INTER_0_BadMemAccess:
    SET 26 __STR_CONST_18
    MOV 48 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    RETI



__INTER_0_StackOverflow:
    SET 26 __STR_CONST_22
    MOV 48 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    RETI



__INTER_0_StackUnderflow:
    SET 26 __STR_CONST_23
    MOV 48 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    RETI




__INTER_0_BadIns:
    SET 26 0

    ADD 27 26 22
    LD 27
    SET 28 65280
    XOR 28 27 28
    CJMP 28 __IF_23_C0_BODY
    JMP __IF_23_END
__IF_23_C0_BODY:
    SET 28 __STR_CONST_24
    MOV 48 28
    CALL __FCALL_2_print
    MOV 32 22
    CALL __FCALL_2_printHex
    SET 28 __STR_CONST_25
    MOV 48 28
    CALL __FCALL_2_print
    MOV 32 27
    CALL __FCALL_2_printHex
    SET 28 8
    RSHIFT 28 27 28
    SET 29 1
    EQ 28 28 29
    CJMP 28 __IF_24_C0_BODY
    JMP __IF_24_END
__IF_24_C0_BODY:
    MOV 28 22
    INC 28
    ADD 27 26 28
    LD 27
    SET 28 __STR_CONST_26
    MOV 48 28
    CALL __FCALL_2_print
    MOV 32 27
    CALL __FCALL_2_printHex
__IF_24_END:
    CALL __FCALL_2_newline
__IF_23_END:
    CALL __FCALL_1_killProcessInterrupt
    RETI



__INTER_0_UserDefined1:
    MOV 26 0
    USR_ADDR 26
    MOV 27 26
    CJMP 27 __IF_25_C0_BODY
    SET 27 __STR_CONST_27
    MOV 48 27
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    JMP __IF_25_END
__IF_25_C0_BODY:
    MOV 27 26

    MOV 48 27
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
__IF_25_END:
    RETI


__INTER_0_UserDefined2:
    MOV 30 0
    CALL __FCALL_2_printS
    CALL __FCALL_2_newline
    RETI


__INTER_0_UserDefined3:
    MOV 48 0
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    RETI


__INTER_0_UserDefined4:
    MOV 32 0
    CALL __FCALL_2_printHex
    CALL __FCALL_2_newline
    RETI




__INTER_0_UserDefined5:
    MOV 26 0
    USR_ADDR 26
    MOV 27 26
    CJMP 27 __IF_26_C0_BODY
    SET 27 __STR_CONST_28
    MOV 48 27
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_killProcessInterrupt
    JMP __IF_26_END
__IF_26_C0_BODY:
    MOV 27 26

    MOV 48 27
    CALL __FCALL_2_print
    MOV 30 1
    CALL __FCALL_2_printS
    CALL __FCALL_2_newline
__IF_26_END:
    RETI
__INTER_0_defaultInterrupt:
    RETI



__FCALL_1_initializeMemoryBlocks:
    SET 26 0
    JMP __LOOP_1_EVAL
__LOOP_1_BODY:
    SET 27 0
    ADD 28 24 26
    ST 27 28
    INC 26
__LOOP_1_EVAL:
    SET 27 256
    GTR 27 27 26
    CJMP 27 __LOOP_1_BODY
    SET 26 0
    JMP __LOOP_2_EVAL
__LOOP_2_BODY:
    SET 27 1
    ADD 28 24 26
    ST 27 28
    INC 26
__LOOP_2_EVAL:
    SET 27 __BINEND

    SET 28 8
    RSHIFT 27 27 28
    GTEQ 27 27 26
    CJMP 27 __LOOP_2_BODY
    RET



__FCALL_1_initializeProcessArray:
    SET 26 0
    JMP __LOOP_0_EVAL
__LOOP_0_BODY:
    SET 27 -1

    ADD 28 23 26
    ST 27 28
    INC 26
__LOOP_0_EVAL:
    SET 27 10
    GTR 27 27 26
    CJMP 27 __LOOP_0_BODY
    RET





__FCALL_1_main:
    CALL __FCALL_2_newline
    CALL __FCALL_1_initializeProcessArray
    CALL __FCALL_1_initializeMemoryBlocks
    SET 26 __STR_CONST_0
    MOV 48 26
    CALL __FCALL_2_print
    SET 26 __BINEND

    MOV 32 26
    CALL __FCALL_2_printHex
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_1
    MOV 48 26
    CALL __FCALL_2_print
    CALL __FCALL_8_getNumberOfOpenMemBlocks
    MOV 26 34
    MOV 48 26
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_2
    MOV 48 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    CALL __FCALL_1_allocateEmptySlots
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_12
    MOV 48 26
    CALL __FCALL_2_print
    CALL __FCALL_8_getNumberOfOpenMemBlocks
    MOV 26 34
    MOV 48 26
    CALL __FCALL_2_printU
    CALL __FCALL_2_newline
    CALL __FCALL_2_newline
    SET 26 __STR_CONST_13
    MOV 48 26
    CALL __FCALL_2_print
    CALL __FCALL_2_newline
    SET 26 16
    SETTIMER 26
    SET 26 0
    MOV 32 26
    CALL __FCALL_8_unlockMemory
    SET 26 0
    MOV 32 26
    CALL __FCALL_10_loadStackAndRun
    RET

__STR_CONST_0:
    .TEXT "KERNEL Memory BINARY END: 0x"
__STR_CONST_1:
    .TEXT "Number of open memory blocks (After Kernel Allocation): "
__STR_CONST_2:
    .TEXT "Creating Processes"
__STR_CONST_3:
    .TEXT "Program Size Byte: 0x"
__STR_CONST_4:
    .TEXT " Program Size: "
__STR_CONST_5:
    .TEXT " bytes"
__STR_CONST_6:
    .TEXT "ERROR in createProcess(): Not enough memory to load program"
__STR_CONST_7:
    .TEXT "Allocating Memory..."
__STR_CONST_8:
    .TEXT "Process Index: "
__STR_CONST_9:
    .TEXT " Memory Index: "
__STR_CONST_10:
    .TEXT " Process State: "
__STR_CONST_11:
    .TEXT "ERROR in createProcess(): Could not find process slot."
__STR_CONST_12:
    .TEXT "Number of open memory blocks (After Process Allocation): "
__STR_CONST_13:
    .TEXT "LAUNCH PROCESS"
__STR_CONST_14:
    .TEXT "Unlocked block "
__STR_CONST_15:
    .TEXT " for process "
__STR_CONST_16:
    .TEXT "Switching from Process "
__STR_CONST_17:
    .TEXT " to "
__STR_CONST_18:
    .TEXT "Bad Mem Access!"
__STR_CONST_19:
    .TEXT "Killing "
__STR_CONST_20:
    .TEXT " and switching to "
__STR_CONST_21:
    .TEXT "All tasks finished, shutting down."
__STR_CONST_22:
    .TEXT "Stack Overflow!"
__STR_CONST_23:
    .TEXT "Stack Underflow!"
__STR_CONST_24:
    .TEXT "Bad Instruction at "
__STR_CONST_25:
    .TEXT " - "
__STR_CONST_26:
    .TEXT " CJMP -> "
__STR_CONST_27:
    .TEXT "Bad request, cannot print"
__STR_CONST_28:
    .TEXT "Bad request, cannot print"
__ALLOC_0:
    .ALLOC 10
__ALLOC_1:
    .ALLOC 256
__BINEND: