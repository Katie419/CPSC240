extern printf
extern scanf
extern strlen
extern isfloat
extern atof

INPUT_LEN equ 64

global get_assessed_values

segment .data

float_format db "%lf", 0
string_format db "%s", 0

fill_prompt db "Next we will collect the property values in your assessment district.  Between each value enter while space. When finished entering values press <enter> followed by control+D.", 10, 0
invalid_input db "Invalid input", 10, 0
error db "Thank you.  The data input set was corrupted.  Please run this program again.", 10, 0


segment .bss

user_input resb INPUT_LEN

segment .text

get_assessed_values:

;////////////BEGIN CODE///////////////

;===============
;16 pushes

push rbp ; Push memory address of base of previous stack frame onto stack top

mov rbp, rsp ; Copy value of stack pointer into base pointer, rbp = rsp = both point to stack top
    ; Rbp now holds the address of the new stack frame, i.e "top" of stack

push rdi ; Backup rdi
push rsi ; Backup rsi
push rdx ; Backup rdx
push rcx ; Backup rcx
push r8 ; Backup r8
push r9 ; Backup r9
push r10 ; Backup r10
push r11 ; Backup r11
push r12 ; Backup r12
push r13 ; Backup r13
push r14 ; Backup r14
push r15 ; Backup r15
push rbx ; Backup rbx
pushf ; Backup rflags

;===============
;Set aside registers to hold information

mov r15, rdi ;r15 = pointer to array
mov r14, 0   ;r14 = loop counter
mov r13, rsi ;r13 = max size for array


;===============
;Print fill prompt

mov rax, 0
mov rdi, string_format
mov rsi, fill_prompt
call printf

;===============
;Start a Loop to fill the array

;r15 = pointer to array
;r14 = loop counter
;r13 = max size for array

beginloop:
  ;-----
  ;Check if the array is completely filled
  cmp r13, r14
  je leave_loop

  ;==========
  ;----
  ;Get the user input

  ;mov rdi, user_input
  ;mov rsi, INPUT_LEN
  ;mov rdx, [stdin]
  ;call fgets

  mov rax, 1
  mov rdi, string_format
  mov rsi, user_input
  call scanf

  ;-----
  ;Check if user entered cntrl + d

  cdqe
  cmp rax, -1
  je leave_loop

  ;-----
  ;replace trailing \n with \0 in job_name

  mov rax, 0
  mov rdi, user_input
  call strlen
  sub rax, 1
  mov r12, rax
  mov byte [user_input + r12], 0

  ;-----

  ;===========
  ;Validate

  ;-----
  ;Call the isfloat function

  mov	rax, 0
  mov	rdi, user_input
  call isfloat
  mov	r11, rax

  ;-----
  ;compare r11 which is the return of the function with 0(false)

  cmp r11, 0
  je  invalid

  ;-----
  ;==========
  ;-----
  ;convert user input to float

  mov rax, 1
  mov rdi, user_input
  call atof
  movsd xmm15, xmm0

  ;-----
  ;place the input number in array

  movsd [r15 + 8*r14], xmm15
  inc r14
  jmp beginloop

  ;-----
;===============
;Out of Loop

invalid:

mov rax, 0
mov rdi, string_format
mov rsi, invalid_input
call printf

mov rax, 0
mov rdi, string_format
mov rsi, error
call printf

mov r14, 0

jmp leave_loop


leave_loop:

;===============
;return array size to caller

mov rax, r14

;===============
;16 pops
popf ; Restore rflags
pop rbx ; Restore rbx
pop r15 ; Restore r15
pop r14 ; Restore r14
pop r13 ; Restore r13
pop r12 ; Restore r12
pop r11 ; Restore r11
pop r10 ; Restore r10
pop r9 ; Restore r9
pop r8 ; Restore r8
pop rcx ; Restore rcx
pop rdx ; Restore rdx
pop rsi ; Restore rsi
pop rdi ; Restore rdi

pop rbp ; Restore rbp

ret ;  return
