
    JMP __INTER_INIT
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
    JMP __INTER_0_defaultInterrupt
__INTER_INIT:
    SET 25 __ALLOC_0
    SET 26 -1
    CALL __FCALL_1_main
    SHUTDOWN

__INTER_0_defaultInterrupt:
    RETI

__FCALL_1_PUSH:
    INC 26
    ADD 26 26 29
    MOV 30 29
    INC 30
    ADD 31 25 26
    ST 30 31
    RET

__FCALL_1_POP:
    ADD 27 25 26
    LD 27
    INC 27
    SUB 26 26 27
    RET

__FCALL_1_fetchStackToA:
    SUB 30 26 29
    ADD 27 25 30
    LD 27
    RET

__FCALL_1_fetchStackToB:
    SUB 30 26 29
    ADD 28 25 30
    LD 28
    RET

__FCALL_1_main:
    CALL __FCALL_1_PUSH
    CALL __FCALL_1_POP
    CALL __FCALL_1_fetchStackToA
    CALL __FCALL_1_fetchStackToB
    RET


__ALLOC_0:
    .ALLOC 200
__BINEND: