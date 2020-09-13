; выводит первые 90 чисел фибоначчи
  global _main
  extern _printf

  section .text
_main:
  push    rbx                   
                                

  mov     ecx, 90               
  xor     rax, rax              
  xor     rbx, rbx              
  inc     rbx                   

print:
  push    rax                   
  push    rcx                   

  lea     rdi, [format]         
  mov     rsi, rax              
  xor     rax, rax  

  call    _printf               ; printf(format, current_number)

  pop     rcx                   
  pop     rax                   

  mov     rdx, rax              ; save the current number
  mov     rax, rbx              ; next number is now current
  add     rbx, rdx              ; get the new next number 
  dec     ecx                   ; count down
  jnz     print                 ; continue until counter reaches 0

  pop     rbx                   
  ret

format:
default rel
  db    "%20ld", 10, 0 
