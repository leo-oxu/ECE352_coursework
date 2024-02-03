.global main

main:
addi	r4,r4,0xa		
addi 	sp,sp,-8
stw 	ra, 4(sp)
stw 	r4, 0(sp)
call 	printOct
ldw	r4, 0(sp)
call	printHex
ldw	r4, 0(sp)
call	printDec
ldw	ra,4(sp)
addi	sp,sp,8

ret	
