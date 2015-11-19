\ installation of defining words                

' create constant create0  ' immediate constant imm0            
: [char]  m[char] ; immediate                                   
: s"  ms" ; immediate                                           
: [']  m['] ; immediate                                         
: create  mcreate ;                                             
: variable  mvariable ;                                         
: constant  mconstant ;                                         
: else  melse ; immediate                                       
: then mthen ; immediate                                        
: while  mwhile ; immediate                                     
: repeat  mrepeat ; immediate                                   
: do  mdo ; immediate                                           
: loop  mloop ; immediate                                       
: +loop  m+loop ; immediate                                     
: string  mstring ;                                             
: if  mif ; immediate                                           
: begin  mbegin ; immediate                                     
: again  magain ; immediate                                     
: until  muntil ; immediate
: of  mof ; immediate
: endof  melse ; immediate                                       
: endcase  mendcase ; immediate                                       
: defer  mdefer ;
: is  mis ; immediate
: immediate  mimmediate ;                                       
: : m: ;                                                        
                                                                
\ manually compile ';'                                          
create0 execute ; ' (:) @ here 1 cells - ! ' m; , ' exit ,      
imm0 execute                                                    
