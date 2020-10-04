;----------------------------------------------------------------------------------------
; FASM
; Программа считывает массив и создает новый из 
; элементов массива, кратных введенному числу x
; (вариант 6)
;
;----------------------------------------------------------------------------------------

format PE console
entry start

include 'win32a.inc'

;----------------------------------------------------------------------------------------
section '.data' data readable writable

        arrSizeMsg:     db 'Enter array size:', 0              ; array size string
        incSizeMsg:     db 'Wrong number = %d !', 10, 0        ; incorrect size string
        errorMsg:       db 'Error!!',10 , 0                    ; error string
        xInputMsg:      db 'Enter x:',  0                      ; x input string
        yourArrMsg:     db 'Array A:', 10, 0                   ; array A string
        newArrMsg:      db 'Array B:', 10, 0                   ; array B string
        itemMsg:        db '[%d]: ', 0                                   
        strScanInt:     db '%d', 0
        strMaskVector   db 'Array has %d element(s) multiple of %d:', 10, 0
        arrElementMsg:  db '[%d] = %d', 10, 0

        arrSize      dd 0                                      ; A array size
        newArrSize   dd 0                                      ; B array size
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        arr          dd ?                                      ; array A
        newArr       dd ?                                      ; array B
        x            dd ?

;----------------------------------------------------------------------------------------
section '.code' code readable executable
start:


; Inputs
        call arrayInput
        call xInput
; Prints Array A
        call arrayOutput

; Main
        call main_

; New array 
        push [x]
        push [newArrSize]
        push strMaskVector
        call [printf]

; Prints new array

        call newArrOutput
finish:
        call [getch]
        push 0
        call [ExitProcess]

; Array A input
;----------------------------------------------------------------------------------------
arrayInput:
        push arrSizeMsg
        call [printf]
        add esp, 4

        push arrSize
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [arrSize]
        cmp eax, 0
        jg  getArray

        ; if size of the array was incorrect
        push [arrSize]
        push incSizeMsg
        call [printf]

        call [getch]

        push 0
        call [ExitProcess]
getArray:

        mov ecx, [arrSize]
        imul ecx, 4

        push ecx
        push ecx
        call mem_alloc
        mov [newArr], eax

        call mem_alloc
        mov [arr], eax

        xor ecx, ecx
        mov ebx, [arr]

getArrLoop:
        mov [tmp], ebx
        cmp ecx, [arrSize]
        jge endArrayInput      

        ; array elements input
        mov [i], ecx
        push ecx
        push itemMsg
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getArrLoop

endArrayInput:
        ret

; X number input
;----------------------------------------------------------------------------------------
xInput:

        push xInputMsg
        call [printf]
        add esp, 4

        push x
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [x]
        cmp eax, 0
        jg inputPass

        ; if x was incorrect number
        push [x]
        push incSizeMsg
        call [printf]

        call [getch]

        push 0
        call [ExitProcess]

    inputPass:
        ret

; Prints new array 
;----------------------------------------------------------------------------------------
newArrOutput:

        push newArrMsg
        call [printf]
        add esp, 4

        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, [newArr]


putNewArrLoop:
        mov [tmp], ebx
        cmp ecx, [newArrSize]
        je endNewArrOutput      
        mov [i], ecx

        ; prints array elements
        push dword [ebx]
        push ecx
        push arrElementMsg
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putNewArrLoop

endNewArrOutput:
        mov esp, [tmpStack]
        ret

; Prints old array
;----------------------------------------------------------------------------------------
arrayOutput:

        push yourArrMsg
        call [printf]
        add esp, 4

        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, [arr]

putArrLoop:
        mov [tmp], ebx
        cmp ecx, [arrSize]
        je endOutputArray   
        mov [i], ecx

        ; prints array elements
        push dword [ebx]
        push ecx
        push arrElementMsg
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putArrLoop

endOutputArray:
        mov esp, [tmpStack]
        ret


;----------------------------------------------------------------------------------------

proc mem_alloc, bsize

    call   [GetProcessHeap]

    push    [bsize]
    push    HEAP_ZERO_MEMORY
    push    eax

    call   [HeapAlloc]

    or     eax, eax
    jnz    _no_err

    push errorMsg          ; warnings
    call [printf]
    call [getch]
    push 0
    call [ExitProcess]

    _no_err:
    ret

endp

;----------------------------------------------------------------------------------------
proc main_

        mov ecx, [arrSize]
        mov ebx, [arr]
        mov edi, [newArr]

findMultLoop:
        xor edx, edx
        mov eax, [ebx]

        div [x]
        cmp edx, dword 0

        jne ifend
        mov edx, [ebx]
        mov [edi], edx

        add edi, 4
        inc [newArrSize]

    ifend:
        add ebx, 4                
        loop findMultLoop         

endMaskVector:
        ret
endp

;----------------------------------------------------------------------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           GetProcessHeap,'GetProcessHeap',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'