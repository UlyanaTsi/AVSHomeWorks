        global   _main
        extern   _atoi
        extern   _printf
        default  rel

        section  .text
_main:
        push     rbx                    
                                        
        dec      rdi                    
        jz       nothingToAverage
        mov      [count], rdi           ; save number of real arguments
accumulate:
        push     rdi                    
        push     rsi
        mov      rdi, [rsi+rdi*8]       
        call     _atoi                  
        pop      rsi                    
        pop      rdi
        add      [sum], rax             ; accumulate sum 
        dec      rdi                  
        jnz      accumulate             
average:
        cvtsi2sd xmm0, [sum]
        cvtsi2sd xmm1, [count]
        divsd    xmm0, xmm1             ; xmm0 is sum/count
        lea      rdi, [format]          ; 1st arg to printf
        mov      rax, 1              
        call     _printf                ; printf(format, sum/count)
        jmp      done

nothingToAverage:
        lea      rdi, [error]
        xor      rax, rax
        call     _printf

done:
        pop      rbx                    
        ret

        section  .data
count:  dq       0
sum:    dq       0
format: db       "%g", 10, 0
error:  db       "There are no command line arguments to average", 10, 0