.386
STACK   SEGMENT USE16 STACK
        DB 1000 DUP(0)
STACK   ENDS
DATA    SEGMENT USE16
BUF     DB 'L' XOR 'W','E' XOR 'A','N' XOR 'N','G' XOR 'G',
           'W' XOR 'L','E' XOR 'I','I' XOR 'N', 3 DUP(0)
        DB 100 XOR 'W',90 XOR 'A',80 XOR 'N',?
PWD     DB 7 XOR 'M'
        DB ('W'-31H)*2
        DB ('A'-31H)*2
        DB ('N'-31H)*2
        DB ('G'-31H)*2
        DB ('L'-31H)*2
        DB ('I'-31H)*2
        DB ('N'-31H)*2
        DB 31H,7AH,5FH
IPWD    DB 11
        DB ?
        DB 11 DUP(0)
IN_NAME DB 20
        DB ?
        DB 20 DUP(0)
POIN    DW 0
OLDINT1 DW  0,0               ;1号中断的原中断矢量
OLDINT3 DW  0,0               ;3号中断的原中断矢量
PRJE    DB 0AH,0DH,'PROJECT IS GOING TO EXIT!PRESS ANY KEY TO EXIT!',0AH,0DH,'$'
HINT    DB 'PLEASE INPUT STUDENT NAME!',0AH,0DH,'$'
PASSW   DB 'PLEASE INPUT PASSWORD!',0AH,0DH,'$'
DATA    ENDS
CODE    SEGMENT USE16
        ASSUME CS:CODE,DS:DATA,SS:STACK
START:  MOV AX,DATA
        MOV DS,AX
        xor  ax,ax                  ;接管调试用中断，中断矢量表反跟踪
        mov  es,ax
        mov  ax,es:[1*4]            ;保存原1号和3号中断矢量
        mov  OLDINT1,ax
        mov  ax,es:[1*4+2]
        mov  OLDINT1+2,ax
        mov  ax,es:[3*4]
        mov  OLDINT3,ax
        mov  ax,es:[3*4+2]
        mov  OLDINT3+2,ax
        cli                           ;设置新的中断矢量
        mov  ax,OFFSET NEWINT
        mov  es:[1*4],ax
        mov  es:[1*4+2],cs
        mov  es:[3*4],ax
        mov  es:[3*4+2],cs
        sti
        LEA DX,PASSW
        MOV AH,9
        INT 21H
        LEA DX,IPWD
        MOV AH,10
        INT 21H
        MOV CL,IPWD+1
        XOR CL,'M'
        CMP CL,PWD
        JNE EXIT
        MOV SI,0
PASS1:
        MOV DX,2
        MOVZX AX,IPWD+2[SI]
        SUB AX,31H
        MUL DX
        MOV CX,SI
        CMP CL,IPWD+1
        JE  PASS2
        CMP AL,PWD+1[SI]
        JNZ EXIT
        INC SI
        JNE PASS1
        JMP PASS2
PASS2:
        mov  bx,es:[1*4]             ;检查中断矢量表是否被调试工具阻止修改或恢复
        inc  bx
        jmp  bx
LOPE1:  LEA DX,HINT     ;读取输入姓名
        MOV AH,9
        INT 21H
        LEA DX,IN_NAME
        MOV AH,10
        INT 21H
        CMP IN_NAME+2,0DH
        JE  TEST1
        CMP IN_NAME+2,51H      ;检验是否为Q
        JE  TEST0
        CMP IN_NAME+2,71H      ;检验是否为q
        JE  TEST0
TEST1:  CMP IN_NAME+3,0
        JE  LOPE1
TEST0:  CMP IN_NAME+3,0DH
        JE  EXIT
        MOV DI,0
MIWEN:
        XOR IN_NAME+2,'W'
        XOR IN_NAME+3,'A'
        XOR IN_NAME+4,'N'
        XOR IN_NAME+5,'G'
        XOR IN_NAME+6,'L'
        XOR IN_NAME+7,'I'
        XOR IN_NAME+8,'N'
ERR:    MOV CL,IN_NAME+1
        MOV CH,0      ;获取输入姓名长度放入计数寄存器
        MOV SI,0
        CMP DI,41    ;已存储的内存大小
        JE  LOPE1
        MOV BL,DS:BUF[DI]
LOPE2:  CMP BL,IN_NAME+2[SI]
        JE  EQUA
        INC DI
        JNE ERR
EQUA:   INC SI
        INC DI
        MOV BL,DS:BUF[DI]
        DEC CX
        JNE LOPE2
        INC DI
        MOV BL,DS:BUF[DI]
        CMP BL,0
        JNE ERR
        MOV CL,IN_NAME+1
        MOV CH,0
        SUB DI,CX
        ADD DI,8
        LEA DX,DS:BUF[DI]
        MOV POIN,DX
        MOV SI,10
LOPE3:  MOV BL,BUF[SI]
        MOV BH,0
        XOR BX,'W'
        ADD BX,BX
        ADD BX,BX
        MOV AX,BX
        INC SI
        MOV BL,BUF[SI]
        MOV BH,0
        XOR BX,'A'
        ADD BX,BX
        ADD AX,BX
        INC SI
        MOV BL,BUF[SI]
        MOV BH,0
        XOR BX,'N'
        ADD AX,BX
        INC SI
        MOV BL,7
        DIV BL
        MOV BUF[SI],AL
        INC SI
        ADD SI,10
        CMP SI,52        ;已存储的内存大小
        JNE LOPE3
        MOV DL,0DH
        MOV AH,2
        INT 21H
	MOV DL,0AH
        MOV AH,2
        INT 21H
        MOV SI,POIN
        ADD SI,4
        MOV BL,BUF[SI]
        MOV BH,0
        CMP BX,90
        JGE AP0
        CMP BX,80
        JGE BP0
        CMP BX,70
        JGE CP0
        CMP BX,60
        JGE DP0
        MOV DL,45H
        MOV AH,2
        INT 21H
        JMP LOPE1
AP0:    MOV DL,41H
        MOV AH,2
        INT 21H
        JMP EXIT
BP0:    MOV DL,42H
        MOV AH,2
        INT 21H
        JMP EXIT
CP0:    MOV DL,43H
        MOV AH,2
        INT 21H
        JMP EXIT
DP0:    MOV DL,44H
        MOV AH,2
        INT 21H
        JMP EXIT
NEWINT: iret
TESTINT:jmp LOPE1
EXIT:
        cli                           ;还原中断矢量
        mov  ax,OLDINT1
        mov  es:[1*4],ax
        mov  ax,OLDINT1+2
        mov  es:[1*4+2],ax
        mov  ax,OLDINT3
        mov  es:[3*4],ax
        mov  ax,OLDINT3+2
        mov  es:[3*4+2],ax
        sti
        LEA DX,PRJE
        MOV AH,9
        INT 21H
	    MOV AH,1
        INT 21H
        MOV AH,4CH
        INT 21H
CODE    ENDS
        END     START
