 org $8000

 ldaa #0
 staa $8800
 ldx #$2200

fill:
	staa ,x
	inca
	inx
	cmpa #0255
	bne fill
	ldy #$2200
	
parity_check:
	ldd #0
	ldx #2
	ldab ,y 
	idiv
	cpd #1
	bne next
	inc $8800
	jmp next

next:
	iny
	cpy #$2300
	bne parity_check
	ldaa $8800
	nop