\ Non-native builtin words
\
\ Predefined:
\
\  @ ! c@ c! terminate clear reset h dp ; r@ r> >r i j + - * /mod
\  and or xor swap drop dup over = > < tib s@ lshift rshift rshifta
\  execute unloop exit cmove cmove> heaptop (literal) (sliteral) (:) (do)
\  (loop) (+loop) (does) (variable) (constant) fsread fswrite fsseek
\  fsopen fsclose (deferred) mmap


\ miscellaneous constants

0 constant false
-1 constant true
32 constant bl


\ system variables

variable s0
variable args
variable h0
variable dp0


\ some helper words

: on  ( a -- ) true swap ! ;
: off  ( a -- ) false swap ! ;
: >body  ( a1 -- a2 ) 4 + ;
: aligned  ( a1 -- a2 ) 3 + -4 and ;
: cells  ( n1 -- n2 ) 2 lshift ;
: cell+  ( a1 -- a2 ) 1 cells + ;


\ stack words

: depth  ( -- n ) s0 @ s@ - 2 rshift 1 - ;
: nip  ( x y -- y ) swap drop ;
: rot  ( x y z -- y z x ) >r swap r> swap ;
: 2drop  ( x y -- ) drop drop ;
: 2dup  ( x y -- x y x y ) over over ;
: 2nip  ( x y z -- z ) nip nip ;
: 2swap  ( x y z q -- z q x y ) rot >r rot r> ; 
: ?dup  ( x -- x | x x ) dup dup 0 = if drop then ;
: pick  ( ... n -- x ) ?dup if 1 + cells s@ + @ else dup then ;
: tuck  ( x y -- y x y ) dup >r swap r> ;


\ arithmetic

: /  ( n1 n2 -- n ) /mod nip ;
: +!  ( n a -- ) dup @ rot + swap ! ;
: invert  ( n1 -- n2 ) -1 xor ;
: mod  ( n1 n2 -- n ) /mod drop ;
: 1+  ( n1 -- n2 ) 1 + ;
: 1-  ( n1 -- n2 ) 1 - ;
: negate  ( n1 -- n2 ) 0 swap - ;
: 2*  ( n1 -- n2 ) 1 lshift ;
: 2/  ( n1 -- n2 ) 1 rshifta ;


\ comparison

: 0=  ( n -- f ) 0 = ;
: 0<  ( n -- f ) 0 < ;
: 0>  ( n -- f ) 0 > ;
: <>  ( x y -- f ) = invert ;
: 0<>  ( n -- f ) 0 <> ;
: max  ( n1 n2 -- n ) 2dup > if drop else nip then ;
: min  ( n1 n2 -- n ) 2dup < if drop else nip then ;
: signum  ( n1 -- n2 ) dup 0> if drop 1 else 0< if -1 else 0 
  then then ;
: within  ( n lo hi -- f ) >r over > 0= swap 1+ r> > 0= and ;
: abs  ( n1 -- n2 ) dup 0< if negate then ;


\ string operations

: count  ( a -- a n ) 1+ dup 1- c@ ;

\ count C-string
: ccount  ( a -- a n ) dup begin dup c@ 0<> while 1+ repeat over - ;

: compare  ( a1 n1 a2 n2 -- n ) 
  rot 2dup >r >r min 0 do over i + c@ over i + c@ - signum ?dup
  if 2nip unloop unloop exit then loop 2drop r> r> - signum ;

: erase  ( a n -- ) 0 do 0 over c! 1+ loop drop ;
: fill  ( a n c -- ) swap 0 do 2dup swap i + c! loop 2drop ;
: blank  ( a n -- ) bl fill ;

variable searchlen

: search  ( a1 n1 a2 n2 -- a3 n3 f ) 
  searchlen ! swap dup >r searchlen @ - 1+ 0 do over i + over 
  searchlen @ swap searchlen @ compare 0= if drop i + i unloop 
  r> swap - true exit then loop drop r> false ;


\ data area handling

: here  ( -- a ) h @ ;
: ,  ( n -- ) here ! 4 h +! ;
: c,  ( c -- ) here c! 1 h +! ;
: allot  ( n -- ) h +! ;
: pad  ( -- a ) here 256 + ;
: align  ( -- ) here aligned h ! ;
: unused  ( -- n ) heaptop @ here - ;


\ UTF-8 encoding/decoding

: utfenc  ( a c -- a-1 c>>6 ) dup >r 63 and 128 or over c! 1- r> 6 rshift ;

