/* ff kernel    -*- fundamental -*- 

 Register usage:

  TOS: r0
  SP:  r13
  RP:  r14
  AP:  r12
  W:   r11

*/


.equ HEAP_SIZE,10000000
.equ SSTACK_SIZE, 4096
.equ RSTACK_SIZE, 4096


  .text

  .global _start
_start:
  ldr r1, =v_dp
  ldr r1, [r1, #4]
  ldr r1, [r1]
  add r0, r1, #8
  ldrb r2, [r1, #4]
  add r0, r0, r2
  bic r0, r0, #3
  add r12, r0, #4		@ align and add 1
  ldr r0, =heaptop
  str r13, [r0, #-4]

.macro NEXT
  ldr r11, [r12], #4
  ldr pc, [r11]
.endm

  NEXT

reset:
  ldr r14, =rstack
  NEXT

clear:
  ldr r13, =sstack_end
  NEXT 

colon:
  str r12, [r14], #4
  add r12, r11, #4
  NEXT

dodoes:                         @ ( -- a )
  str r12, [r14], #4
  ldr r12, [r11, #4]
  str r0, [r13, #-4]!
  add r0, r11, #8
  NEXT

jump: 				@ ( -- )
  ldr r12, [r12]
  NEXT

cjump:				@ ( f -- )
  ldr r1, [r12], #4
  tst r0, r0
  bne cjump_1
  mov r12, r1
cjump_1:
  ldr r0, [r13], #4
  NEXT

fetch:				@ ( a -- n )
  ldr r0, [r0]
  NEXT

store:				@ ( n a -- )
  ldr r1, [r13], #4
  str r1, [r0]
  ldr r0, [r13], #4
  NEXT

cfetch:				@ ( a -- c )
  ldrb r0, [r0]
  NEXT

cstore:				@ ( c a -- )
  ldr r1, [r13], #4
  strb r1, [r0]
  ldr r0, [r13], #4
  NEXT

terminate:                      @ ( n -- )
  mov r1, r0                    @ code
  mov r7, #1			@ sys_exit
  swi 0

fsopen:				@ ( cstr flags mode -- fd )
  mov r2, r0			@ mode
  ldr r1, [r13], #4		@ flags
  ldr r0, [r13], #4		@ name
  mov r7, #5	 		@ sys_open
  swi 0
  NEXT

fsclose:			@ ( fd -- n )
  mov r7, #6			@ sys_close
  swi 0
  NEXT

fsread:				@ ( a n fd -- n2 )
  ldr r2, [r13], #4		@ size
  ldr r1, [r13], #4		@ buf 
  mov r7, #3			@ sys_read
  swi 0
  NEXT

fswrite:			@ ( a n fd -- n2 )
  ldr r2, [r13], #4		@ size
  ldr r1, [r13], #4		@ buf
  mov r7, #4			@ sys_write
  swi 0
  NEXT

fsseek:				@ ( pos fd -- n )
  ldr r1, [r13], #4		@ offset
  mov r2, #0			@ SEEK_SET
  mov r7, #19			@ sys_lseek
  swi 0
  NEXT

mmap:                           @ ( a1 -- a2 )
  mov r7, #90                   @ old_mmap
  swi 0
  NEXT

variable:			@ ( -- a )
  str r0, [r13, #-4]!
  add r0, r11, #4
  NEXT

constant:			@ ( -- n )
  str r0, [r13, #-4]!
  ldr r0, [r11, #4]
  NEXT

literal:			@ ( -- n )
  str r0, [r13, #-4]!
  ldr r0, [r12], #4
  NEXT

sliteral:			@ ( -- a n )
  str r0, [r13, #-4]!
  ldrb r0, [r12], #1
  str r12, [r13, #-4]!
  add r12, r12, r0
  add r12, r12, #3
  bic r12, r12, #3
  NEXT

exit:
  ldr r12, [r14, #-4]!
  NEXT  

doinit:				@ ( hi lo -- )
  str r0, [r14], #4
  ldr r0, [r13], #4
  str r0, [r14], #4
  ldr r0, [r13], #4
  NEXT

doloop:
  ldr r1, [r14, #-8]
  add r1, r1, #1
doloop1:
  ldr r2, [r14, #-4]
  cmp r1, r2
  bge doloop2
  str r1, [r14, #-8]
  ldr r12, [r12]
  NEXT
doloop2:
  add r12, r12, #4
  sub r14, r14, #8
  NEXT

doploop:			@ ( n -- )
  ldr r1, [r14, #-8]
  add r1, r1, r0
  ldr r0, [r13], #4
  b doloop1

rfetch:				@ ( -- n )
  str r0, [r13, #-4]!
  ldr r0, [r14, #-4]
  NEXT

rpush:				@ ( n -- )
  str r0, [r14], #4
  ldr r0, [r13], #4
  NEXT

rpop:				@ ( -- n )
  str r0, [r13, #-4]!
  ldr r0, [r14, #-4]!
  NEXT

i: 				@ ( -- n )
  str r0, [r13, #-4]!
  ldr r0, [r14, #-8]
  NEXT

j: 				@ ( -- n )
  str r0, [r13, #-4]!
  ldr r0, [r14, #-16]
  NEXT

plus:				@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  add r0, r0, r1
  NEXT  

minus:				@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  sub r0, r1, r0
  NEXT

multiply:			@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  mul r0, r1, r0
  NEXT  

slashmod:			@ ( n1 n2 -- n3 n4 )
  mov r1, r0
  ldr r0, [r13]

@ from: http://www.peter-cockerell.net/aalp/html/ch-6.html:

sdiv32:			        @ r0 = lhs, r1 = rhs -> r2 = div, r3 = mod
  eors r5, r0, r1               @ divsgn
  movs r6, r0                   @ modsgn
  rsbmi r0, r0, #0
  teq r1, #0
  rsbmi r1, r1, #0
  b udiv32
sdiv32r:
  teq r5, #0
  rsbmi r2, r2, #0
  teq r6, #0
  rsbmi r3, r3, #0
  str r3, [r13]
  mov r0, r2
  NEXT
udiv32:				@ r0 = lhs, r1 = rhs -> r2 = div, r3 = mod
  @ teq r1, #0
  @ beq div_error
  mov r2, #0
  mov r3, #0
  mov r4, #32			@ count
udiv32_1:
  subs r4, r4, #1
  beq sdiv32r
  movs r0, r0, asl #1
  bpl udiv32_2
udiv32_2:
  movs r0, r0, asl #1
  adc r3, r3, r3
  cmp r3, r1
  subcs r3, r3, r1
  adc r2, r2, r2
  subs r4, r4, #1
  bne udiv32_2
  b sdiv32r

@ uses a different algorithm, as the code above doesn't do a full unsigned 32 bit divide
uslashmod:                      @ ( u1 u2 -- u3 u4 )
  ldr r5, [r13]
  mov r4, r0
  mov r2, r4
  cmp r2, r5, lsr #1
usm1:
  movls r2, r2, lsl #1
  cmp r2, r5, lsr #1
  bls usm1
  mov r0, #0
usm2:
  cmp r5, r2
  subcs r5, r5, r2
  adc r0, r0, r0
  mov r2, r2, lsr #1
  cmp r2, r4
  bhs usm2
  str r5, [r13]
  NEXT

binand:				@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  and r0, r0, r1
  NEXT

binor:				@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  orr r0, r0, r1
  NEXT

binxor:				@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  eor r0, r0, r1
  NEXT

xswap:				@ ( x y -- y x )
  ldr r1, [r13]
  str r0, [r13]
  mov r0, r1
  NEXT

drop:				@ ( x -- )
  ldr r0, [r13], #4
  NEXT

dup:				@ ( x -- x x )
  str r0, [r13, #-4]!
  NEXT

over:				@ ( x y -- x y x )
  str r0, [r13, #-4]!
  ldr r0, [r13, #4]
  NEXT

equal:				@ ( x y -- f )
  ldr r1, [r13], #4
  mov r2, r0
  mov r0, #0
  cmp r1, r2
  moveq r0, #-1
  NEXT
  
greater:			@ ( x y -- f )
  ldr r1, [r13], #4
  mov r2, r0
  mov r0, #0
  cmp r1, r2
  movgt r0, #-1
  NEXT
  
less:				@ ( x y -- f )
  ldr r1, [r13], #4
  mov r2, r0
  mov r0, #0
  cmp r1, r2
  movlt r0, #-1
  NEXT

stackptr:			@ ( -- a ) does not include TOS!
  str r0, [r13, #-4]!
  mov r0, r13
  NEXT

lshift:				@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  lsl r0, r1, r0
  NEXT
  
rshift:				@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  lsr r0, r1, r0
  NEXT

rshifta:			@ ( n1 n2 -- n )
  ldr r1, [r13], #4
  asr r0, r1, r0
  NEXT

execute:			@ ( ... a -- ... )
  mov r11, r0
  ldr r0, [r13], #4
  ldr pc, [r11]

deferred:
  ldr r11, [r11, #4]
  ldr pc, [r11]

unloop:
  sub r14, r14, #8
  NEXT

cmove:				@ ( a1 a2 n -- )
  ldr r2, [r13], #4
  ldr r1, [r13], #4
  movs r3, r0
  ldr r0, [r13], #4
  beq cmove_n
cmove_1:
  ldrb r4, [r1], #1
  strb r4, [r2], #1
  subs r3, r3, #1
  bne cmove_1
cmove_n:
  NEXT

cmoveb:				@ ( a1 a2 n -- )
  ldr r2, [r13], #4
  ldr r1, [r13], #4
  add r1, r1, r0
  add r2, r2, r0
  movs r3, r0
  ldr r0, [r13], #4
  beq cmoveb_n
cmoveb_1:
  ldrb r4, [r1, #1]!
  strb r4, [r2, #1]!
  subs r3, r3, #1
  bne cmoveb_1
cmoveb_n:
  NEXT

cas:				@ ( a old new -- f )
  mov r1, r0                    @ new
  ldr r2, [r13], #4             @ old
  ldr r3, [r13], #4             @ addr
  ldrex r0, [r3]
  cmp r2, r0
  strexeq r0, r1, [r3]
  cmpeq r0, #0
  moveq r0, #-1
  NEXT


  .ltorg

_end:


@@@ dictionary

  .data

.equ LAST, 0

.macro MENTRY name, label, len
link\@: .word LAST
  .equ LAST, link\@
  .byte \len
  .ascii "\name"
  .balign 4
m_\label :
  .word \label
.endm

.macro CENTRY name, label, len
link\@: .word LAST
  .equ LAST, link\@
  .byte \len
  .ascii "\name"
  .balign 4
\label :
  .word colon
.endm

.macro CIENTRY name, label, len
link\@: .word LAST
  .equ LAST, link\@
  .byte \len | 0x80
  .ascii "\name"
  .balign 4
\label :
  .word colon
.endm

.macro MVENTRY name, label, val, len
link\@: .word LAST
  .equ LAST, link\@
  .byte \len
  .ascii "\name"
  .balign 4
v_\label :
  .word constant
  .word \val
.endm

.macro VENTRY name, label, len
link\@: .word LAST
  .equ LAST, link\@
  .byte \len
  .ascii "\name"
  .balign 4
\label :
  .word variable
  .word 0
.endm


.include "primitives.s"
.include "words-gas.s"


  .balign 4

htop: .word heap
dtop: .word LAST
heapend: .word heaptop


  .bss

tibuffer: .skip 1024
wordbuffer: .skip 256
heap: .skip HEAP_SIZE
heaptop: 
rstack: .skip RSTACK_SIZE
sstack: .skip SSTACK_SIZE
sstack_end:
