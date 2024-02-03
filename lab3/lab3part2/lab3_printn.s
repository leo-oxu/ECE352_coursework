/*********
 * 
 * Write the assembly function:
 *     printn ( char * , ... ) ;
 * Use the following C functions:
 *     printHex ( int ) ;
 *     printOct ( int ) ;
 *     printDec ( int ) ;
 * 
 * Note that 'a' is a valid integer, so movi r2, 'a' is valid, and you don't need to look up ASCII values.
 *********/

.global	printn
printn: 
addi	sp,sp,-36
stw	ra, 0(sp)
stw	r16, 4(sp) 	# caller of printn's r16
stw	r17, 8(sp) 	# caller of printn's r17
stw	r18, 12(sp) 	
stw	r19, 16(sp) 	
stw	r20, 20(sp)
stw	r5, 24(sp) 	# first number
stw	r6, 28(sp) 	# second number
stw	r7, 32(sp)	# third number
addi	r16, sp, 24
mov	r17, r4 	# char*
movi 	r18, 'H'
movi 	r19, 'O'
movi 	r20, 'D'			

LOOP:
ldb	r5, 0(r17) 
ldw	r4, 0(r16) 
beq	r5,r0,EPI 
check:
beq	r5, r19, IFO
beq	r5, r20, IFD
call	printHex
br	AFTER
IFO:
call	printOct
br	AFTER
IFD:
call	printDec
AFTER:
addi	r17,r17,1
addi	r16,r16,4
br	LOOP
EPI:
ldw	ra, 0(sp)
ldw	r16, 4(sp) 	
ldw	r17, 8(sp) 
ldw	r18, 12(sp) 	
ldw	r19, 16(sp) 	
ldw	r20, 20(sp)
addi	sp,sp,36

ret