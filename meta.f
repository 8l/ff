\ meta-compiler
\
\ Compiles core.f into a new binary.
\
\ Note that this must run with only the base words in the bootstrapping binary
\ so deferred words and other handy things are not available.


\ endian-neutral operations

\ big endian

: be-h,  ( n -- ) dup 8 rshift c, 255 and c, ;

: be@  ( a -- x ) dup c@ 24 lshift over 1+ c@ 16 lshift or over 2 + c@ 
  8 lshift or swap 3 + c@ or ;

: be!  ( x a -- ) swap dup >r 24 rshift over c! r@ 16 rshift over 1+ c!
  r@ 8 rshift over 2 + c! r> swap 3 + c! ;

\ little endian

: le-h,  ( n -- ) dup 255 and c, 8 rshift c, ;

: le@  ( a -- x ) dup c@ over 1+ c@ 8 lshift or over 2 + c@ 16 lshift or
  swap 3 + c@ 24 lshift or ;

: le!  ( x a -- ) swap dup >r over c! r@ 8 rshift over 1+ c! r@ 16 rshift
  over 2 + c! r> 24 rshift swap 3 + c! ;

variable >h,  variable >t@  variable >t!
variable t-le

\ switch vectors, according to host- and target endianness

: host-endianness  ( -- le? ) 1 pad ! pad c@ ;

: target-endianness  ( target-le? -- )
  dup t-le !
  host-endianness over = if \ host and target are the same
    ['] @ >t@ ! ['] ! >t! !
  else dup if \ target le
    ['] le@ >t@ ! ['] le! >t! !
  else \ target be
    ['] be@ >t@ ! ['] be! >t! !
  then then
  if ['] le-h, >h, ! else ['] be-h, >h, ! then ;

: describe-endianness  ( -- )
    ." host is " host-endianness if ." little " else ." big " then
    ." endian" cr
    ." target is " t-le @ if ." little " else ." big " then
    ." endian" cr ;

\ default to host-system's endianness
host-endianness target-endianness

: t@  ( a -- x ) >t@ @ execute ;
: t!  ( x a -- ) >t! @ execute ;
: t,  ( x -- ) here t! 1 cells h +! ;
: h,  ( x -- ) >h, @ execute ;

variable mdp  \ meta dictionary-ptr                             
variable mdp0 \ initial mdp
variable mh   \ meta "here"                                     
variable mdictbase  \ base-address of constructed core-dict     
variable dictbase  \ base-address of original core-dict
variable hdictbase \ dictbase for host system
variable dictoffset  \ relocation offset (real - offset -> mdict)        
                                                                
100000 constant coredictspace
1024 constant tibsize
256 constant wordbufsize

\ code-addresses needed for creating headers
variable c:(variable)  variable c:(:)  variable c:(deferred)  variable c:(constant)

' (variable) @ c:(variable) !
' (constant) @ c:(constant) !
' (:) @ c:(:) !
' (deferred) @ c:(deferred) !


