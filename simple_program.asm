

; A hello world program.

.ALIAS HELLO_WORLD 0x050

.ALIAS CHARACTER_OFFSET 0x04
.ALIAS CURRENT_CHAR_PAIR 0x05
.ALIAS CURRENT_CHAR 0x06

start:
    SET CHARACTER_OFFSET 0x00

; The print loop
prnt_loop:
    ; Fetch the next character pair
    CALL fetch_next
    
    ; Copy data, check for null character
    MOV CURRENT_CHAR CURRENT_CHAR_PAIR
    ANDI CURRENT_CHAR 0xFF00
    CJMP CURRENT_CHAR success_got_c1
    SHUTDOWN

success_got_c1:
    ; Print current char
    PRINTH CURRENT_CHAR

    ; Copy data, check for null character
    MOV CURRENT_CHAR CURRENT_CHAR_PAIR
    ANDI CURRENT_CHAR 0x00FF
    CJMP CURRENT_CHAR success_got_c2
    SHUTDOWN

success_got_c2:
    PRINTL CURRENT_CHAR
    JMP prnt_loop

; Fetches the next character from the string
fetch_next:
    SET CURRENT_CHAR_PAIR HELLO_WORLD
    ADD CURRENT_CHAR_PAIR CURRENT_CHAR_PAIR CHARACTER_OFFSET
    LD CURRENT_CHAR_PAIR
    INC CHARACTER_OFFSET
    RET

; The string
.ORG HELLO_WORLD
    .TEXT "Hello World!"

