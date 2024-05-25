;**********************************************
; ��楤��� ��� ������୮� ࠡ��� �1 �� ��� *
;**********************************************

.MODEL SMALL
.CODE
.386
	LOCALS

;==============================================
	COLLECTOR PROC NEAR
		input_loop:
			mov ah, 01h
			int 21h
			sub al, '0'
			mov [di], al
			inc di
			loop input_loop

		ret
	COLLECTOR ENDP

	CONVERTER PROC NEAR
		convert_loop:
			shl bx, 1
			mov al, [di]
			add bx, ax
			inc di
			loop convert_loop

		ret
	CONVERTER ENDP

	PRINTER PROC NEAR
		process_digits:
			xor dx, dx
			div cx
			push dx
			inc bx
			test ax, ax
			jnz process_digits

		print_loop:
			pop dx
			add dl, '0'
			mov ah, 02h
			int 21h
			dec bx
			jnz print_loop

		ret
	PRINTER ENDP
;==============================================

    display_char proc NEAR
        mov ah, 2
        lea dx, [di]
        int 21h
        ret
    display_char endp

    display_newline proc NEAR
        mov ah, 9
        mov dx, 13
        int 21h
		mov dx, 10
        int 21h
        ret
    display_newline endp

	PUBLIC COLLECTOR, CONVERTER, PRINTER, display_char, display_newline

END
