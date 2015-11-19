\ Plan9 a.out generation


\ Steps to build a.out binary:
\
\ 1. compute .data size (pdict + dict)
\ 2. generate a.out header
\ 3. copy .text
\ 4. copy .data (only primitives) 
\ 5. fixup "h", "dp", "heaptop" and "tib" in copied primitive-dictionary
\ 6. copy generated dictionary
\ 7. write-out completed executable


\ image addresses

variable textbase   variable textsize   variable textaddr
variable pdictbase  variable pdictsize  variable pdictaddr
variable stackbase  variable theaptop

_start textbase !
_end _start - textsize !
c" @" findname drop 1 cells - pdictbase !
dictbase @ pdictbase @ - pdictsize !
s0 @ stackbase !

textbase @ textaddr ! \ identical, unless cross-compiling
pdictbase @ pdictaddr ! \ same here
heaptop @ theaptop !

variable datasize     variable imgbase    variable bsssize

4096 constant pagesize

: calc-datasize  ( -- )
    malign mhere mdictbase @ - pdictsize @ + datasize ! ;

: calc-sizes  ( -- )
    calc-datasize
    here imgbase !                      \  where image is generated
    stackbase @ mhere mreloc - bsssize ! ;

: dump-sizes  ( -- )
    ."  text section size:       " textsize @ . cr
    ."  data section size:       " datasize @ . cr
    ."  bss section size:        " bsssize @ . cr ;

\ Big-endian comma
: big,  ( n -- )
  dup 24 rshift c, dup 16 rshift 255 and c, dup 8 rshift 255 and c, 
  255 and c, ;  

hex 
000001eb constant a.out-magic-i386
1020 constant a.out-entry-point-i386
decimal

: gen-a.out-header  ( entrypoint -- )
  a.out-magic-i386 big,
  textsize @ big, datasize @ big, bsssize @ big,
  0 , big, 0 , 0 ,  ;   \ syms, entry, spsz, pcsz
        
: copy-bytes  ( a n -- )  >r here r@ cmove r> allot ;
: copy-text  ( -- )  textbase @ textsize @ copy-bytes ;
: copy-pdict  ( -- a )  here >r pdictbase @ pdictsize @ copy-bytes r> ;
: copy-dict  ( -- )  mdictbase @ mhere mdictbase @ - copy-bytes ;

\ location in generated core-dict for system-variable values
4 constant #sysvars   variable sysvars

: valoffset  ( xt -- offset ) pmap pdictaddr @ - cell+ ;

: fixup-const  ( pdict val xt -- ) over . cr valoffset rot + ! ;

: fixup  ( pdict xt index -- )
    cells sysvars @ + mreloc swap ( pdict sysvaraddr xt ) fixup-const ;

: fixup-vars  ( pdict -- )
    mhere mreloc sysvars @ !                         \ h
    mdp @ mreloc sysvars @ cell+ !                   \ dp
    theaptop @ sysvars @ 2 cells + !                 \ heaptop
    hex
    ."   h:       " dup ['] h 0 fixup
    ."   dp:      " dup ['] dp 1 fixup
    ."   heaptop: " dup ['] heaptop 2 fixup
    ."   tib:     " dup ['] tib 3 fixup
    ."   _start:  " dup textaddr @ ['] _start fixup-const
    ."   _end:    " textaddr @ textsize @ + ['] _end fixup-const 
    decimal ;

: unexec ( | <fname> -- )
    bl word count w/o open-file ?fcheck >r
    imgbase @ dup here swap - r@ write-file ?fcheck
    r> close-file ?fcheck ;

: .offset ( -- ) here imgbase @ - . ;

\ invoke after metacompilation
: msave  ( <fname> -- )
    describe-endianness
    ." calculating sizes" cr
    mhere sysvars ! #sysvars cells mallot  \ h, dp, heaptop, tib, _start, _end
    tibsize wordbufsize + mallot           \ tib + wordbuf
    calc-sizes dump-sizes
    ." generating a.out header" cr
    a.out-entry-point-i386 gen-a.out-header
    ." generating .text section" cr
    copy-text
    ." generating .data section" cr
    ."  generating primitive dictionary" cr
    copy-pdict
    ."  fixing up system variables" cr
    fixup-vars
    ."  copying core dictionary" cr
    copy-dict
    ." saving image" cr
    unexec
    ." done" cr ;
