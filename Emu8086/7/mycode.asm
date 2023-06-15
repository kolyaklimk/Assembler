.model small
.stack 100h
.data
    message1 db 'Input first num: $'
    message2 db 0Dh,0Ah,'Input second num: $'
    message3 db 0Dh,0Ah,'Error! Incorrect input', 0Dh,0Ah,'$'
    message4 db 'Error, OF$'  
    message5 db 0Dh,0Ah,0Dh,0Ah,'num1 + num2 = $',0Dh,0Ah 
    message6 db 0Dh,0Ah,0Dh,0Ah,'num1 - num2 = $'
    message7 db 0Dh,0Ah,'num2 - num1 = $',0Dh,0Ah  
    message8 db 0Dh,0Ah,0Dh,0Ah,'num1 * num2 = $',0Dh,0Ah
    message9 db ', remainder = $'
    message10 db 0Dh,0Ah,0Dh,0Ah,'num1 / num2 = $'
    message11 db 0Dh,0Ah,'num2 / num1 = $',0Dh,0Ah
    inputStr db 7,7 dup('$')
    num1 dw 0
    num2 dw 0                   
.code
start:       
   
print_str macro out_str
    mov ah,9
    mov dx,offset out_str
    int 21h
endm
                
;================MAIN================                           
    mov ax,data
    mov ds,ax
    mov cx,1
                        
CheckGetStr1:   
    print_str message1
    call input
    loop CheckGetStr1       
    mov num1, ax                
    
CheckGetStr2:   
    print_str message2
    call input
    loop CheckGetStr2                                
    mov num2, ax 

    call sum  
                           
    print_str message6 
    mov ax,num1
    mov bx,num2
    call subt 
                               
    print_str message7     
    mov ax,num2
    mov bx,num1
    call subt   
    
    call mult
    
    print_str message10 
    mov dx,0   
    mov ax,num1
    mov bx,num2        

    cmp num1,0
    jl change1          
    call divi
    
cont1:    
    print_str message11     
    mov dx,0   
    mov ax,num2
    mov bx,num1        

    cmp num2,0
    jl change2          
    call divi

cont2:                  
    mov ax,4C00h
    int 21h    

change1:
    neg ax   
    neg bx
    call divi
    jmp cont1  
    
change2:
    neg ax    
    neg bx
    call divi 
    jmp cont2     
;===============PROC============== 
divi proc                  
    idiv bx
    jo of4        
    mov bx,dx
    call printNums 
    print_str message9   
    mov ax,bx
    call printNums
    jmp stop4
       
of4:
    print_str message4
            
stop4:      
    ret
divi endp

mult proc
    print_str message8
    mov ax,num1 
    imul num2
    jo of3
    call printNums
    jmp stop3
       
of3:
    print_str message4
            
stop3:      
    ret
mult endp

subt proc               
    sub ax,bx
    jo of2
    call printNums
    jmp stop2
       
of2:
    print_str message4
            
stop2:      
    ret
subt endp

sum proc
    print_str message5
    mov ax,num1 
    add ax,num2
    jo of1
    call printNums
    jmp stop1
       
of1:
    print_str message4
            
stop1:      
    ret
sum endp    
                     
input proc
    mov ah,0Ah
    mov dx,offset inputStr
    int 21h
               
    mov di,10            
    mov ax,0               
    mov bx,0 
                   
    cmp inputStr[2],'-'
    je minus        

plus:                
    cmp inputStr[1],6
    je error
      
    cmp inputStr[1],0
    je error
    
    mov si,offset inputStr+2 
    mov cl,inputStr[1]   
    jmp loopCheck

minus: 
    cmp inputStr[1],0
    je error
    
    mov si,offset inputStr+3
    mov cl,inputStr[1]
    dec cx     
    jmp loopCheck

loopCheck:
    mov bl,[si]             
    inc si                 
    cmp bl,'0'            
    jl error         
    cmp bl,'9'             
    jg error        
    sub bl,'0'             
    mul di                 
    jc error         
    add ax,bx              
    jc error         
    loop loopCheck 
    
    cmp ax,32767
    ja error
    
    mov cx,1       
    cmp inputStr[2],'-'
    je mulMinus 
    jmp stop
        
mulMinus: 
    neg ax         
    jmp stop
    
error:
    print_str message3
    mov cx,2      
stop:
ret
input endp 
      
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