: utfencode  ( a c -- a n )
  dup 128 < if over c! 1 exit then
  dup 2048 < if swap 2 + swap utfenc 192 or over c! 2 exit then
  dup 65536 < if swap 3 + swap utfenc utfenc 224 or over c! 3 exit then
  swap 4 + swap utfenc utfenc utfenc 240 or over c! 4 ;

: utfdec  ( a c -- a+1 c2 ) 6 lshift swap 1+ dup c@ 63 and rot or ;

: utfdecode  ( a1 -- a2 c )
  dup c@ dup 128 and if
    dup 32 and if
      dup 16 and if
        7 and utfdec utfdec utfdec
      else
        15 and utfdec utfdec
      then
    else
      31 and utfdec
    then
  then
  swap 1+ swap ;


\ basic I/O

variable iobuf
variable stdin  variable stdout
variable eof

: key  ( -- c ) iobuf @ 1 stdin @ fsread 0= if eof on -1 else iobuf @ c@ then ;
: type  ( a n -- ) stdout @ fswrite drop ;
: emit  ( c -- ) iobuf @ swap utfencode type ;
: cr  ( -- ) 10 emit ;
: space  ( -- ) bl emit ;
: emits  ( c n -- ) begin ?dup while over emit 1- repeat drop ;
: spaces  ( n -- ) bl swap emits ;
: page  ( -- ) 12 emit ;


\ pictured number output

variable base
variable >num

: <#  ( -- ) pad 1024 + >num ! ;

: #  ( u1 -- u2 ) base @ u/mod swap dup 9 > if [char] a + 10 - 
  else [char] 0 + then >num @ 1- dup >num ! c! ;

: #s  ( u1 -- n2 ) begin # dup while repeat ;
: #>  ( u1 -- a n ) drop >num @ dup pad 1024 + swap - ;
: hold  ( c -- ) >num @ 1- dup >r c! r> >num ! ;
: sign  ( n -- ) 0< if [char] - hold then ;
: u.  ( u -- ) <# #s #> type space ;
: (.)  ( n1 -- a n2 ) dup abs <# #s swap sign #> ;
: .  ( n -- ) (.) type space ;
: u.r  ( n1 n2 -- ) >r <# #s #> r> over - 0 max spaces type ;
: .r  ( n1 n2 -- ) >r dup abs <# #s swap sign #> r> over - 0 
  max spaces type ;


\ numeric parsing

: hex  ( -- ) 16 base ! ;
: decimal  ( -- ) 10 base ! ;

