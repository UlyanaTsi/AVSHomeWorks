; считывает первый введеный символ и печатает ег

section .data
	msg_enter:	db	"Please, enter a char: "
	.len:		equ	$ - msg_enter
	msg_entered:	db	"You have entered: "
	.len:		equ	$ - msg_entered

section .bss
	char:		resb	1				

section .text
	global		_main
_main:
										
	mov	rax, 0x2000004					
	mov	rdi, 1							
	mov	rsi, msg_enter					
	mov	rdx, msg_enter.len				
	syscall

										; read char
	mov	rax, 0x2000003					
	mov	rdi, 0							
	mov	rsi, char						
	mov	rdx, 2							
	syscall

										; show message
	mov	rax, 0x2000004					
	mov	rdi, 1							
	mov	rsi, msg_entered				
	mov	rdx, msg_entered.len			
	syscall

										; show char
	mov	rax, 0x2000004					
	mov	rdi, 1							
	mov	rsi, char						
	mov	rdx, 2							
	syscall

										; exit system call
	mov	rax, 0x2000001					
	xor	rdi, rdi						
									
	syscall