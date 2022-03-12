

.ALIAS data1 0x0F40
.ALIAS data2 0x00C3

; Memory starts with a jump table for all interrupts.
; We aren't using this functionality, so we can simply set up a quick and dirty
; default jump table
jump_table:
    JMP start      ; RESET
    JMP jump_table ; TIMER TICK
    JMP jump_table ; BAD MEM ACCESS
    JMP jump_table ; STACK OVERFLOW
    JMP jump_table ; STACK UNDERFLOW
bad_instruction:
    JMP jump_table ; BAD INSTRUCTION

; Not using any user defined interrupts, but in the future that will change.
; Even if an interrupt is not specified, there must be some error handling system.
; I recommend the following for unused user defined interrupts:
    JMP bad_instruction
    JMP bad_instruction

start:
    SET 0x10 data1
    SET 0x11 data2
    ADD 0x2F 0x10 0x11

loop:
    INC 0x2F
    RJMP loop
