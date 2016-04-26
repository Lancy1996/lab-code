.386
code	segment use16 para public 'code'
	assume	cs:code
start:	push cs
	push ds
	mov ax,3510h
	int 21h
	mov ah,4ch
	int 21h
code	ends
	end	start