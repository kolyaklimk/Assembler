.model small
.stack 100h
.data    
    f_name db 'text.txt',0
    buffer db 255,256 dup('$')                          
    message1 db 0Dh,0Ah,'Error!', 0Dh,0Ah,'$'
    message2 db 'file not found!', 0Dh,0Ah,'$'
    message3 db 'path not found!', 0Dh,0Ah,'$'
    message4 db 'too many open files!', 0Dh,0Ah,'$'
    message5 db 'Access is denied!', 0Dh,0Ah,'$'
    message6 db 'invalid access mode!', 0Dh,0Ah,'$'
    count dw 0                  
.code
start:   
 
print_str macro out_str
    mov ah,9
    mov dx,offset out_str
    int 21h
endm
;main
    mov ax,data
    mov ds,ax   
    
open:    
;open file     
    mov dx, offset f_name
    mov ah,3Dh 
    mov al,00h 
    int 21h 
    jc exit 
    mov bx,ax    

read_data:
    mov cx,255
    mov dx,offset buffer 
    mov ah,3Fh
    int 21h 
    jc close_file 
    mov cx,ax 
    jcxz close_file
    call find  
    jmp short read_data 

close_file:  
    mov ah,3Eh 
    int 21h 
    jmp prinRes
    
exit:                  
    print_str message1
    cmp ax,02h
    je 02  
    cmp ax,03h
    je 03 
    cmp ax,04h
    je 04 
    cmp ax,05h
    je 05 
    cmp ax,06h
    je 06 
02: 
    print_str message2
    jmp conttt 

03: 
    print_str message3
    jmp conttt
   
    
04: 
    print_str message4
    jmp conttt
    
05: 
    print_str message5
    jmp conttt
            
06: 
    print_str message6
    jmp conttt            
            
conttt:    
    jmp contin               

prinRes:
    mov ax,count
    call printNums

contin:            
    mov ax,4C00h
    int 21h    

; proc  
find proc 
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si,2
    mov cl,buffer[1]
    mov ax,0  
         
loopCheck:  
    mov bx,1    
    mov al,buffer[si]
    cmp al,10
    je findN           
    
cont:
    inc si    
    loop loopCheck        
    jmp contt
      
      
findN:    
    cmp buffer[si+bx],13
    je incB  
    cmp buffer[si+bx],9
    je incB 
    cmp buffer[si+bx],32
    je incB          
    cmp buffer[si+bx],10
    je yes
    jmp cont
    
incB:
    inc bx 
    jmp findN    

yes:
    inc count
    add si,bx 
    dec si
    jmp cont

contt:    
    pop si        
    pop dx 
    pop cx
    pop bx
    pop ax
ret
find endp
    

printNums proc
    push ax
    push bx
    push cx
    push dx
    mov bx,10     
    mov cx,0     
    or ax,ax      
    jns loopdiv
    neg ax     
    push ax    
    mov ah,02h
    mov dl,'-'
    int 21h
    pop ax
loopdiv:               
    mov dx,0
    div bx
    push dx     
    inc cx     
    or ax,ax
    jnz loopdiv        
    mov ah,02h
store:
    pop dx     
    add dl,'0'
    int 21h    
    loop store
    pop dx
    pop cx
    pop bx
    pop ax
ret
printNums endp  

end start