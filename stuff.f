\ Utilities


\ Fundamental utilities                                         
                                                                
: @+  ( a1 -- a2 n ) dup cell+ swap @ ;                         
: !+  ( a1 x -- a2 ) over ! cell+ ;                             
: noop ;                                                        
: perform  ( ... a -- ... ) @ execute ;                         
: under+  ( n1 x n2 -- n3 x ) rot + swap ;                      
: th  ( a1 n -- a2 ) cells + ;                                  
: bounds  ( a1 n -- a2 a1 ) over + swap ;                       
: ?exit  ( f -- ) if r> drop exit then ;


\ Some more double words

: 2@  ( a -- x y ) dup @ swap cell+ @ ;
: 2!  ( x y a -- ) rot over ! cell+ ! ;
: 2>r  ( x y -- ) r> swap >r swap >r >r ;
: 2r>  ( -- x y ) r> r> r> rot >r ;


\ Compiling words

: postpone  ( | <word> -- ) bl word find dup 0= if drop space        
  count type true abort" ?" then 1 = if , else literal ['] ,    
  , then ; immediate                                            
                 

\ Definitions
                                               
: :noname  ( ... -- xt ) here ['] (:) @ , ] ;                   


\ String utilities                                              
                                                                
: /string  ( a1 n1 n2 -- a2 n3 ) dup >r under+ r> - ;           
                                                                
: buffer:  ( n | <word> -- ) create allot ;                     
                                                                
: -trailing  ( a n1 -- a n2 ) begin 1- dup 0< if 1+ exit then   
  2dup + c@ bl <> until 1+ ;                                    
                                                                
: scan  ( a1 n1 c -- a2 n2 ) >r begin dup 0= if r> drop
  exit then over c@ r@ <> while 1 /string repeat r> drop ;      
                                                                
: skip  ( a1 n1 c -- a2 n2 ) >r begin dup 0= if r> drop         
  exit then over c@ r@ = while 1 /string repeat r> drop ;       
                                                                
: split  ( a1 n1 c -- a2 n2 a1 n3 ) >r 2dup r> scan 2swap       
  2 pick - ;                                                    
                                                                
: place  ( a1 n a2 -- ) 2dup >r >r 1+ swap cmove r> r> c! ;     

: string,  ( a n -- ) here over 1+ allot place ;
: ,"  ( | ..." -- ) [char] " parse count string, ;


\ Random numbers                                                
                                                                
variable seed                                                    
here seed !  \ sucks
                                                                
: random  ( -- n ) seed @ 3141592621 *  1+ dup seed ! ;           


\ Display tools                                                 
                                                                
: .s  ( ... -- ... ) depth ?dup 0= if
        ." stack empty "
    else
        dup 0 do dup i -  pick . loop drop
    then ;
                                                                
: ?  ( a -- ) @ . ;                                             
                                                                
: dump  ( a n -- ) base @ >r hex 0 do i 16 mod 0= if cr         
  dup i + 8 u.r space then dup i + c@ dup 16 < if [char] 0 emit then      
  . loop drop cr r> base ! ;                                    
                                                                
: .(  [char] ) parse count type ; immediate                     
                                                                

\ case-of - http://www.calcentral.com/~forth/forth/eforth/e4.src/LIB.SHTML

0 constant case ( -- 0 ) immediate

: of ( -- sys )
  postpone over postpone = postpone if postpone drop ; immediate

: endof ( sys -- sys ) postpone else ; immediate
: esac ( 0 i*sys -- ) begin ?dup while postpone then  repeat ; immediate
: endcase ( 0 i*sys -- ) postpone drop postpone esac ; immediate


\ Command invocation from frontend

defer command  ( | <word> -- )
defer previous-screen
defer next-screen


\ Vocabularies

8 constant maxvocs

maxvocs cells buffer: vocs
variable >vocs
vocs maxvocs cells + constant voctop
here ," forth" align create forthwords 0 , ,

: context  ( -- a ) >vocs @ ;
: vocabulary  ( | <name> -- ) here <builds cell+ 0 , , does> context ! ;

: words  ( -- ) 
    context @ @ begin 
        ?dup while dup cell+ count 63        
        and type space @ 
    repeat ;                                     

: dp  ( -- a ) forthwords ;     \ reimplemented
: only  ( -- ) voctop 1 cells - dup >vocs ! forthwords swap ! ;

: order  ( -- )
    voctop context do
        i @ dup cell+ @ count type
        current @ = if [char] * emit then
        space
    1 cells +loop ;

: also  ( -- )
    context dup vocs = abort" too many wordlists" 
    dup @ >r 1 cells - >vocs ! r> context ! ;

: previous  ( -- ) context cell+ dup voctop < if >vocs ! else drop then ;
: definitions  ( -- ) context @ current ! ;

: vfindname  ( a1 -- a2 1 | a1 0 )
    context begin
        dup voctop <> while
        dup >r @ @ findnfa if r> drop true exit then
        r> cell+
    repeat drop false ;

: forget  ( | <word> -- ) 
    bl word current @ findnfa if 
        1 cells - dup @ current @ ! h ! 
    else 
        space count type true abort" ?" 
    then ;    

: vocs,  ( -- )
    context voctop over - 2/ 2/ dup , 0 do
        dup i cells + @ dup , @ ,
    loop drop current @ dup , @ , ;

: vocs@  ( a1 -- a2 )
    @+ dup >r cells voctop swap - >vocs !
    r> 0 do
        @+ context i cells + dup >r ! @+ r> @ !
    loop @+ current ! @+ current @ ! ;

: marker  ( | <word> -- )
    <builds vocs, here cell+ ,   \ skip this actual cell
    does> vocs@ @ h ! ;

: forth  ( -- ) forthwords context ! ;

\ fixup "forth" vocabulary and initialize
:noname 
    forthwords cell+ @ (findname) drop 1 cells - forthwords ! 
    ['] vfindname is findname
    forthwords current ! only ; execute


\ A very simple decompiler

: (rfind)  ( cfa dp -- a|0 )
    begin ?dup while
        dup >r cell+ >cfa over = if
            r> cell+ nip exit
        else r> @ then
    repeat drop false ;

variable rfindcfa
: rfind  ( cfa -- a|0 )
    rfindcfa ! context begin
        dup voctop <> while
        >r rfindcfa @ r@ @ @ (rfind) ?dup if r> drop exit then
        r> cell+
    repeat drop false ;

: ?rfind  ( cfa -- a )
    dup rfind ?dup if nip else
        ."  cfa not found: " . cr true abort
    then ;

256 constant maxfwdjmps
maxfwdjmps cells buffer: fwdjmps
variable #fwdjmps

: recbranch  ( a ba -- a )
    2dup < if 
        fwdjmps #fwdjmps @ dup maxfwdjmps > abort" too many forward branches"
        th ! 1 #fwdjmps +!
    else drop then ;

: nofwdjmps?  ( a -- f )
    #fwdjmps @ 0 ?do fwdjmps i th @ over > if drop false unloop exit
    then loop drop true ;

: .name  ( a -- ) count 63 and type ;

: see-op  ( a1 -- a2 f )
    dup 8 .r space dup @ dup rfind dup 0= if
        drop ." ??? " . false
    else 
        .name space case
            ['] exit of dup nofwdjmps? endof
            ['] (if) of cell+ dup @ dup . recbranch false endof
            ['] (else) of cell+ dup @ dup . recbranch false endof
            ['] (loop) of cell+ dup @ . false endof \ assumes branch backwards
            ['] (+loop) of cell+ dup @ . false endof \ assumes branch backwards
            ['] (literal) of cell+ dup @ decimal . hex false endof
            ['] (sliteral) of cell+ [char] " emit count 2dup type [char] " emit 
                + aligned 1 cells - false endof
            false swap
        endcase
    then cr 1 cells under+ ;

: see-code  ( addr -- ) #fwdjmps off begin see-op until drop ;
: see-(:)  ( cfa -- ) ?rfind ." : " dup .name cr >cfa cell+ see-code ;

: see-(variable)  ( cfa -- ) 
    ?rfind ." variable " dup .name space >cfa dup [char] @ emit . ." = " 
    cell+ @ decimal . hex cr ;

: see-(constant)  ( cfa -- ) 
    ?rfind ." constant " dup .name ."  = " >cfa cell+ @ 
    decimal . hex cr ;

: see-(does)  ( cfa -- )
    ?rfind ." does> " dup .name space >cfa cell+ dup @ swap [char] @ emit 
    . cr see-code ;

: see-(deferred)  ( cfa -- )
    ?rfind ." defer " dup .name ."  = " >cfa cell+ @ dup rfind ?dup if
        .name drop
    else 
        ." ??? " . 
    then cr ;

' (:) @        constant x(:)
' (variable) @ constant x(variable)
' (constant) @ constant x(constant)
' (does) @     constant x(does)
' (deferred) @ constant x(deferred)

: see  ( | <word> -- )
    base @ >r hex
    ' dup @ case 
        x(:) of see-(:) endof
        x(variable) of see-(variable) endof
        x(constant) of see-(constant) endof
        x(does) of see-(does) endof
        x(deferred) of see-(deferred) endof
        dup ." unknown code field: " .
    endcase 
    r> base ! ;
