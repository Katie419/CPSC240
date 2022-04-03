extern printf
extern scanf
extern strlen
extern stdin
extern fgets
extern isfloat
extern atof

INPUT_LEN equ 64

global gravity

segment .data

gravity_value dq 0x402399999999999A

string_format db "%s", 0
float_format db "%lf", 0

intro db "If errors are discovered please report them to Columbia.Inc at columbia.com for a rapid update.  At Columbia, Inc, the customer comes first.", 10 , 0

name_prompt db "Please enter your first and last names: ", 0

job_prompt db "Please enter your job title (Nurse, Programmer, Gamer, Carpenter, Mechanic, Bus Driver, Barista, Hair Dresser, Acrobat, Farmer, Sales Clerk, etc): ", 0

job_response db "Thank you %s.  We appreciate your business.", 10, 0

purpose db "We understand that you plan to drop a marble from a high vantage point.", 10, 0

info_prompt db "Please enter the height of the marble above ground surface in meters: ", 0

calculation db "The marble you drop from that height will reach earth after %.9lf seconds.", 10, 0

error db "An error was detected in the input data.  You may run this program again.", 10, 0

final_message db "Thank you %s for your participation.  May you never lose sight of the goal.", 10, 0

segment .bss

user_name resb INPUT_LEN
job_name resb INPUT_LEN
user_input resb INPUT_LEN

segment .text
gravity:


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

;==============
;print intro message
mov rax, 0
mov rdi, string_format
mov rsi, intro
call printf

;===============
;Obtain the user's name

;-----
;print name prompt

mov rax, 0
mov rdi, string_format
mov rsi, name_prompt
call printf

;-----
;take user name input

mov rdi, user_name
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;-----
;replace trailing \n with \0 in user_name

;get string length
mov rax, 0
mov rdi, user_name
call strlen

;calculate address of <enter> inside
sub rax, 1
;move results into somewhere safer
;mov r12, rax
;edit the byte in the given address and replace it with a null character
mov byte [user_name + rax], 0

;-----
;===============
;Obtain the user's job info

;-----
;print job prompt

mov rax, 0
mov rdi, string_format
mov rsi, job_prompt
call printf

;-----
;take user job input

mov rdi, job_name
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;-----
;replace trailing \n with \0 in job_name

;get string length
mov rax, 0
mov rdi, job_name
call strlen

;calculate address of <enter>
sub rax, 1
;move results into somewhere safer
;mov r12, rax
;edit the byte in the given address and replace it with a null character
mov byte [job_name + rax], 0

;-----
;Print job_response message

mov rdi, job_response
mov rax, 1
mov rsi, job_name
call printf

;==========
;Ask for and obtain user input for drop height

;-----
;print purpose statement
mov rax, 0
mov rdi, string_format
mov rsi, purpose
call printf

;-----
;Print info_prompt

mov rax, 0
mov rdi, string_format
mov rsi, info_prompt
call printf

;-----
;Take user input as a string so we can validate
mov rdi, user_input
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;-----
;replace trailing \n with \0 in job_name

;get string length
mov rax, 0
mov rdi, user_input
call strlen

;calculate address of <enter>
sub rax, 1
;move results into somewhere safer
mov r12, rax
;edit the byte in the given address and replace it with a null character
mov byte [user_input + r12], 0

;-----
;===============
;Validate input

;-----
;Call the isfloat function

mov	rax, 0
;pass the user_input as a argument of isfloat
mov	rdi, user_input
call isfloat
;the returned values(0 or 1) of isfloat should be found in rax
;0 or 1 (true or false)
mov	r11, rax

;-----
;compare r11 which is the return of the function with 0(false)

cmp r11, 0
je  invalid

;-----
;===============
;if valid, calculate the drop time

; time = sqrt(2h/9.8)

;convert user input to float
mov rax, 1
mov rdi, user_input
call atof
movsd xmm15, xmm0

mov rax, 2
cvtsi2sd xmm14, rax
; movsd xmm12, xmm15

;xmm14 = 2
;xmm12 = height
;xmm15 = height

; xmm15 = 2 * h
mulsd xmm15, xmm14
movsd xmm13, [gravity_value]
divsd xmm15, xmm13
sqrtsd xmm15, xmm15

mov rdi, calculation
mov rax, 1
movsd xmm0, xmm15
call printf

;===============

jmp exit

;===============
invalid:

;print error message
mov rax, 0
mov rdi, string_format
mov rsi, error
call printf

jmp exit

;===============
exit:

;print final message
mov rax, 0
mov rdi, string_format
mov rsi, final_message

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
