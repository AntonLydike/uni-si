        .data
buf:    .asciiz "[Object object]"
        .align 2

len:    .space 4
        .align 2

        .text
main:                                   # Programmbeginn

# Registerbelegung:
# s0: das geladene byte
# s1: verschiebung im text buffer 
# (wird zu beginn um 1 erhöht, deshalb beginnen wir mit -1)
        add     s1, zero, -1


loop:
        add     s1, s1, 1                   # increment pointer
        lbu     s0, buf(s1)                 # load byte from buff at position s1
        bne     s0, zero, loop              # repeat if non-null byte

# Ergebnis in string umwwandeln
        add	    a0, zero, s1
        add	    a1, zero, len
        jal	    int2str

# String ausgeben
        add     a2, zero, a0            # Länge steht in a0
        add     a0, zero, 1             # stdout
        add     a1, zero, len           # Adresse des Puffers
        add     a7, zero, 64            # syscall 64: write
        scall

# Programm beenden
        add     a0, zero, a0            # eingelesene Zahl als Exitcode
        add     a7, zero, 93            # sycall 93: exit
        scall


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
