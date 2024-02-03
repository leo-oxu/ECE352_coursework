.equ RED_LEDS, 0xFF200000 	   # (From DESL website > NIOS II > devices)


.data                              # "data" section for input and output lists


IN_LIST:                  	   # List of 10 signed halfwords starting at address IN_LIST
    .hword 1
    .hword -1
    .hword -2
    .hword 2
    .hword 0
    .hword -3
    .hword 100
    .hword 0xff9c
    .hword 0b1111
LAST:			 	    # These 2 bytes are the last halfword in IN_LIST
    .byte  0x01		  	    # address LAST
    .byte  0x02		  	    # address LAST+1
    
IN_LINKED_LIST:                     # Used only in Part 3
    A: .word 1
       .word B
    B: .word -1
       .word C
    C: .word -2
       .word E + 8
    D: .word 2
       .word C
    E: .word 0
       .word K
    F: .word -3
       .word G
    G: .word 100
       .word J
    H: .word 0xffffff9c
       .word E
    I: .word 0xff9c
       .word H
    J: .word 0b1111
       .word IN_LINKED_LIST + 0x40
    K: .byte 0x01		    # address K
       .byte 0x02		    # address K+1
       .byte 0x03		    # address K+2
       .byte 0x04		    # address K+3
       .word 0
    
OUT_NEGATIVE:
    .skip 0x40                         # Reserve space for 10 output words
    
OUT_POSITIVE:
    .skip 0x40                        # Reserve space for 10 output words

#-----------------------------------------

.text                  # "text" section for code

    # Register allocation:
    #   r0 is zero, and r1 is "assembler temporary". Not used here.
    #   r2  Holds the number of negative numbers in the list
    #   r3  Holds the number of positive numbers in the list
    #   r_  A pointer to ___
    #   r_  loop counter for ___
    #   r16, r17 Short-lived temporary values.
    #   etc...

.global _start 
_start:
	addi 	r3, r0, 0x0
	addi 	r2, r0, 0x0
	movia	r9, OUT_POSITIVE
	movia	r8, OUT_NEGATIVE
	movia	r6, IN_LIST
	addi	r5, r0, 0xa
	addi 	r4, r0, 0x0
COND:
	beq		r4, r5, END
FUNC:
	ldh		r7, 0(r6)
	blt 	r7, r0, NEG
POS:
	beq 	r7, r0, END
	sth		r7, 0(r9)
	addi	r3, r3, 0x1
	addi	r9, r9 ,0x2
	br 		POST
NEG:
	sth		r7, 0(r8)
	addi	r2, r2, 0x1
	addi	r8, r8 ,0x2
POST:
	addi	r6, r6, 0x2
	movia  	r16, RED_LEDS          # r16 and r17 are temporary values
    add   	r17,r2,r3
    stwio  	r17, 0(r16)
	br COND
	
	
END:
	br END
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	# movia	r16, RED_LEDS          
	# ldwio	r17, 0(r16)
    # addi	r17, r17, 1
	# stwio	r17, 0(r16)


