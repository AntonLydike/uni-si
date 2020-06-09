.data

buf1:   .asciiz "hello world"
buf2:   .ascii "fffffffffffffffffffff"

.text
main:
        add a0, zero, buf2
        add a1, zero, buf1

        ; introduce offset
        add a0, a0, 1
        add a1, a1, 1

        add a2, zero, 10

        jal memcpy
        add a0, zero, 0
        add a7, zero, 93
        scall

; copy memory
; a0 = destination pointer
; a1 = source pointer
; a2 = length to copy
; make sure a0 and a1 have the same alignment
; after executing, a0 and a1 are inceremented by a2
memcpy:
        ; copy unaligned bytes at the front
                            ; t1: number of unaligned bytes upfront
        and t1, a0, 0x03    ; t1 = startptr % 4
        add t2, zero, -1    ; use t2 register to store immediate (-1) for next instruction, is overwritten later
        mul t1, t1, t2      ; t1 = -t1
        add t1, t1, 4       ; t1 = 4 + t1
        add t2, a2, 0       ; t2: original length
        add t3, ra, 0       ; t3: return address
        add a2, t1, 0
        jal memcpy_bytewise ; copy the first bytes

        ; copy aligned bytes
        sub a2, t2, t1      ; subtract copied bytes from length, save to a2
                            ; t1: number of unaligned bytes at the back
        and t1, a2, 0x03    ; t1 = length % 4
        sub a2, a2, t1      ; subtract unaligned bytes from length
        jal memcpy_wordwise ; copy aligned bytes wordwise

        add a2, zero, t1    ; a2 = remaining bytes to copy
        jal memcpy_bytewise ; copy remaining bytes bytewise

        ; restore return address
        add ra, zero, t3
        ret



; copy memory wordwise
; a0 = destination pointer
; a1 = source pointer
; a2 = length to copy
; all pointers must be word aligned, length must be multiple of 4
; after executing, a0 and a1 are inceremented by a2
memcpy_wordwise:
        beq zero, a2, memcpy_ret
        lw  t0, 0(a1)
        sw  t0, 0(a0)
        add a0, a0, 4
        add a1, a1, 4
        add a2, a2, -4
        j memcpy_wordwise

; copy memory bytewise
; a0 = destination pointer
; a1 = source pointer
; a2 = length to copy
; after executing, a0 and a1 are inceremented by a2
memcpy_bytewise:
        beq zero, a2, memcpy_ret
        lb  t0, 0(a1)
        sb  t0, 0(a0)
        add a0, a0, 1
        add a1, a1, 1
        add a2, a2, -1
        j memcpy_bytewise
; one ret for all memcpys
memcpy_ret:
        ret