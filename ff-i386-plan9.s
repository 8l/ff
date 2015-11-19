;;;; ff kernel, i386 Plan 9 variant
;
; Register usage:
;
; TOS: eax
; SP:  esp
; RP:  ebp
; AP:  esi
; W:   edi


  bits 32


HEAP_SIZE equ 10000000
SSTACK_SIZE equ 4096
RSTACK_SIZE equ 4096


  org 0x1000

; a.out header:

  db 0, 0, 1, 0xeb  ; magic
  ;; these should be big-endian, but we change them later, anyway
  dd 0           ; textsize XXX
  dd 0           ; datesize XXX
  dd 0           ; bsssize XXX
  dd 0           ; size of symtable
  dd 0           ; entry point
  dd 0           ; sp/pc offset table size
  dd 0           ; pc/ln table size

_start:
  mov ebx, [v_dp + 4]
  mov ebx, [ebx]
  mov eax, ebx
  add eax, 8
  xor ecx, ecx
  mov cl, [ebx + 4]
  add eax, ecx
  and eax, ~3
  lea esi, [eax + 4]
  mov [heaptop - 4], esp        ; argc + argv

%macro NEXT 0 
  mov edi, [esi]
  add esi, 4
  mov ebx, [edi]
  jmp ebx
%endm

  NEXT

reset:
  mov ebp, rstack
  NEXT

clear:
  mov esp, sstack_end
  NEXT 

colon:
  mov [ebp], esi
  add ebp, 4
  lea esi, [edi + 4]
  NEXT

dodoes:		                ; ( -- a )
  mov [ebp], esi
  add ebp, 4
  mov esi, [edi + 4]
  push eax
  lea eax, [edi + 8]
  NEXT

jump: 				; ( -- )
  mov esi, [esi]
  NEXT

cjump:				; ( f -- )
  mov ebx, [esi]
  add esi, 4
  test eax, eax
  jnz .l1
  mov esi, ebx
.l1:
  pop eax
  NEXT

fetch:				; ( a -- n )
  mov eax, [eax]
  NEXT

store:				; ( n a -- )
  pop dword [eax]
  pop eax
  NEXT

cfetch:				; ( a -- c )
  xor ebx, ebx
  mov bl, [eax]
  mov eax, ebx
  NEXT

cstore:				; ( c a -- )
  pop ebx
  mov [eax], bl
  pop eax
  NEXT

terminate:                      ; ( n -- )
  xor ebx, ebx
  test eax, eax
  jz .l1
  mov ebx, failtext
.l1:
  push ebx
  sub esp, 4                    ; dummy retaddr
  mov eax, 8			; EXITS
  int 64  

failtext:
  db 'error', 0

fsopen:				; ( cstr flags mode -- fd )
  pop ebx                       ; flags
  pop ecx                       ; name
  push eax
  mov eax, 14                   ; OPEN
  test ebx, 512                 ; O_CREAT?
  jz .l1
  mov eax, 22                   ; CREATE
.l1:
  and ebx, 0xf                  ; retain only OREAD, OWRITE, ORDWR
  push ebx
  push ecx
  sub esp, 4                    ; dummy retaddr
  int 64
  add esp, 16
  NEXT
  nop
  nop
  nop
  nop
  nop

fsclose:			; ( fd -- n )
  push eax                      ; fd
  sub esp, 4                    ; dummy retaddr
  mov eax, 4			; CLOSE
  int 64
  add esp, 8
  NEXT
  nop
  nop
  nop
  nop
  nop

fsread:				; ( a n fd -- n2 )
  pop ecx                       ; size
  pop edx                       ; buf
  mov ebx, -1                   ; -1LL (seek pos)
  push ebx
  push ebx
  push ecx
  push edx
  push eax
  sub esp, 4                    ; dummy retaddr
  mov eax, 50   			        ; PREAD
  int 64
  add esp, 24
  NEXT
  nop
  nop
  nop
  nop
  nop
  nop
  nop

fswrite:			; ( a n fd -- n2 )
  pop ecx                       ; size
  pop edx                       ; buf
  mov ebx, -1                   ; -1LL (seek pos)
  push ebx
  push ebx
  push ecx
  push edx
  push eax
  sub esp, 4                    ; dummy retaddr
  mov eax, 51		   	        ; PWRITE
  int 64
  add esp, 24
  NEXT
  nop
  nop
  nop
  nop
  nop
  nop
  nop

fsseek:				; ( pos fd -- n )
  pop ebx                       ; offset
  xor edx, edx		                ; type 0
  sub esp, 8                    ; space for vlong result
  mov ecx, esp
  push edx
  push edx                      ; high part of position (0)
  push ebx                      ; low part
  push eax  
  push ecx                      ; result ptr
  sub esp, 4                    ; dummy retaddr
  mov eax, 39		                ; SEEK
  int 64
  add esp, 32
  NEXT

mmap: 				; ( a1 -- a2 )
  mov eax , -1                  ; unimplemented
  NEXT

variable:			; ( -- a )
  push eax
  lea eax, [edi + 4]
  NEXT

constant:			; ( -- n )
  push eax
  mov eax, [edi + 4]
  NEXT

literal:			; ( -- n )
  push eax
  mov eax, [esi]
  add esi, 4
  NEXT

sliteral:			; ( -- a n )
  push eax
  xor eax, eax
  mov al, [esi]
  inc esi
  push esi
  add esi, eax
  add esi, 3
  and esi, ~3
  NEXT

exit:
  sub ebp, 4
  mov esi, [ebp]
  NEXT  

