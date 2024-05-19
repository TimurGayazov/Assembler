;***************************************************************************************************
; MLAB1.ASM - �祡�� �ਬ�� ��� �믮������ 
; ������୮� ࠡ��� N1 �� ��設��-�ਥ��஢������ �ணࠬ��஢����
; 10.09.02: ������ �.�.
;***************************************************************************************************
        .MODEL SMALL
        .STACK 200h
	.386
;       �ᯮ������� ������樨 ����⠭� � ����ᮢ
        INCLUDE MLAB1.INC	
        INCLUDE MLAB1.MAC

; ������樨 ������
        .DATA    
SLINE	DB	78 DUP (CHSEP), 0
REQ	DB	"������� �.�.: ",0FFh
MINIS	DB	"������������ ����������� ���������� ���������",0
ULSTU	DB	"����������� ��������������� ����������� �����������",0
DEPT	DB	"��䥤� ���᫨⥫쭮� �孨��",0
MOP	DB	"��設��-�ਥ��஢����� �ணࠬ��஢����",0
LABR	DB	"������ୠ� ࠡ�� N 1",0
REQ1    DB      "���������(-),�᪮���(+), ������� �㭪�� f(f), ���(ESC)? ",0FFh
TACTS   DB	"�६� ࠡ��� � ⠪��: ",0FFh
EMPTYS	DB	0
BUFLEN = 70
BUF	DB	BUFLEN
LENS	DB	?
SNAME	DB	BUFLEN DUP (0)
PAUSE	DW	0, 0 ; ����襥 � ���襥 ᫮�� ����প� �� �뢮�� ��ப�
TI	DB	LENNUM+LENNUM/2 DUP(?), 0 ; ��ப� �뢮�� �᫠ ⠪⮢
LAB1_MSG_IN_X DB "������ X", 0
LAB1_MSG_IN_Y DB "������ Y", 0
LAB1_F_VAR DB "f3 = x2x4 | x1!x3 | !x1x3!x4 | x3x4 | !x1!x2x3", 0
LAB1_MSG_F DB "�㭪�� ࠢ��: $"
LAB1_MSG_Z DB "Z ࠢ��:", 0
X_ DB 20 dup(0)
X  DD 0
Y DD 0
Z DD 0
F DD 0

                                          ; ����� ��� ࠧ����⥫��� "`"

;========================= �ணࠬ�� =========================
        .CODE
; ����� ���������� ��ப� LINE �� ����樨 POS ᮤ�ন�� CNT ��ꥪ⮢,
; ����㥬�� ���ᮬ ADR �� �ਭ� ���� �뢮�� WFLD
BEGIN	LABEL	NEAR
	; ���樠������ ᥣ���⭮�� ॣ����
	MOV	AX,	@DATA
	MOV	DS,	AX
	; ���樠������ ����প�
	MOV	PAUSE,	PAUSE_L
	MOV	PAUSE+2,PAUSE_H
	PUTLS	REQ	; ����� �����
	; ���� �����
	LEA	DX,	BUF
	CALL	GETS	
@@L:	; 横���᪨� ����� ����७�� �뢮�� ���⠢��
	; �뢮� ���⠢��
	; ��������� ������� ������ �����
	FIXTIME
	PUTL	EMPTYS
	PUTL	SLINE	; ࠧ����⥫쭠� ���
	PUTL	EMPTYS
	PUTLSC	MINIS	; ��ࢠ� 
	PUTL	EMPTYS
	PUTLSC	ULSTU	;  �  
	PUTL	EMPTYS
	PUTLSC	DEPT	;   ��᫥���騥 
	PUTL	EMPTYS
	PUTLSC	MOP	;    ��ப�  
	PUTL	EMPTYS
	PUTLSC	LABR	;     ���⠢��
	PUTL	EMPTYS
	; �ਢ���⢨�
	PUTLSC	SNAME   ; ��� ��㤥��
	PUTL	EMPTYS
	; ࠧ����⥫쭠� ���
	PUTL	SLINE
	; ��������� ������� ��������� ����� 
	DURAT    	; ������ ����祭���� �६���
	; �८�ࠧ������ �᫠ ⨪�� � ��ப� � �뢮�
	LEA	DI,	TI
	CALL	UTOA10	
	PUTL	TACTS
	PUTL	TI      ; �뢮� �᫠ ⠪⮢
	; ��ࠡ�⪠ �������
	PUTL	REQ1
	CALL	GETCH
	CMP	AL,	'-'    ; 㤫������ ����প�?
	JNE	CMINUS
	INC	PAUSE+2        ; �������� 65536 ���
	JMP	@@L
