.386
STACK   SEGMENT     USE16
        db  200 dup(0)
STACK   ENDS
DATA    SEGMENT     USE16
inf     db 0,0,?,?,'0ah','0dh'
num     db 0
DATA    ENDS
CODE    SEGMENT     USE16
        ASSUME  cs:CODE,ss:STACK,ds:DATA
start:
        mov ax,DATA
        mov ds,ax
        ;输入待读取的CMOS内部单元的地址编号，编号范围为0~9
        mov ah,1
        int 21H
        sub al,30H
        mov num,al
        ;准备读取CMOS中对应地址的数据
        mov al,num
        out 70h,al
        jmp $+2
        in  al,71h
        ;CMOS中数据以十进制给出，高四位为十位，低四位为个位
        ;将读取的十进制数转为16进制表示
        mov dl,al
        and dl,000fh
        shr al,4
        mov cl,10
        mul cl
        add al,dl
        mov ah,0
        mov cl,16
        div cl
        add al,30h
        mov inf+2,al
        cmp ah,10
        ja  output1
