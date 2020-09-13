;пишет текст
          global    _main
          extern    _puts

          section   .text
_main:    push      rbx                     
          lea       rdi, [rel message]      ; First argument is address of message
          call      _puts                   ; puts(message)
          pop       rbx                     

          section   .data
message:  db        "Hola, the answer is 42", 0        