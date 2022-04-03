extern printf   ; includes printf
extern scanf    ; includes scanf


INPUT_LEN equ 64

global sum

segment .data


string_format: db "%s", 0
prompt_name: db "Please enter your name user: ", 0
exit: db "The program will now return to the driver", 10, 0

; printf("%s", my_string_pointer);

segment .bss

user_name: resb INPUT_LEN

segment .text
sum:


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

;registers to keep track of
mov r15, rdi ;r15 = array pointer
mov r14, rsi ;r14 = counter

;-----
;set the sum value to 0 in xmm15
mov rax, 0
cvtsi2sd xmm15, rax

;==========
beginloop:
addsd xmm15, [r15 + 8*r14]

dec r14

cmp r14, 0
jge beginloop

movsd xmm0, xmm15

;===============
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
