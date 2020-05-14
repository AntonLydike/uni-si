        .data 0x300
num:    .space 4
res:    .space 4

        .text
main:   
        lw  t0, num(zero)   # t0 = num
        add t1, t0, 0       # t1 = num, added each iteration
        add t2, t0, -2      # when t2=2 we need to run loop once, therefore
                            # t2-2 < 0 is our exit condition at loop start
loop:
        blt t2, zero, end   # jump when t2 < 0
        add t2, t2, -1      # t2--
        add t0, t0, t1      # t0 += t1
        j   loop
end:    
        sw  t0, res(zero)
        add a0, zero, 0     # status code 0
        add a7, zero, 93    # syscall exit 
        scall