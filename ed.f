\ Block editor


vocabulary editor also editor definitions
                                                                
variable row        variable column                             
variable findbuf    variable findbuf#                           
variable insertbuf  variable insertbuf#                         
variable relist                                                 
                                                                
: lines  ( n1 -- n2 ) 64 * ;                                    
: >line  ( -- ) scr @ block row @ lines + ;                     
: eotib?  ( -- f ) >limit @ >in @ < ;                           
                                                                
: .line  ( -- ) relist @ 0= eotib? 0= or if exit then           
  cr row @ .row >line 64 type cr column @ 3 + spaces [char] ^   
  emit cr ;                                                     
                                                                
: #tib  ( -- n ) >limit @ >in @ - ;                             
: emptytib  ( -- ) >limit @ 1+ >in ! ;                          
: >loc  ( -- a ) >line column @ + ;                             
                                                                
: insertbuf!  ( | ... -- ) eotib? if exit then                  
  source >in @ + insertbuf @ #tib dup insertbuf# ! cmove        
  emptytib ;                                                    
                                                                
: findbuf!  ( | ... -- ) eotib? if exit then                    
  source >in @ + findbuf @ #tib dup findbuf# ! cmove            
  emptytib ;                                                    
                                                                
: l  ( -- ) page scr @ list .line ;                             
: n  ( -- ) 1 scr +! row off column off l ;                     
: b  ( -- ) -1 scr +! row off column off l ;                    
: t  ( n -- ) row ! column off .line ;                          
                                                                
: p  ( | ... -- ) >line 64 blank insertbuf! insertbuf @ >line   
  insertbuf# @ cmove column off .line update ;                  
                                                                
: insert  ( | ... -- ) insertbuf! >loc dup                           
  insertbuf# @ + 64 column @ - insertbuf# @ - 0 max cmove>      
  insertbuf @ >line column @ + insertbuf# @ cmove update        
  .line ;                                                       
                                                                
: e  ( -- ) >loc dup findbuf# @ dup >r - 64 column @            
  - cmove >line 64 + r@ - r@ blank r> negate column +! .line    
  update ;                                                      
                                                                
: f  ( | ... -- ) findbuf! >line 64 findbuf @ findbuf# @        
  search if drop >line - findbuf# @ + column ! .line else 2drop 
  then ;                                                        
                                                                
: copydown  ( n -- ) row @ 15 = if drop exit then >r >line      
  dup r> lines + 15 row @ - lines cmove> ;                      
                                                                
: u  ( | ... -- ) row @ 15 = abort" end of block"               
  1 copydown 1 row +! p  ;                                      
                                                                
: x  ( -- ) >line insertbuf @ 64 cmove 64 insertbuf# ! row      
  @ 15 = if >line 64 blank else >line 64 + >line 16 row @ - 1-  
  lines cmove scr @ block 15 lines + 64 blank then .line        
  update ;                                                      
                                                                
: d  ( | ... -- ) relist off f relist on e ;                    
: r  ( | ... -- ) relist off e relist on insert ;                    
                                                                
: copy  ( n1 n2 -- ) block update swap block swap 1024 cmove ;  
: addr>pos  ( a -- ) scr @ block - 64 /mod row ! column ! ;     
                                                                
: s-scr  ( -- f) >loc 1024 row @ lines - column @ - findbuf     
  @ findbuf# @ search if drop findbuf# @ + addr>pos true else   
  2drop false then ;                                            
                                                                
: s  ( n | ... -- n ) findbuf! s-scr if l exit then             
  max-blocks @ min 1+ scr                                       
  @ 1+ do i block 1024 findbuf @ findbuf# @ search if drop i    
  scr ! addr>pos l unloop exit else 2drop then loop ;           
                                                                
: g  ( n1 n2 -- ) 1 copydown lines swap block + insertbuf !     
  64 insertbuf# ! p ;                                           
                                                                
: bring  ( n1 n2 n3 -- ) relist off over - 1+ 0 do 2dup i +     
  g 1 row +! loop 2drop relist on .line ;                       
                                                                
: k  ( -- ) findbuf @ >r insertbuf @ findbuf ! r> insertbuf !   
  findbuf# @ >r insertbuf# @ findbuf# ! r> insertbuf# ! ;       
                                                                
: till  ( | ... -- ) findbuf! >line 64 findbuf @ findbuf# @     
  search if >r >loc r@ cmove >line 64 + r@ - r> blank update    
  .line else 2drop then ;                                       
                                                                
: cut  ( -- ) >loc 64 column @ - blank update .line ;           
                                                                
: show  ( n1 n2 -- ) 1+ swap do i list loop ;                   
                                                                
: index  ( n1 n2 -- ) 1+ swap do [char] # emit i . i block      
  64 type cr loop ;                                             
                                                                
: wipe  ( -- ) scr @ block 1024 blank update ;                  

: i  ( | ... -- ) insert ;


\ initialization                                 
                                                                
buffers-base @                                                  
dup 1024 - findbuf !  2048 - insertbuf !                        
relist on                                                       
:noname ['] n is next-screen ['] b is previous-screen ; execute

only definitions
