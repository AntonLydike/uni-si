.data

buf1:   .asciiz "hello world"
buf2:   .ascii "fffffffffffffffffffff"

.text
main:
        add a0, zero, buf2
        add a1, zero, buf1
        add a2, zero, 12
        jal memcpy_wordwise
        add a0, zero, 0
        add a7, zero, 93
        scall

; copy memory wordwise
; a0 = destination pointer
; a1 = source pointer
; a2 = length to copy
; all pointers must be word aligned, length must be multiple of 4
memcpy_wordwise:
    beq zero, a2, memcpy_ret
    lw  t1, 0(a1)
    sw  t1, 0(a0)
    add a0, a0, 4
    add a1, a1, 4
    add a2, a2, -4
    j memcpy_wordwise
memcpy_ret:
    ret