doinit:				; ( hi lo -- )
  mov [ebp], eax
  pop eax
  mov [ebp + 4], eax
  pop eax
  add ebp, 8
  NEXT

doloop:
  inc dword [ebp - 8]
doloop1:
  mov ebx, [ebp - 8]
  cmp ebx, [ebp - 4]
  jge .l1
  mov esi, [esi]
  NEXT
.l1:
  sub ebp, 8
  add esi, 4
  NEXT

doploop:			; ( n -- )
  add [ebp - 8], eax
  pop eax
  jmp doloop1

rfetch:				; ( -- n )
  push eax
  mov eax, [ebp - 4]
  NEXT

rpush:				; ( n -- )
  mov [ebp], eax
  pop eax
  add ebp, 4
  NEXT

rpop:				; ( -- n )
  push eax
  sub ebp, 4
  mov eax, [ebp]
  NEXT

i: 				; ( -- n )
  push eax
  mov eax, [ebp - 8]
  NEXT

j: 				; ( -- n )
  push eax
  mov eax, [ebp - 16]
  NEXT

plus:				; ( n1 n2 -- n )
  pop ebx
  add eax, ebx
  NEXT  

minus:				; ( n1 n2 -- n )
  pop ebx
  sub ebx, eax
  mov eax, ebx
  NEXT  

multiply:			; ( n1 n2 -- n )
  pop ebx
  imul ebx
  NEXT  

slashmod:			; ( n1 n2 -- n3 n4 )
  mov ebx, eax
  mov eax, [esp]
  cdq
  idiv ebx
  mov [esp], edx
  NEXT

uslashmod:			; ( u1 u2 -- u3 u4 )
  mov ebx, eax
  mov eax, [esp]
  xor edx, edx
  div ebx
  mov [esp], edx
  NEXT

binand:				; ( n1 n2 -- n )
  and eax, [esp]
  add esp, 4
  NEXT

binor:				; ( n1 n2 -- n )
  or eax, [esp]
  add esp, 4
  NEXT

binxor:				; ( n1 n2 -- n )
  xor eax, [esp]
  add esp, 4
  NEXT

xswap:				; ( x y -- y x )
  xchg [esp], eax
  NEXT

drop:				; ( x -- )
  pop eax
  NEXT

dup:				; ( x -- x x )
  push eax
  NEXT

over:				; ( x y -- x y x )
  push eax
  mov eax, [esp + 4]
  NEXT

equal:				; ( x y -- f )
  pop ebx
  cmp ebx, eax
  je true
  xor eax, eax
  NEXT
true:
  mov eax, -1
  NEXT
  
greater:			; ( x y -- f )
  pop ebx
  cmp ebx, eax
  jg true
  xor eax, eax
  NEXT
  
less:				; ( x y -- f )
  pop ebx
  cmp ebx, eax
  jl true
  xor eax, eax
  NEXT

stackptr:			; ( -- a ) does not include TOS!
  push eax
  mov eax, esp
  NEXT

lshift:				; ( n1 n2 -- n )
  mov ecx, eax
  pop eax
  shl eax, cl
  NEXT
  
rshift:				; ( n1 n2 -- n )
  mov ecx, eax
  pop eax
  shr eax, cl
  NEXT

rshifta:			; ( n1 n2 -- n )
  mov ecx, eax
  pop eax
  sar eax, cl
  NEXT

execute:			; ( ... a -- ... )
  mov edi, eax
  pop eax
  mov ebx, [edi]
  jmp ebx

deferred:
  mov edi, [edi + 4]
  mov ebx, [edi]
  jmp ebx

unloop:
  sub ebp, 8
  NEXT

cmove:				; ( a1 a2 n -- )
  mov ecx, eax
  pop edi
  mov ebx, esi
  pop esi
  rep movsb
  mov esi, ebx
  pop eax
  NEXT

cmoveb:				; ( a1 a2 n -- )
  mov ecx, eax
  pop edi
  dec eax
  add edi, eax
  mov ebx, esi
  pop esi
  add esi, eax
  std
  rep movsb
  cld
  mov esi, ebx
  pop eax
  NEXT

cas:				; ( a old new -- f )
  mov ecx, eax			; new
  pop eax			; old
  pop ebx			; addr
  lock cmpxchg [ebx], ecx
  je true
  xor eax, eax
  pause
  NEXT


  align 4

_end:


;;; dictionary

%assign LAST 0

%macro MENTRY 3
%%link: dd LAST
  %define LAST %%link
  db %3
  db %1
  align 4
m_%2:
  dd %2
%endm

%macro CENTRY 3
%%link: dd LAST
  %define LAST %%link
  db %3
  db %1
  align 4
%2:
  dd colon
%endm

%macro CIENTRY 3
%%link: dd LAST
  %define LAST %%link
  db %3 | 0x80
  db %1
  align 4
%2:
  dd colon
%endm

%macro MVENTRY 4
%%link: dd LAST
  %define LAST %%link
  db %4
  db %1
  align 4
v_%2:
  dd constant
  dd %3
%endm

%macro VENTRY 3
%%link: dd LAST
  %define LAST %%link
  db %3
  db %1
  align 4
%2:
  dd variable
  dd 0
%endm


; fill page (nasm's ORG can't be used multiple times)

times 0x1000 - ($ - $$) db 0


%include "primitives.s"
%include "words-nasm.s"


  align 4

htop: dd heap
dtop: dd LAST
heapend: dd heaptop


  align 4

tibuffer: resb 1024
wordbuffer: resb 256
heap: resb HEAP_SIZE
heaptop: 
rstack: resb RSTACK_SIZE
sstack: resb SSTACK_SIZE
sstack_end:
