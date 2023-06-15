.model small
.stack 100h
.data
    message1 db 'Input string: $'
    message2 db 0Dh,0Ah,'Result: $'
    message3 db 0Dh,0Ah,'Error!', 0Dh,0Ah,'$'
    buffer db 200,201 dup('$')

.code
start:

print_str macro out_str
    mov ah,9
    mov dx,offset out_str
    int 21h
endm

get_str macro
    mov ah,0Ah
    mov dx,offset buffer
    int 21h
endm

;================MAIN================
    mov ax,data
    mov ds,ax
    mov cx,0

CheckGetStr:
    print_str message1
    get_str
    jmp check_str

continue:
    cmp ax,cx
    je errorGet

print_str message2
    mov ax,0
    mov al,buffer[1]
    add ax,1
    mov si,ax
    mov ah,02h
    mov cl,buffer[1]

loopRes:
    mov dl,buffer[si]
    int 21h
    dec si
    loop loopRes

    mov ax,4C00h
    int 21h

;================CHECK_STR================
check_str:
    cmp buffer[1],0
    je errorGet

    mov cl,buffer[1]
    mov ax,0
    mov si,0

loopCheck:
    cmp buffer[2+si],' '
    je incSpace
    jmp noSpace

incSpace:
    inc ax
    inc si
    cmp si,cx
    je continue
    jmp loopCheck

noSpace:
    inc si
    cmp si,cx
    je continue
    jmp loopCheck

;================ERROR;================
errorGet:
    print_str message3
    jmp CheckGetStr

end start