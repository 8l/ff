\ ELF generation


3 constant i386-machine         40 constant arm-machine
2 constant sparc-machine

16 constant i386-codealign      4 constant arm-codealign
8 constant sparc-codealign

hex 
1000 constant i386-align        8000 constant arm-align
10000 constant sparc-align

0 constant i386-flags           5000002 constant arm-flags
0 constant sparc-flags

decimal

6 constant AX     3 constant WA
5 constant RE     6 constant RW

1 constant LOAD     1 constant PROGBITS
8 constant NOBITS   3 constant STRTAB

1 constant LSB    2 constant MSB

: elf-header  ( flags shoff entrypoint machine data -- )
    [ hex ] 7f c, 45 c, 4c c, 46 c, [ decimal ] \ magic
    1 c, c, 1 c, 0 c, 0 c, 7 allot 2 h, \ elf32, data, Sys V, abiv, padding, EXEC
    h, 1 t, t, 52 t, t, t, 52 h, \ machine, version, entry, phoff, shoff, flags, ehsize
    32 h, 2 h, 40 h, 5 h, 4 h, ; \ phentsize, phnum, shentsize, shnum, shstrndr

: prg-header  ( align flags msize fsize addr offset -- )
    LOAD t, t, dup t, t, t, t, t, t, ; \ LOAD, offset, vaddr/paddr, fsize, msize, flags, align

: section  ( addralign size offset addr flags type name -- )
    t, t, t, t, t, t, 0 , 0 , \ name, type, flags, addr, offset, size, link, info
    t, 0 , ; \ addralign, entsize

create str-table
0 c, " .shstrtab" 2drop 0 c,
" .text" 2drop 0 c,
" .data" 2drop 0 c,
" .bss" 2drop 0 c, 0 c, align

here str-table - constant strtablesize

: i386  ( -- align codeaddralign flags machine data )
    i386-align i386-codealign i386-flags i386-machine LSB ;

: arm  ( -- align codeaddralign flags machine data )
    arm-align arm-codealign arm-flags arm-machine LSB ;

: sparc  ( -- align codeaddralign flags machine data )
  sparc-align sparc-codealign sparc-flags sparc-machine MSB ;


\ Steps to build ELF binary:
\
\ 1. compute .data size (pdict + dict)
\ 2. generate elf- and program headers
\ 3. copy .text
\ 4. pad with data-segment adjustment, if need
\ 5. copy .data (only primitives) 
\ 6. fixup "h", "dp", "heaptop" and "tib" in copied primitive-dictionary
\ 7. copy generated dictionary
\ 8. copy string-table
\ 9. generate section-table
\ 10. write-out completed executable

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

variable datasize     variable imgbase
variable baseoffset   variable bsssize

\ data segment offset + address need to be "congruent modulo 4k"
variable segadjust

: calc-adjust  ( -- )
    pdictaddr @ textaddr @ - textsize @ - 4095 and segadjust ! ;

: calc-datasize  ( -- )
    malign mhere mdictbase @ - pdictsize @ + datasize ! ;

: calc-sizes  ( -- )
    calc-adjust calc-datasize
    here imgbase !                      \  where image is generated
    stackbase @ mhere mreloc - bsssize ! ;

: dump-sizes  ( -- )
    ."  text section size:       " textsize @ . cr
    ."  data segment adjustment: " segadjust @ . cr
    ."  data section size:       " datasize @ . cr
    ."  bss section size:        " bsssize @ . cr ;

: gen-elf-header  ( codeaddralign flags machine data -- )
    >r >r >r 1-
    52 32 2* + over + swap invert and \ shoff: elfhdr + 2 prghdrs, aligned +
    dup baseoffset !                  \ ...
    textsize @ + segadjust @ + datasize @ + \ text + segadjust + data +
    strtablesize +                        \ strtable,
    r> swap
    textaddr @                            \ entry-point
    r> r>                               \ machine, data
    elf-header ;

: gen-prg-headers  ( align -- )
    dup RE textsize @ baseoffset @ + dup \ align, flags, msize, fsize
    textaddr @ baseoffset @ - 0            \ addr, offset
    prg-header
    RW datasize @ bsssize @ +                    \ align, flags, msize
    datasize @ pdictaddr @                         \ fsize, addr
    textsize @ segadjust @ + baseoffset @ +        \ offset
    prg-header ;

: copy-bytes  ( a n -- )  >r here r@ cmove r> allot ;
: copy-text  ( -- )  textbase @ textsize @ copy-bytes ;
: copy-pdict  ( -- a )  here >r pdictbase @ pdictsize @ copy-bytes r> ;
: copy-dict  ( -- )  mdictbase @ mhere mdictbase @ - copy-bytes ;
: copy-strtable  ( -- ) str-table strtablesize copy-bytes ;

\ location in generated core-dict for system-variable values
4 constant #sysvars   variable sysvars

: valoffset  ( xt -- offset ) pmap pdictaddr @ - cell+ ;

: fixup-const  ( pdict val xt -- ) over . cr valoffset rot + t! ;

: fixup  ( pdict xt index -- )
    cells sysvars @ + mreloc swap ( pdict sysvaraddr xt ) fixup-const ;

: fixup-vars  ( pdict -- )
    mhere mreloc sysvars @ t!                         \ h
    mdp @ mreloc sysvars @ cell+ t!                   \ dp
    theaptop @ sysvars @ 2 cells + t!                 \ heaptop
    hex
    ."   h:       " dup ['] h 0 fixup
    ."   dp:      " dup ['] dp 1 fixup
    ."   heaptop: " dup ['] heaptop 2 fixup
    ."   tib:     " dup ['] tib 3 fixup
    ."   _start:  " dup textaddr @ ['] _start fixup-const
    ."   _end:    " textaddr @ textsize @ + ['] _end fixup-const 
    decimal ;

: gen-sect-headers  ( codeaddralign -- )
    0 0 0 0 0 0 0 section               \ null section
    dup textsize @ baseoffset @ textaddr @ AX PROGBITS 11 section \ .text
    datasize @                                        \ .data
    textsize @ segadjust @ + baseoffset @ + dup >r        \ save data-seg offset
    pdictaddr @ WA PROGBITS 17 section
    4 bsssize @ datasize @ r> + dup >r
    pdictaddr @ datasize @ + WA NOBITS 23 section \ .bss
    1 28 r> 0 0 STRTAB 1 section ; \ .shstrtab

: unexec ( | <fname> -- )
    bl word count w/o open-file ?fcheck >r
    imgbase @ dup here swap - r@ write-file ?fcheck
    r> close-file ?fcheck ;

: .offset ( -- ) here imgbase @ - . ;

\ invoke after metacompilation
: msave  ( <machinespec> | <fname> -- )
    describe-endianness
    ." calculating sizes" cr
    mhere sysvars ! #sysvars cells mallot      \ h, dp, heaptop, tib, _start, _end
    tibsize wordbufsize + mallot        \ tib + wordbuf
    calc-sizes dump-sizes
    3 pick >r   \  save addralign
    ." generating ELF header" cr
    gen-elf-header
    ." generating program headers" cr
    gen-prg-headers
    ." generating .text section" cr
    baseoffset @ here imgbase @ - - allot \ align to baseoffset
    copy-text
    ." generating .data section" cr
    ."  generating primitive dictionary" cr
    segadjust @ allot
    copy-pdict
    ."  fixing up system variables" cr
    fixup-vars
    ."  copying core dictionary" cr
    copy-dict
    ." generating string table" cr
    copy-strtable
    ." generating section headers" cr
    r> gen-sect-headers
    ." saving image" cr
    unexec
    ." done" cr ;
