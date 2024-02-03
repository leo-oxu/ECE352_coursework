.text
.global _start
_start:
.equ ADDR_JP1, 0xFF200060   # address GPIO JP1

movia  r8, ADDR_JP1
movia  r10, 0x07f557ff     # set direction for motors and sensors to output and sensor data register to inputs
stwio  r10, 4(r8)

loop3:
ldwio	r5, 0(r8)
andi	r5, r5, 0x3
movia  	r11, 0xfffefffc     
or 	r11, r11, r5
stwio  	r11, 0(r8)
ldwio  r5,  0(r8)          
srli   r6,  r5,17                  
andi   r6,  r6,0x1
bne    r0,  r6,loop3        
srli   r5, r5, 27          
andi   r5, r5, 0x0f

loop1:
ldwio	r4, 0(r8)
andi	r4, r4, 0x3
movia  	r11, 0xffffeffc     
or 	r11, r11, r5
stwio  	r11, 0(r8)
ldwio  r4,  0(r8)          
srli   r6,  r4,13                   
andi   r6,  r6,0x1
bne    r0,  r6,loop1        
srli   r4, r4, 27         
andi   r4, r4, 0x0f

comparison:
blt	r4, r5, counterclockwise

clockwise:
movia	 r10, 0xfffffffc       
stwio	 r10, 0(r8)	
br Then

counterclockwise:
movia r10, 0xfffffffe
stwio r10, 0(r8)

Then:
call timer
movia  	r11, 0xffffffff
stwio  	r11, 0(r8)
call timer
br loop3

timer:
movia r11, 0xFF202000                   
movi	r12, 1
stw	r12,0(r11)
movui r12, 262150
stwio r12, 8(r11)                         
stwio r0, 12(r7)
movui r12, 4
stwio r12, 4(r11)                          
check:
ldw	r14,0(r11)
andi 	r14,r14,1
bne	r14, 1, check
Ret
	