CMINUS:	CMP	AL,	'+'    ; 㪮�稢��� ����প�?
	JNE	LAB1_CFUNC
	CMP	WORD PTR PAUSE+2, 0		
	JE	BACK
	DEC	PAUSE+2        ; 㡠���� 65536 ���
BACK:	JMP	@@L
LAB1_CFUNC:
	CMP AL, 'f'
	JE LAB1_CODE
	CMP AL, 'F'
	JE LAB1_CODE
	JMP CEXIT
LAB1_CODE:
	MOV ECX, 5
	PUTL	EMPTYS
	PUTL	EMPTYS
	PUTL	EMPTYS
	PUTL	EMPTYS
	PUTL	EMPTYS
	PUTL SLINE
	
	PUTL LAB1_MSG_IN_X

	MOV ECX, 20
	LEA ESI, X_ + 20; � ESI �࠭���� ���� ���� ���ᨢ�
	XOR EDX,EDX

LAB1_IN_X:
	SHL EDX, 1
	DEC SI
	BTR DWORD PTR [SI], 0
	CALL GETCH
	CALL PUTC
	CMP AL, '1'
	JNE LAB1_IN_X_NZ
	ADD DWORD PTR [SI], 1
	ADD EDX, 1
LAB1_IN_X_NZ:
	LOOP LAB1_IN_X 
	MOV X, EDX

	MOV AL, 10
	CALL PUTC
	MOV AL, 13
	CALL PUTC
	;⥯��� x1: [ESI + 1] � �.�.

LAB1_FUNC_CALC: ;f3 = x2x4 | x1!x3 | !x1x3!x4 | x3x4 | !x1!x2x3
	;f6 = ?x1 x?2 x3 | x1 x3 | x2 x?3 | x2 x4 | x1 x?3 x?4.

	XOR EAX, EAX
	XOR EBX, EBX

	MOV AL, [ESI+1] ; x1
	MOV BL, [ESI+2] ; x2
	BTC AX, 0
	BTC BX, 0
	AND AL, BL		; !x1!x2
	MOV BL, [ESI+3] ; x3
	AND AL, BL ; !x1!x2x3

	MOV F, EAX 		; X = !x1!x2x3

	MOV AL, [ESI+1] ; x1
	MOV BL, [ESI+3] ; x3
	AND AL, BL		; x1x3

	OR EAX, F 		; !x1!x2x3 | x1x3 
	MOV F, EAX		; X = !x1!x2x3 | x1x3 

	MOV AL, [ESI+2] ; x2
	MOV BL, [ESI+3] ; x3
	BTC BX,0 			; !x3
	AND AL, BL		; x2!x3

	OR EAX, F 		; !x1!x2x3 | x1x3| x2!x3
	MOV F, EAX		; X = !x1!x2x3 | x1x3 | x2!x3

	MOV AL, [ESI+2] ; x2
	MOV BL, [ESI+4] ; x4
	AND AL, BL		; x2x4

	OR EAX, F 		; !x1!x2x3 | x1x3 | x2!x3 | x2x4
	MOV F, EAX		; X = !x1!x2x3 | x1x3 | x2!x3 | x2x4

	MOV AL, [ESI+1] ; x1
	MOV BL, [ESI+3] ; x3              
	BTC BX,0 			; !x3
	AND AL, BL		; x1!x3
	MOV BL, [ESI+4] ; x4
	BTC BX,0 			; !x4
	AND AL, BL		; x1!x3!x4

	OR EAX, F 		; !x1!x2x3 | x1x3 | x2!x3 | x2x4 | x1!x3!x4
	MOV F, EAX		; X = !x1!x2x3 | x1x3 | x2!x3 | x2x4 | x1!x3!x4

	MOV AH, 09h     
    LEA DX, LAB1_MSG_F
    INT 21h

	ADD AX, '0'
	CALL PUTC

	PUTL EMPTYS
	PUTL LAB1_MSG_IN_Y

	MOV ECX, 20 	; ���� Y
	XOR EDX, EDX

LAB1_IN_Y:
	SHL EDX, 1
	CALL GETCH
	CALL PUTC
	CMP AL, '1'
	JNE LAB1_IN_Y_NZ
	ADD EDX, 1

LAB1_IN_Y_NZ:
	LOOP LAB1_IN_Y
	
	MOV Y, EDX

	PUTL EMPTYS

	CMP F, 0 		; �஢�ઠ �㭪樨
	JE LAB1_F_FALSE
	JNE LAB1_F_TRUE

LAB1_F_TRUE:
	SHL X, 1		; X * 2
	MOV EAX, X
	SUB EAX, Y
	MOV Z, EAX		; Z = X*2 - Y
	JMP LAB1_Z_FIRST	

