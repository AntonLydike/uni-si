        .data
buf:    .space 10
        .align 2

        .text
main:                                   # Programmbeginn

# Zeichenkette einlesen
        add     a0, zero, 0             # stdin
        add     a1, zero, buf           # Adresse des Puffers
        add     a2, zero, 10            # Maximal 10 Zeichen
        add     a7, zero, 63            # read
        scall
        nop                             # nach syscall 63 immer 3 Nops
        nop
        nop

# Zeichenkette in Zahl umwandeln (zahl = n)
        add     a1, zero, a0            # Länge der Zeichenkette
        add     a0, zero, buf           # Adresse der Zeichenkette
        jal     str2int
        add	s0, zero, a0		# s0: enthält das aktuelle teilprodukt n!/((n-s0)!)
        add	s1, zero, s0		# s1: enthält
        add	s2, zero, 3		# s2 = 3
# begin loop
fac_start:
        add	s1, s1, -1
        mul	s0, s0, s1
        bge 	s1, s2, fac_start	# jump to fac_start, while s1 >= 3


# Ergebnis in string umwwandeln
        add	a0, zero, s0
        add	a1, zero, buf
        jal	int2str

# String ausgeben
        add     a2, zero, a0            # Länge steht in a0
        add     a0, zero, 1             # stdout
        add     a1, zero, buf           # Adresse des Puffers
        add     a7, zero, 64            # syscall 64: write
        scall


# Programm beenden
        add     a0, zero, a0            # eingelesene Zahl als Exitcode
        add     a7, zero, 93            # sycall 93: exit
        scall



# ---------------------------------------------------------0000----------------------
# str2int: Unterprogramm um eine Zeichenkette in eine Zahl umzuwandeln
#       a0: Adresse der Zeichenkette
#       a1: Länge der Zeichenkette
# zurück:
#       a0: Umgewandelte Zahl
# -------------------------------------------------------------------------------

str2int:
        add     t2, zero, zero          # t2=0 (Rückgabewert)
        add     t0, zero, 10            # t0=10 (Konstante)
        add     a1, a1, a0              # a1= Ende der Zeichenkette

_str2int_loop:
        lb      t1, 0(a0)
        add     t1, t1, -48
        bgeu    t1, t0, _str2int_exit   # Abbruch, wenn keine Ziffer
        mul     t2, t2, t0
        add     t2, t2, t1
        add     a0, a0, 1               # ein Zeichen weiter
        blt     a0, a1, _str2int_loop   # Solange Ende nicht erreicht

_str2int_exit:
        add     a0, zero, t2            # schreibe Zahl in Rückgaberegister
        ret                             # kehre zum Aufrufer zurück

# -------------------------------------------------------------------------------
# int2str: Unterprogramm um eine Zahl in eine Zeichenkette umzuwandeln
#       a0: umzuwandelnde Zahl
#       a1: Adresse des Zeichenkettenpuffers, mindestens 10 Bytes lang, da die
#           Zahl maximal 2^31-1 = 4 294 967 295 sein kann.
# zurück:
#       a0: Tatsächliche Länge der Zeichenkette
# -------------------------------------------------------------------------------

int2str:
        add     t0, zero, 10
        add     t3, zero, 1
        beq     a0, zero, _int2str_max  # Spezialfall: "0" ausgeben
        add     t3, zero, 10            # t3= Maximale Länge der Ausgabe
        lui     t1, 0x3b9ad             # t1= 0x3b9ad000
        add     t1, t1, -0x600          # t1= 0x3b9ad000-0x600=0x3b9aca00
                                        #   = 1000000000 = 10^9
        bltu    t1, a0, _int2str_max    # Alle 10 Stellen ausgeben

_int2str_getlen:                        # Anzahl der Stellen ermitteln
        add     t3, t3, -1              # Länge der Ausgabe reduzieren
        div     t1, t1, t0
        bltu    a0, t1, _int2str_getlen

_int2str_max:
        add     t2, t3, a1              # t2= Zeiger auf Ende des Puffers

_int2str_loop:
        remu    t1, a0, t0
        divu    a0, a0, t0
        add     t1, t1, 48              # Zahl 0-9 in ASCII-Code '0'-'9' umwandeln
        add     t2, t2, -1
        sb      t1, 0(t2)
        blt     a1, t2, _int2str_loop

        add     a0, zero, t3            # Länge aus t3 zurückliefern
        ret
