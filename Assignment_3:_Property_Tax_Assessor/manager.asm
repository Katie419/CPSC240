extern printf
extern scanf
extern strlen
extern stdin
extern fgets
extern isfloat
extern atof
extern get_assessed_values
extern display
extern sum

INPUT_LEN equ 64

global manager

segment .data

string_format db "%s", 0
float_format db "%lf", 0

name_prompt db "Please enter your name and press enter:  ", 0
title_prompt db "Please enter your title: ", 0
thank_name db "Thank you %s.", 10, 0

property_list db "Thank you.  Here are the assessed property values in this district.", 10 ,0

sum_message db "The sum of assessed values is $%.2lf.", 10, 0
mean_message db "The mean assessed values is $%.4lf.", 10, 0

return_message db "The mean will now be returned to the caller function.", 10, 0
title_goodbye db "We enjoy serving everyone who is a %s.", 10, 0

error db "Thank you.  The data input set was corrupted.  Please run this program again.", 10, 0

segment .bss

user_name resb INPUT_LEN
title_name resb INPUT_LEN
array resq 100
array_size resq 1
sum_value resq 1
mean_value resq 1


segment .text
manager:

;///////////BEGIN CODE////////////////////////////////////////////

;===============
; 16 pushes
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
;Obtain name

;-----
;print name prompt
push qword 0
mov rax, 0
mov rdi, string_format
mov rsi, name_prompt
call printf
pop rax

;-----
;take user name input
mov rdi, user_name
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;-----
;replace trailing \n with \0 in user_name
mov rax, 0
mov rdi, user_name
call strlen
sub rax, 1
mov byte [user_name + rax], 0

;-----

;===============
;Obtain job title

;-----
;print name prompt
mov rax, 0
mov rdi, string_format
mov rsi, title_prompt
call printf

;-----
;take user name input
mov rdi, title_name
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;-----
;replace trailing \n with \0 in user_name
mov rax, 0
mov rdi, title_name
call strlen
sub rax, 1
mov byte [title_name + rax], 0

;==============
;Print thank you message to user
mov rdi, thank_name
mov rax, 1
mov rsi, user_name
call printf

;===============
;fill array using get_assessed values module
mov rdi, array
mov rsi, 100
call get_assessed_values
mov [array_size], rax ;save the array size value returned by fill

;-----
;If size = 0 we skip to invalid
mov r14, [array_size]
mov r15, 0
cmp r15, r14
je invalid

;===============
;Display properties

;-----
;"Here are your assessed properties"
mov rax, 0
mov rdi, property_list
call printf

;-----
;Display array using show_property_value module
mov rax, 0
mov rdi, array
mov rsi, [array_size]
call display

;===============
;Get the sum
mov rdi, array
mov rsi, [array_size]
call sum
movsd [sum_value], xmm0

;===============
;Calculate the mean
cvtsi2sd xmm11, [array_size]
movsd xmm13, [sum_value]
divsd xmm13, xmm11

;===============
;Display the sum and the mean

;-----
;Display the sum
mov rax, 1
mov rdi, sum_message
movsd xmm0, [sum_value]
call printf

;-----
;Display the mean
mov rax, 1
mov rdi, mean_message
movsd xmm0, xmm13
call printf

;===============
;Jump to End
jmp exit

;===============
;invalid
invalid:

mov rax, 0
push rax
movsd xmm12, [rsp]
pop rax

mov rax, 1
mov rdi, sum_message
movsd xmm0, xmm12
call printf

mov rax, 1
mov rdi, mean_message
movsd xmm0, xmm12
call printf

;==============
;Finish Program
exit:

mov rax, 0
mov rdi, string_format
mov rsi, return_message
call printf

mov rax, 1
mov rdi, title_goodbye
mov rsi, title_name
call printf

movsd xmm0, [mean_value]

;-----
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