LAB1_F_FALSE:
	SHR X, 3		; X / 8
	MOV EAX, X
	ADD EAX, Y		
	MOV Z, EAX		; Z = X/8 + Y

LAB1_Z_FIRST:

	MOV EBX, Z 
	XOR EAX, EAX
	PUTL LAB1_MSG_Z
	SHL EBX, 12		; ᤢ�� ��譨� 12 ��⮢ ᫥��
	MOV ECX, 20

LAB1_OUT_Z_0:
    SHL EBX, 1  	; ����� ���祭�� EBX �� 1 ��� �����
    DEC ECX     	; �����襭�� ���稪�
    JC LAB1_OUT_Z_NZ_0

LAB1_OUT_Z_Z_0:
    MOV AL, '0'  	; �᫨ ��� �� 0, �뢮��� '0'
    CALL PUTC
    JMP CHECK_EXIT_0

LAB1_OUT_Z_NZ_0:
    MOV AL, '1'  	; �᫨ ��� �� 1, �뢮��� '1'
    CALL PUTC

CHECK_EXIT_0:
    CMP ECX, 0  	; �஢��塞, �����稫� �� �� �뢮� ��� ���
    JG LAB1_OUT_Z_0	; �᫨ ��, � �த������ �뢮�

	MOV AL, 10
	CALL PUTC
	MOV AL, 13
	CALL PUTC

	MOV EAX, Z
	BT EAX, 11		; �஢�ઠ 11-�� ���
	JC LAB1_Z_FIRST_NZ

	MOV EBX, 0		; �᫨ 11-� ��� ࠢ�� 0
	JMP LAB1_Z_FIRST_CALC

LAB1_Z_FIRST_NZ:	
	MOV EBX, 1		; �᫨ 11-� ��� ࠢ�� 1

LAB1_Z_FIRST_CALC:	
	SHL EBX, 9		; ᮧ����� ��᪨ ��� ����樨 OR
	MOV EAX, Z
	OR EAX, EBX 	; �ਬ������ ��᪨
	MOV Z, EAX

	BT EAX, 17		; �஢�ઠ 17-�� ���
	JC LAB1_Z_SECOND_NZ

	BTS EAX, 15		; �᫨ 17-� ��� ࠢ�� 0, � 18-� ��� ࠢ�� 1
	JMP LAB1_Z_THIRD

LAB1_Z_SECOND_NZ:	
	BTR EAX, 15		; �᫨ 17-� ��� ࠢ�� 1, � 18-� ��� ࠢ�� 0

LAB1_Z_THIRD:
	MOV Z, EAX

	BT EAX, 4		; �஢�ઠ 4-�� ���
	JC LAB1_Z_THIRD_END ; �᫨ 4-� ��� ࠢ�� 1, � 7-� ��� �� �����塞

LAB1_Z_THIRD_Z:		
	BTR EAX, 7		; �᫨ 4-� ��� ࠢ�� 0, � 7-� ��� ࠢ�� 0

LAB1_Z_THIRD_END:
	MOV Z, EAX
	
	PUTL LAB1_MSG_Z

	MOV EBX, Z 
	XOR EAX, EAX

	SHL EBX, 12		; ᤢ�� ��譨� 12 ��⮢ ᫥��
	MOV ECX, 20

LAB1_OUT_Z:
    SHL EBX, 1  	; ����� ���祭�� EBX �� 1 ��� �����
    DEC ECX     	; �����襭�� ���稪�
    JC LAB1_OUT_Z_NZ

LAB1_OUT_Z_Z:
    MOV AL, '0'  	; �᫨ ��� �� 0, �뢮��� '0'
    CALL PUTC
    JMP CHECK_EXIT

LAB1_OUT_Z_NZ:
    MOV AL, '1'  	; �᫨ ��� �� 1, �뢮��� '1'
    CALL PUTC

CHECK_EXIT:
    CMP ECX, 0  	; �஢��塞, �����稫� �� �� �뢮� ��� ���
    JG LAB1_OUT_Z	; �᫨ ��, � �த������ �뢮�
    JLE @@E   	; �᫨ ���, � ��室��




CEXIT:	CMP	AL,	CHESC	
	JE	@@E
	TEST	AL,	AL
	JNE	BACK
	CALL	GETCH
	JMP	@@L
	; ��室 �� �ணࠬ��
@@E:	EXIT	
        EXTRN	PUTSS:  NEAR
        EXTRN	PUTC:   NEAR
	EXTRN   GETCH:  NEAR
	EXTRN   GETS:   NEAR
	EXTRN   SLEN:   NEAR
	EXTRN   UTOA10: NEAR
	END	BEGIN