: digit  ( c -- n -1 | 0 )
  dup [char] A [char] [ within if 55 - else  \ 'Z' + 1
  dup [char] a [char] { within if 87 - else  \ 'z' + 1
  dup [char] 0 [char] : within if 48 - else drop false exit  \ '9' + 1
  then then then dup base @ < if true else drop false then ;

: number  ( a n1 -- n2 -1 | a n1 0 )
  swap dup c@ [char] - = if 1+ swap 1- -1 >r else swap 1 >r 
  then dup >r 0 swap 0 do base @ * over i + c@ digit if + else 
  drop unloop r> r> drop false exit then loop r> drop nip r> * 
  true ;


\ some deferred words - positioned here, so that meta-compile doesn't use
\ the following definition of "defer". We also need a version of "crash",
\ meta-compilation of "defer" needs to see a definition:
: crash ;

defer abort
defer prompt
defer startup
defer findname


\ interpretation

variable >in        variable >limit
variable wordbuf    variable findadr
variable sourcebuf  variable blk

: source  ( -- a ) sourcebuf @ ; \ note: different from ANS
: current-input  ( -- c ) >in @ source + c@ ;

: save-input  ( -- x y z u 4 ) stdin @ >in @ >limit @ sourcebuf 
  @ blk @ 5 ;

: default-input  ( -- ) stdin off >in off >limit off tib 
  sourcebuf ! blk off ;

: restore-input ( <input> -- f ) eof off 5 <> if default-input 
  false else blk ! sourcebuf ! >limit ! >in ! stdin ! true then ;

: ?restore-input  ( <input> -- ) restore-input 0= if space 
  s" unable to restore input" type cr abort then ;

: next-input  ( -- -1 c | 0 0 ) >in @ >limit @ < if true 
  current-input else 0 false then ;

: parse  ( c | ... -- a ) \ note: different from ANS
  >r wordbuf @ 1+ begin next-input r@ <> and while 
  current-input over c! 1+ 1 >in +! repeat 1 >in +! r> drop 
  wordbuf @ dup >r - 1- r@ c! r> ;  

: word  ( c | ... -- a )
  >r begin next-input r@ = and while 1 >in +! repeat r> parse ;

: accept  ( a n1 -- n2 ) swap dup >r >r begin ?dup while key
  dup 10 = over -1 = or if 2drop r> r> - exit then r@ c! r> 1+ >r 
  1- repeat r> r> - ;

: query  ( -- ) eof off tib 1024 accept dup 0= eof @ and if 
  drop ?restore-input else >limit ! >in off then ;

: refill  ( -- f )  \ only works for console/file-input
  blk @ if false else query true then ;

defer findname

: findnfa  ( a1 dp -- a2 1 | a1 0 )
  swap findadr ! begin ?dup while dup cell+ c@ 64 and if @ else
  dup cell+ count 63 and findadr @ count compare 0= if cell+ 
  true exit then @ then repeat findadr @ false ;

\ initial "findname" (w/o vocabulary support)
: (findname)  ( a1 -- a2 1 | a1 0 ) dp @ findnfa ;

: find  ( a -- a 0 | xt 1 | xt -1 )
  findname if dup c@ swap over 63 and + 1+ aligned swap 128 and 
  if 1 else -1 then exit else false then ;

: '  ( | <name> -- xt ) bl word find 0= if space count type 
  s"  ?" type cr abort then ;

: ?stack  ( ... -- ... ) 
  s@ s0 @ > if s"  stack underflow" type cr abort then ;

: interpret  ( -- )
  begin bl word dup c@ 0<> while find if execute ?stack else 
  count number 0= if space type s"  ?" type cr abort then then 
  repeat drop ;


\ defining words

variable current

: create  ( | <name> -- ) 
  align here >r current @ @ , bl word dup c@ here 
  swap 1+ dup >r cmove r> allot align ['] (variable) @ , r>
  current @ ! ;

: variable  ( | <name> -- ) create 0 , ;
: constant  ( x | <name> -- ) create ['] (constant) @ here 1 
  cells - ! , ;


\ compiler

variable state

: immediate  ( -- ) current @ @ cell+ dup c@ 128 or swap c! ;
: >cfa  ( a1 -- a2 ) count 63 and + aligned ;

: compile  ( a -- )
  findname if dup c@ 128 and if >cfa execute ?stack
  else >cfa , then else count number 0= if space type 
  s"  ?" type cr abort else ['] (literal) , , then then ;

: ]  ( -- )
  state on begin bl word dup c@ 0= if drop refill else compile 
  state @ then while repeat ;

: [  ( -- ) state off ; immediate


\ colon word definition

: smudge  ( -- ) current @ @ cell+ dup c@ 64 or swap c! ;
: reveal  ( -- ) current @ @ cell+ dup c@ 64 invert and swap c! ;
: :  ( | <name> ... -- ) create smudge ['] (:) @ here 1 cells - ! ] ;
: ;  ( -- ) ['] exit , state off reveal ; immediate
: recurse  ( -- ) current @ @ cell+ >cfa , ; immediate


\ literals

: char  ( | <char> -- c ) bl word 1+ utfdecode nip ;
: literal  ( -- n ) ['] (literal) , , ;

: sliteral  ( | ... " -- a n ) ['] (sliteral) , here [char] " 
  parse dup c@ 1+ >r swap r@ cmove r> allot align ;  

: string  ( c | ... -- ) word dup c@ 1+ >r here r@ cmove r> 
  allot ;


\ some immediate words

: [char]  ( | <char> -- c ) char literal ; immediate
: [']  ( | <name> -- cfa ) ' literal ; immediate
: (  ( | ... <paren> -- ) [char] ) parse drop ; immediate

\ round >in upwards to 64 bytes if reading from block
: \  ( | <line> -- ) blk @ if >in @ 63 + 63 invert and 
  >in ! else >limit @ >in ! then ; immediate

: (?abort)  ( f a n -- ) rot if space type cr abort else 2drop 
  then ;

: abort"  ( f | ... " -- ) sliteral ['] (?abort) , ; immediate

\ string words

: "  ( | ..." -- a n ) [char] " word count >r here r@ cmove 
  here r> dup allot ;

: c"  ( | ..." -- a ) [char] " word dup c@ 1+ >r here r@
  cmove here r> allot ;

: s"  ( | ..." -- a n ) sliteral ; immediate
: ."  ( | ..." -- ) sliteral ['] type , ; immediate


\ control structures

: if  ( f -- ) ['] (if) , here 0 , ; immediate

: else  ( -- ) ['] (else) , here >r 0 , here swap ! r> ; immediate

: then  ( -- ) here swap ! ; immediate

: begin  ( -- ) here ; immediate
: again  ( -- ) ['] (else) , , ; immediate
: until  ( f -- ) ['] (if) , , ; immediate
: while  ( f -- ) ['] (if) , here 0 , ; immediate
: repeat  ( -- ) ['] (else) , swap , here swap ! ; immediate

: do  ( n1 n2 -- ) ['] (do) , 0 here ; immediate

: ?do  ( n1 n2 -- ) ['] over , ['] over , ['] = , ['] (if) ,
    here 0 , ['] drop dup , , ['] (else) , here 0 , here rot ! 
    ['] (do) , here ; immediate

: loop  ( -- ) ['] (loop) , , ?dup if here swap ! then ; immediate

: +loop  ( n -- ) ['] (+loop) , , ?dup if here swap ! 
  then ; immediate


\ file I/O

1 512 or 64 or constant w/o  \ O_WRONLY | O_TRUNC | O_CREAT
0 constant r/o  \ O_RDONLY
2 constant r/w  \ O_RDWR

: open-file  ( a n fam -- fd ior ) >r pad 1024 + swap dup >r 
  cmove 0 r> pad + 1024 + c! pad 1024 + r> 420 ( 0644 ) fsopen 
  dup -1 > ;

: close-file  ( fd -- ior ) fsclose 0= ;
: read-file  ( a n fd -- n2 ior ) fsread dup -1 <> ;
: write-file  ( a n fd -- ior ) fswrite -1 <> ;
: reposition-file  ( n fd -- ior ) fsseek -1 <> ;

: ?fcheck  ( f -- ) 0= if space s" I/O error" type cr abort then ;


\ termination

: bye  ( -- ) 0 halt ;


\ file interpretation

: included  ( a n -- ) 
    >limit @ >in ! r/o open-file ?fcheck >r save-input r@
    stdin @ >r stdin ! begin query interpret stdin @ r@ = until
    r> drop r> close-file ?fcheck ;

: include  ( | <fname> -- ) bl word count included ;


\ deferred words

: crash  ( -- ) s" uninitialized execution vector" type cr abort ;

: defer  ( | <name> -- ) create ['] (deferred) @ here 1 cells - 
  ! ['] crash , ;

: is  ( | <name> -- xt ) bl word find if cell+ literal 
  ['] ! , else space count type s" ?" type abort then ; 
  immediate


\ <builds + does>

: <builds  ( | <word> -- ) create ['] (does) @ here 1 cells - ! 0 , ;
: does>  ( -- a ) r> current @ @ cell+ >cfa cell+ ! ;


\ image loading/saving

: (startup)  ( -- ) prompt abort ;

: save-image  ( | <fname> -- ) bl word count w/o open-file ?fcheck 
    >r s" #!/usr/bin/env ff" pad swap cmove 10 pad 17 + c!
    here ['] false - dup pad 20 + !
    pad 1 cells 20 + r@ write-file ?fcheck
    ['] false swap r@ write-file ?fcheck 
    r> close-file ?fcheck ;

: bload  ( | a n -- )
    args @ >r \ save 
    r/o open-file ?fcheck
    >r pad 20 cell+ r@ read-file ?fcheck drop
    ['] false pad 20 + @ r@ read-file ?fcheck drop
    r> close-file ?fcheck
    r> args ! \ restore
    clear startup bye ;

: load-image  ( | <fname> -- ) bl word count bload ;


\ startup code

: (prompt)  ( -- ) s"  ok" type cr ;

: quit  ( ... -- ) reset clear
    begin query interpret stdin @ 0= if prompt then again ;

: cold  ( -- ) 
    h0 @ h ! dp0 @ dp !
    reset clear state off decimal
    args @ dup @ 1 > if 2 cells + @ ccount bload else quit then ;

: (abort)  ( ... -- ) state off tib sourcebuf ! blk off 
    stdin off 1 stdout ! quit ;

: boot
    reset clear s@ s0 !
    heaptop @ 1 cells - @ args !
    ['] (abort) is abort
    tib 1024 + wordbuf !
    tib 1020 + iobuf !
    tib sourcebuf !
    here h0 ! dp @ dp0 ! dp current !
    0 stdin ! 1 stdout !
    ['] (startup) is startup
    ['] (prompt) is prompt
    ['] (findname) is findname
    cold ;
