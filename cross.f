\ utilities for cross-compilation


\ compile dictionary entries for primitives (either colon words or
\ constants):

variable pddp  pddp off

\ adjust real address to address in image and back
: preloc  ( a1 -- a2 ) dup if pdictbase @ - pdictaddr @ + then ;
: punreloc  ( a1 -- a2 ) dup if pdictaddr @ - pdictbase @ + then ;

: pcreate  ( | <word> -- )
  here >r pddp @ preloc t, bl word dup c@ 1+ here swap dup >r 
  cmove r> allot align r> pddp ! ;

: pnative  ( a | <word> -- )  pcreate t, ;
: pconstant  ( x | <word> -- )  pcreate c:(constant) @ t, t, ;

variable plastprim   variable lastprim

\ find cfa in manually created pdict that corresponds to host-cfa
: xmap  ( xt -- xt' )
    >r plastprim @ lastprim @ begin
        ?dup while
            dup cell+ >cfa r@ = if
                r> 2drop cell+ >cfa preloc exit 
            then
            swap t@ punreloc swap @
    repeat true abort" unmapped primitive" ;

\ obtain ptr to last primitive in host dictionary
: setlastprim findname 0= abort" can not find (deferred)" 1 cells - lastprim ! ;
c" (deferred)" setlastprim  \ c" only works in interpreted mode

' xmap >map-primitive !

\ read .text section from file
: load.text  ( a n offset | fname -- )
    bl word count r/o open-file ?fcheck >r
    here swap r@ read-file ?fcheck drop \ skip header
    over textbase !
    r@ read-file ?fcheck drop
    r> close-file ?fcheck ;
