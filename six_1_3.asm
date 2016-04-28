<<<<<<< HEAD
.386

code    segment     use16   para   public   'code'
        assume  cs:code
start:  xor ax,ax
        mov dx,ax
	mov ds,0
        cli
        mov dx,ds:[10h*4]
        mov ax,ds:2[10h*4]
        sti
        mov ah,4ch
        int 21h
code    ends
        end     start