\ map xt in normal dictionary to primitive (for cross-compilation)
variable >map-primitive  ( xt -- xt' )

: noop ;
' noop >map-primitive !


\ initialize variables, from first def in core-dict             

: initmdp  ( a -- ) dup mdp0 ! mdp ! ;
                                                                
: initmeta  ( | <first> -- )                                    
  bl word findname drop 1 cells - dup hdictbase ! dictbase !                    
  dictbase @ @ initmdp
  here coredictspace allot dup mdictbase ! mh !                 
  mdictbase @ dictbase @ - dictoffset ! ;

initmeta false

: mhere  ( -- a ) mh @ ;                                        
: m,  ( n -- ) mhere t! 1 cells mh +! ;                          
: mallot  ( n -- ) mh +! ;                                      
: malign  ( -- ) mhere aligned mh ! ;                           
: primitive?  ( xt -- f ) hdictbase @ < ;

\ assumes "wordbuf" holds currently searched word           
: ?primitive  ( xt -- ) primitive? 0= if space              
        wordbuf @ count type true abort"  reference to non-primitive" 
    then ;

\ map to real primitive addr (if cross-compiling)
: pmap  ( xt -- xt' ) dup ?primitive >map-primitive @ execute ;
: [p']  ( | <word> -- xt ) ' literal ['] pmap , ; immediate   
: mreloc  ( a1 -- a2 ) dup mdp0 @ <> if dictoffset @ - then ;
: munreloc  ( a1 -- a2 ) dup mdp0 @ <> if dictoffset @ + then ; 
                                                                
: mcreate ( | <word> -- ) malign mhere >r mdp @ mreloc m, bl    
    word dup c@ mhere swap 1+ dup >r cmove r> mallot malign       
    c:(variable) @ m, r> mdp ! ;                                
                                                                
variable mfindadr                                               
                                                                
: mfindname  ( a1 -- a2 1 | a1 0 ) mfindadr ! mdp @ begin       
  dup cell+ count 63 and mfindadr @ count compare               
  0= if cell+ true exit then t@ munreloc dup mdp0 @ = until      
  drop mfindadr @ false ;                                       

: mfind  ( a -- a 0 | xt 1 | xt -1 ) mfindname if dup c@        
  swap over 63 and + 1+ aligned mreloc swap 128 and if 1 else   
  -1 then exit else false then ;                                

: mlookup  ( a -- xt ) mfind 0= if find 0= if space     
  count type true abort"  ?" then pmap then ;     
                                                                
: m'  ( <word> -- xt ) bl word mlookup ;
                                                                
: mimmediate  ( -- ) mdp @ cell+ dup c@ 128 or swap c! ;        

: mcompile  ( a -- )
    \ immediate in default dictionary?
    dup find dup 1 = if drop nip execute exit then
    \ non-immediate primitive?
    0< if
        dup primitive? if >map-primitive @ execute m, drop exit then
    then 
    \ normal word in meta-dictionary?
    drop mfindname if >cfa mreloc m, exit then
    count number 0= if space type true                                            
        abort"  ?" else [p'] (literal) m, m,
    then ;                    
                                                                
: m]  ( -- ) state on begin bl word                             
  dup c@ 0= if drop refill                
  else mcompile state @ then 0= until ;                         
                                                                
: m:  ( | <word> -- ) mcreate c:(:) @ mhere 1 cells - t! m] ;  
: m;  ( -- ) [p'] exit m, state off ;

: mliteral  ( -- n ) [p'] (literal) m, m, ;                      

: msliteral  ( | ..." -- a n ) [p'] (sliteral) m, [char] "       
  parse dup c@ 1+ >r mhere r@ cmove r> mallot malign ;          
                                                                
: m[char]  ( | <char> -- c ) bl word 1+ c@ mliteral ;           
: m[']  ( | <word> -- xt ) m' mliteral ;                        
: ms"  ( | ..." -- a n ) msliteral ;
: mvariable  ( | <word> -- ) mcreate 0 m, ;                     
: mconstant  ( n | <word> -- ) mcreate c:(constant) @ mhere 1 cells - t! m, ;
: mstring  ( c | ... -- ) word dup c@ 1+ >r mhere r@ cmove r> mallot ;
: mif  ( f -- ) [p'] (if) m, mhere 0 m, ;
: melse  ( -- ) [p'] (else) m, mhere >r 0 m, mhere mreloc swap t! r> ;
: mbegin  ( -- ) mhere ;                                        
: mthen  ( -- ) mhere mreloc swap t! ;                           
: magain  ( -- ) [p'] (else) m, mreloc m, ;                      
: muntil  ( f -- ) [p'] (if) m, mreloc m, ;                      
: mwhile  ( f -- ) [p'] (if) m, mhere 0 m, ;                     
: mrepeat  ( -- ) [p'] (else) m, swap mreloc m, mhere mreloc swap t! ;
: mdo  ( n1 n2 -- ) [p'] (do) m, 0 mhere ;                       
: mloop  ( -- ) [p'] (loop) m, mreloc m, ?dup if mhere mreloc swap t! then ;
: m+loop  ( n -- ) [p'] (+loop) m, mreloc m, ?dup if mhere mreloc swap t! then ;

\ convert to counted string
: >counted  ( a1 n -- a2 ) >r here 1+ r@ cmove r@ here c! here r> 1+ allot ;

: mvector,  ( a1 n a2 -- ) \ lookup in meta-dictionary and store vector
    dup @ ?dup 0= if
        >r >counted mlookup dup r> t! m,
    else
        m, 2drop drop
    then ;

variable mcrash

: mdefer  ( | <word> -- )
    mcreate c:(deferred) @ mhere 1 cells - t! s" crash" mcrash mvector, ;

: mis  ( | <name> -- xt )
    bl word mfind if
        cell+ mliteral 
        [p'] ! m,
    else
        space count type s" ?" type abort
    then ;

variable mesac

0 constant case immediate 
: mof  ( n -- ) [p'] over m, [p'] = m, mif [p'] drop m, ;
: mendcase ( x -- ) [p'] drop m, s" esac" mesac mvector, ;


\ output utils

variable mfile                                                  
                                                                
: write  ( a n -- ) mfile @ write-file ?fcheck ;                
