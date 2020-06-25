.data

.text
; belegungen:
;   s1: i
;   s2: j
;   s3: ergebnis
;   s4: start2
;   s5: 5 (schleifen)

        lw  s4, 0(sp)       ; // pop start2 from stack (s4 = start2)
        add sp, sp, 4
        lw  s1, 0(sp)       ; // pop start1 from stack (i  = start1)
        add sp, sp, 4

        add s5, zero, 5     ; s5 = 5
        add s3, zero, 0     ; regebnis = 0
for_start:                  ; while (i < s5) {
        bge s1, s5, for_end 
        add s2, s5, 0       ;   j = start2
while_start:                ;   while (j > i) {
        bge s1, s2, while_end
        add sp, sp, -4      ;       // push i onto the stack
        sw  s1, 0(sp)
        add sp, sp, -4      ;       // push j ontp the stack
        sw  s2, 0(sp)
        jal berechnung      ;       a0 = berechnung(i,j)
        add s3, a0, 0       ;       ergebnis += a0
        add s2, s2, -1      ;       j--
        j   while_start     ;   }
while_end:
        add s1, s1, 1       ;   i++
        j   for_start       ; }
for_end:
        add ergebnis a0     ; return a0