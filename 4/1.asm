        add t1, t0, 1       #S1
        sll t4, t1, t1      #S7 result overwritten by S4
        add t3, t0, 20      #S3
        sll t4, t1, 4       #S4 this is okay, since S7 is never executed in the original 
        add t2, t1, 100     #S2
        and s1, t1, t1      #S5
        sub s2, t3, t4      #S6
        j label
        add s2, t4, t3      #S8
label:
        add t0,t0,t0        #S9
