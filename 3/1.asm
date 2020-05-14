main:
        add t1, zero, Zeichenkette
        add t3, zero, zero
        nop
Loop:   
        lb  t2, 0(t1)
        nop
        nop
        beq t2, zero, Finish
        nop
        nop
        nop
        add t3, t3, 1
        add t1, t1, 1
        nop
        j   Loop
        nop
        nop
        nop
Finish: 
        sw  t3, Laenge(zero)
        add a0, zero, 0
        add a7, zero, 93
        nop
        nop
        scall
    