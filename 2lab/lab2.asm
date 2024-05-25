.model small
.stack 100h
.386

include lab2m.mac

.data
input_msg db "Enter a string: $"

arr_0_4_len_text db "arr_0_4 length: $"
arr_other_len_text db "arr_other length: $"

arr_0_4_text db "arr_0_4: $"
arr_other_text db "arr_other: $"

bin_sum db "The sum of the numbers from 0 to 4: $"

max_char db 0
current_char db 0
max_count dw 0
current_count dw 0

output_msg db "Result: $"
newline db 0Dh, 0Ah, "$"
buffer_size equ 100
input_buffer db buffer_size dup('$')
output_buffer db 256 dup('$')
numbers_buffer db 256 dup('$')

arr_0_4 db 256 dup(0)
arr_0_4_len dw 0
arr_other db 256 dup(0)
arr_other_len dw 0

BASE dw 10

.code
main proc
    mov ax, @data
    mov ds, ax

    PRINT_STRING input_msg

    mov ah, 0Ah
    lea dx, input_buffer
    int 21h

    mov si, offset input_buffer+2 ; Пропуск первого байта (длина) и второго байта (размер буфера)
    mov di, si
next_char:
    lodsb
    cmp al, 0Dh
    je end_input
;начало
    ; Проверка символа (0-4)
    cmp al, '0'
    jl save_other_char
    cmp al, '4'
    jg save_other_char
    
    mov di, offset arr_0_4
    add di, arr_0_4_len
    mov [di], al
    inc arr_0_4_len
    jmp next_char
;конец
save_other_char:
    mov di, offset arr_other
    add di, arr_other_len
    mov [di], al
    inc arr_other_len
    jmp next_char

end_input:
    call display_newline
    call display_newline

    PRINT_STRING arr_0_4_len_text
	mov ax, arr_0_4_len
	mov cx, BASE
	mov bx, 0
	call printer_integer

    call display_newline

    PRINT_STRING arr_other_len_text
	mov ax, arr_other_len
	mov cx, BASE
	mov bx, 0
	call printer_integer
    
    call display_newline
    call display_newline
    
    PRINT_STRING arr_0_4_text
    PRINT_ARR_MAC arr_0_4, arr_0_4_len

    call display_newline

    PRINT_STRING arr_other_text
    PRINT_ARR_MAC arr_other, arr_other_len
    
    call display_newline
    call display_newline





find_often_char:
    mov current_char, 0
    mov max_char, 0
    mov current_count, 0
    mov max_count, 0

    mov si, offset arr_other ; "ewqeze" ; max_char max_count    current_char current_count "1wq1z1" 
    mov cx, arr_other_len

first_loop:
    mov ax, current_count
    cmp ax, max_count
    jg swap_char_count
    
continue_first_loop:
    mov al, [si]
    cmp al, 0
    inc si
    je output_most_often
    cmp al, '1'
    je first_loop

    mov current_char, al
    mov current_count, 0

    mov di, offset arr_other
    

second_loop:
    mov bl, [di]
    cmp bl, 0
    je first_loop

    cmp al, bl
    je similar_char
    inc di
    jmp second_loop


similar_char:
    inc current_count
    inc di
    jmp second_loop

output_most_often:

    mov ah, 2
    mov dl, max_char
    int 21h

    mov ah, 2
    mov dl, ':'
    int 21h

    mov ax, max_count
	mov cx, BASE
	mov bx, 0
	call printer_integer

    mov ah, 2
    mov dl, ','
    int 21h

    
    mov ah, 2
    mov dl, ' '
    int 21h
    
    PRINT_STRING arr_other_text
    PRINT_ARR_MAC arr_other, arr_other_len
    call display_newline

    




; Удаление символов с максимальной частотой
    mov si, offset arr_other
    mov cx, arr_other_len
    
delete_max_char_loop:
    mov al, [si]
    inc si
    cmp al, 0
    je check_arr_is_empty
    cmp al, '1'
    je delete_max_char_loop
    cmp al, max_char
    jne delete_max_char_loop

    mov byte ptr [si-1], '1'
    jmp delete_max_char_loop
    


; Проверка на необходибость выхода
check_arr_is_empty:
    mov si, offset arr_other
    mov cx, arr_other_len
    
    check_arr_is_empty_loop:
        mov al, [si]
        inc si
        cmp al, '1'
        je check_arr_is_empty_loop

        cmp al, 0
        je find_sum_0_4

        jmp find_often_char



find_sum_0_4:
    call display_newline
    
    ; Перевод и подсчёт чисел от 0 до 4
    cmp arr_0_4_len, 0
    je program_end

    PRINT_STRING bin_sum
    mov cx, arr_0_4_len
    mov si, offset arr_0_4
    
    xor bx, bx
    
convert_loop1:
    mov al, [si]
    sub al, '0'
    add bl, al
    inc si
    loop convert_loop1
    
    ; Вывод суммы в двоичном формате
    mov cx, 8 ; Вывод 8 бит
print_loop1:
    mov dl, '0'             ; Вывод '0' или '1'
    test bl, 10000000b      ; Проверка старшего бита
    jz zero_detected
    mov dl, '1'             ; Если старший бит установлен, выводим '1'
zero_detected:
    mov ah, 02h
    int 21h
    
    shl bl, 1               ; Сдвиг влево на 1 бит
    loop print_loop1

program_end:
    mov ah, 4ch
    int 21h
main endp






swap_char_count:
    mov bl, current_char
    mov max_char, bl
    
    mov bx, current_count
    mov max_count, bx
    jmp continue_first_loop


print_arr proc
print_arr_loop:
    mov dl, [si]
    mov ah, 2
    cmp dl, 0
    je end_print_arr
    int 21h
    mov ah, 2
    mov dl, ','
    int 21h
    inc si
    jmp print_arr_loop
end_print_arr:
    ret
print_arr endp

printer_integer proc
    process_digits:
        xor dx, dx
        div cx
        push dx
        inc bx
        test ax, ax
        jnz process_digits

    print_loop3:
        pop dx
        add dl, '0'
        mov ah, 02h
        int 21h
        dec bx
        jnz print_loop3

    ret
printer_integer endp

converter proc
    convert_loop:
        shl ebx, 1
        mov al, [di]
        add ebx, eax
        inc di
        loop convert_loop
    ret
converter endp

display_char proc
    mov ah, 2
    lea dx, [di]
    int 21h
    ret
display_char endp

display_newline proc
    mov ah, 9
    lea dx, newline
    int 21h
    ret
display_newline endp

end main
