.386
code    segment     use16   para    public   'code'
        assume  cs:code,ss:stack
old_16h dw  ?,?
new_16h:
        cmp ah,0h       ;判断用户是否调用键盘驱动程序的读键盘功能
        je  input0
        cmp ah,10h      ;判断是否读拓展键盘
        je  input0
        jmp dword ptr   old_16h ;调用原键盘驱动程序（old_16h）
input0: ;先调用旧的键盘驱动程序
        pushf
        call dword ptr  old_16h
        cmp al,'a'
        jne input1
        mov al,'b'
        jmp finish
input1:
        cmp al,'A'
        jne input2
        mov al,'B'
        jmp finish
input2:
        cmp al,'b'
        jne input3
        mov al,'a'
        jmp finish
input3:
        cmp al,'B'
        jne finish
        mov al,'A'
finish:
        iret
start:
        xor ax, ax
        mov ds, ax
        mov ax, ds:[16h*4]      ; 保存旧程序偏移址
        mov old_16h, ax
        mov ax, ds:[16h*4+2]    ; 保存旧程序段首址
        mov old_16h+2, ax
        ;原中断程序保存
        cli
        mov word ptr ds:[58h], offset new_16h
        mov ds:[5ah], cs
        sti
        ;修改中断矢量表，将new_16h置入中断矢量表
        mov dx,offset start+15
        shr dx,4
        add dx,10h
        mov al,0
        mov ah,31h
        int 21h
        ;将dx节的主存单元驻留
code    ends
stack   segment stack   use16
        db 200 dup(0)
stack   ends
        end start
