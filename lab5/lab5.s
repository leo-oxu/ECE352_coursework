.text
.global _start
_start:
OnePossibleAlgorithm:
  call ReadSensorsAndSpeed()
  
  movi r5,0x1e
  beq r3,r5,steer_right
  movi r5,0x1c
  beq r3,r5,steer_hright
  movi r5,0x0f
  beq r3,r5,steer_left
  movi r5,0x07
  beq r3,r5,steer_hleft
straight:
  movia r7, 0x10001020 
WRITE_straight:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_straight
  movui r2, 0x05 
  stwio r2, 0(r7)
WRITE_straight2:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_straight2 
  movui r2, 0x0
  stwio r2, 0(r7)
  br after

steer_right:
  movia r7, 0x10001020 
WRITE_RIGHT1:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_RIGHT1 
  movui r2, 0x05 
  stwio r2, 0(r7)
WRITE_RIGHT2:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_RIGHT2 
  movui r2, 0x7f 
  stwio r2, 0(r7)
movi r6,0x20
blt r4,r6,after
movui r8, 0x80
br WRITE_SPEED1

steer_hright:
  movia r7, 0x10001020 
WRITE_hRIGHT1:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_hRIGHT1 
  movui r2, 0x05 
  stwio r2, 0(r7)
WRITE_hRIGHT2:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_hRIGHT2 
  movui r2, 0x7F 
  stwio r2, 0(r7)
movui r8, 0x80
br WRITE_SPEED1

steer_left:
  movia r7, 0x10001020 
WRITE_LEFT1:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_LEFT1 
  movui r2, 0x05 
  stwio r2, 0(r7)
WRITE_LEFT2:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_LEFT2 
  movui r2, 0x80 
  stwio r2, 0(r7)
  movi r6,0x20
br after


steer_hleft:
  movia r7, 0x10001020 
WRITE_hLEFT1:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_hLEFT1 
  movui r2, 0x05 
  stwio r2, 0(r7)
WRITE_hLEFT2:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_hLEFT2 
  movui r2, 0x80 
  stwio r2, 0(r7)
movui r8, 0x80
br WRITE_SPEED1

after:
   
movi r6,0x30
beq r4,r6,zeroa
bgt r4,r6,decrease
blt r4,r6,increase

zeroa:
mov r8,r0
br WRITE_SPEED1

decrease:
movui r8, 0x80
br WRITE_SPEED1

increase: 
movui r8, 0x7f

WRITE_SPEED1:

movia r7, 0x10001020 
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_SPEED1 
  movui r2, 0x04 
  stwio r2, 0(r7)
WRITE_SPEED2:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_SPEED2 
  mov r2, r8 
  stwio r2, 0(r7)
  br OnePossibleAlgorithm
 
 
	
ReadSensorsAndSpeed:
  
movia r7, 0x10001020 
WRITE_POLL:
  ldwio r3, 4(r7) 
  srli  r3, r3, 16 
  beq   r3, r0, WRITE_POLL 
  movui r2, 0x02 
  stwio r2, 0(r7) 

READ_POLL:
  ldwio r2, 0(r7) 
  andi  r3, r2, 0x8000 
  beq   r3, r0, READ_POLL 
  andi  r3, r2, 0x00FF 

READ_POLL2:
  ldwio r2, 0(r7) 
  andi  r3, r2, 0x8000
  beq   r3, r0, READ_POLL2 
  andi  r3, r2, 0x001F
 
READ_POLL3:
  ldwio r2, 0(r7) 
  andi  r4, r2, 0x8000 
  beq   r4, r0, READ_POLL3 
  andi  r4, r2, 0x00FF 

ret


