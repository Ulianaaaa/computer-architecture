.data
input_addr:      .word  0x80 
output_addr:     .word  0x84 

    .text
_start:           

    @p input_addr a! @  
    a!              
    lit 0           
    lit 31 >r        

main_loop:
    a                  
    lit 1 and          
    +                  
    a 2/ a!             
    next main_loop      

finish:
    @p output_addr a! !  
    halt