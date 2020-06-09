.data

buf1:   .asciiz "hello world"
buf2:   .ascii "fffffffffffffffffffff"

.text
main:
        add a0, zero, buf2
        add a1, zero, buf1
        add a2, zero, 12
        jal memcpy_bytewise
        add a0, zero, 0
        add a7, zero, 93
        scall

; copy memory bytewise
; a0 = destination pointer
; a1 = source pointer
; a2 = length to copy
memcpy_bytewise:
    beq zero, a2, memcpy_ret
    lb  t1, 0(a1)
    sb  t1, 0(a0)
    add a0, a0, 1
    add a1, a1, 1
    add a2, a2, -1
    j memcpy_bytewise
memcpy_ret:
    ret