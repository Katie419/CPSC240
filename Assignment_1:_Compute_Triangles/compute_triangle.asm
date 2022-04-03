extern printf
extern scanf
extern fgets
extern stdin
extern strlen
extern cos
extern sin

; constants
INPUT_LEN equ 32

global triangle_calculator

;; declared data blocks
segment .data

pi dq 0x400921FB54442D18

intro_message db "We take care of all your triangles.", 10, 10, 0

name_prompt db "Please enter your name: ", 0 ; <--- null terminator

input_prompt db 10, "Good morning %s, please enter the length of side 1, length of side 2, and size (degrees) of the included angle between them as real float numbers. Separate the numbers by white space, and be sure to press <enter> after the last inputted number.", 10, 10, 0

string_format db "%s", 0

confirm db 10, "Thank you %s. You entered %.4lf  %.4lf  %.4lf ", 10, 10, 0

area_message db "The area of your triangle is %.4lf square units", 10, 10,0
perimeter_message db "The perimeter is %.4lf linear units.", 10, 10, 0

final_message db "The area will now be sent to the driver function.", 10, 0

error db "Unfortunately, one of your inputs is invalid. Please run this program again.",10,0

three_float_format db "%lf %lf %lf",0

;; declared uninitialized data blocks
segment .bss
user_name: resb INPUT_LEN
area: resq 1
perimeter: resq 1

segment .text
triangle_calculator:

;16 Pushes
;=============================
push rbp
mov rbp, rsp
push rdi
push rsi
push rdx
push rcx
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
push rbx
pushf

;intro_message display
;=============================

mov rdi, string_format
mov rsi, intro_message
call printf


;name_prompt display
;=============================

mov rdi, string_format
mov rsi, name_prompt
call printf


;take name input
;=============================

mov rdi, user_name
mov rsi, INPUT_LEN
mov rdx, [stdin]
call fgets

;reply to user and request for more info
;=============================

;adjust the user_name so it does not skip a line each time we print
;----------

;get string length
mov rax, 0
mov rdi, user_name
call strlen

;calculate address of <enter> inside user_name
sub rax, 1
;move results into somewhere safer
mov r12, rax
;edit the byte in the given address and replace it with a null character
mov byte [user_name + r12], 0

;----------

mov rdi, input_prompt
mov rax, 1
mov rsi, user_name
call printf

; Take user input for 2 sides and 1 degree
;=============================

;Obtain User input
;----------
;sets the lineup for rsp
push qword 0

;make room for the three doubles in the stack
push qword 0
push qword 0
push qword 0

mov rdi, three_float_format ; set the format
mov rsi, rsp ;sets rsi = rsp = side A
mov rdx, rsp ;sets rdx = rsp
add rdx, 8 ; sets rdx = rsp + 8 = adjusts to address of side B
mov rcx, rsp ;sets rcx = rsp
add rcx, 16 ; sets rcx = rsp + 16 = adjusts to address of side A
call scanf

;----------

;Store User input
;----------
movsd xmm13, [rsp] ;side A
pop rax
movsd xmm14, [rsp] ;side B
pop rax
movsd xmm15, [rsp] ;degree
pop rax
pop rax
;----------

;print user's inputted values
;=============================

mov rdi, confirm
mov rax, 4
mov rsi, user_name
movsd xmm0, xmm13
movsd xmm1, xmm14
movsd xmm2, xmm15
call printf


;check for any negative inputs
;=============================

;xmm13 = side A
;xmm14 = side B
;xmm15 = degree in radian
;xmm12 = 0

mov rax, 0
push rax
movsd xmm12, [rsp]
pop rax

ucomisd xmm13, xmm12 ;compares side 1 with 0.0
jbe invalid
ucomisd xmm14,xmm12
jbe invalid
ucomisd xmm15, xmm12
jbe invalid


;Calculate area
;=============================

;Convert the degrees to radians
;----------
;degrees -> radians = (degree)(pi/180)
;xmm13 = side A
;xmm14 = side B
;xmm15 = degree

movsd xmm12, [pi] ; xmm12 = pi (denominator)
mov rax, 180
cvtsi2sd xmm11, rax ; xmm11 = 180 (numerator)
divsd xmm12, xmm11 ; xmm12 = pi/180
mulsd xmm15, xmm12 ; xmm13 = rad angle

;----------

;area = (A*B*sin(x)/2)
;xmm13 = side A
;xmm14 = side B
;xmm15 = degree in radians

movsd xmm0, xmm15 ;xmm10 = degree
call sin ; xmm0 = sin(degree)

movsd xmm11, xmm13 ; xmm11 = A
mulsd xmm11, xmm14 ; xmm11 = A * B
mulsd xmm11, xmm0 ; xmm11 = A * B * sin(x)
mov rax, 2 ;number we're dividing by
cvtsi2sd xmm12, rax ;convert 2 to a float and store in xmm12
divsd xmm11, xmm12 ; xmm11 = area
movsd [area], xmm11

;Calculate perimeter
;=============================

; missing side (C) = sqrt(A^2 + B^2 - 2AB*cos(x)
;xmm13 = side A
;xmm14 = side B
;xmm15 = degree in radians

movsd xmm9, xmm13
mulsd xmm9, xmm9 ;xmm9 = A^2

movsd xmm10, xmm14
mulsd xmm10, xmm10 ; xmm10 = B^2

mov rax, -2
cvtsi2sd xmm11, rax
mulsd xmm11, xmm13
mulsd xmm11, xmm14 ; xmm11 = -2AB

movsd xmm0, xmm15
call cos ; xmm12 = cos(x)

mulsd xmm11, xmm0 ; xmm11 = -2AB*cos(x)

addsd xmm9, xmm10 ;xmm9 = A^2 + B^2
addsd xmm9, xmm11 ;xmm9 = A^2 + B^2 + -2AB*cos(x)

sqrtsd xmm9, xmm9 ; xmm9 = missing side

;add our sides
movsd xmm12, xmm13; xmm12 = A
addsd xmm12, xmm14; xmm12 = A + B
addsd xmm12, xmm9 ; xmm12 = A + B + C

movsd [perimeter], xmm12

;Print Final results
;=============================

mov rdi, area_message
mov rax, 1
movsd xmm0, [area]
call printf

mov rdi, perimeter_message
mov rax, 1
movsd xmm0, [perimeter]
call printf

;Jump to the End
;=============================
jmp end


;Invalid
;=============================
invalid:

;print invalid message
  mov rdi, error
  mov rsi, string_format
  call printf
;jump to end of program
  jmp end


;16 pops
;=============================

end:
    popf
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp
    ret ;  return
