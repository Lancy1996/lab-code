<<<<<<< HEAD
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
=======
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
>>>>>>> e3db146ea5334cf795d18d08e7f431a0029aa53e
	end	start