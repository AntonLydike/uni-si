        .data
str:	.asciiz     "Ich mag Informatik! 123?"
        .align      2

        .text
main:
        add s0, zero, 0      # s0 = 0 (iterator)
# set up constant vars for to_upper function
        add t0, zero, 96     # const t0 = 97
        add t1, zero, 123    # const t1 = 123

loop_start:
        lb  a0, str(s0)	    # a0 = str[s0]
        beq a0, zero, end	# if (a0 == 0) break
        jal to_upper        # a0 = to_uppercase(a0)
        sb  a0, str(s0)     # str[s0] = a0
        add	s0, s0, 1       # a0++
        j   loop_start
end:
        add a7, zero, 93    # call exit
        scall
        
# a0 = to_uppercase(a0)
to_upper:
        bge a0, t0, _to_upper_is_ge_97	# if !(a0 >= 97)
        ret                             # return
_to_upper_is_ge_97:
        bge t0, a0, _to_upper_ret       # return if 123 >= a0
        # if we are here, a0 element of [97, 122]
        # lower to upper: lower - 32
        add a0, a0, -32	                # a0 -= 32
_to_upper_ret:
        ret
