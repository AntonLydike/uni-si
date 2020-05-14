        .data

        .text
main:
        mul	t3, t1, t3
        mul	t1, t1, t1
        nop
        add	t2, t2, t3
        mul	t4, t4, t1
        nop
        nop
        add	t2, t2, t4

        add	a7, zero, 93
        scall 