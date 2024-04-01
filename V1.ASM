DATA_SEGMENT SEGMENT
    buffer DB 255 DUP (?)      ; буфер для зберігання введених рядків
    substring DB 255 DUP (?)   ; зберігає вказаний підрядок
    results DW 100 DUP (?)     ; масив для зберігання результатів
    occurrences DW 100 DUP (?) ; масив для зберігання кількості входжень
    input_length DW ?          ; довжина введеного рядка
    sub_length DW ?            ; довжина підрядка
    index DW ?                 ; індекс введеного рядка
    results_count DW ?         ; кількість результатів
DATA_SEGMENT ENDS

CODE_SEGMENT SEGMENT
    ASSUME CS:CODE_SEGMENT, DS:DATA_SEGMENT
START:
    mov ax, DATA_SEGMENT
    mov ds, ax

    ; Отримуємо підрядок із командного рядка
    mov si, 81h
    mov di, offset substring
    mov cx, 255
    call get_cmdline_arg
    mov sub_length, cx

    ; Зчитуємо рядки із stdin
read_loop:
    mov ah, 0Ah        ; DOS function for buffered input
    lea dx, buffer
    int 21h

    mov bl, [buffer+1] ; Довжина введеного рядка
    mov [input_length], bx

    ; Перевірка на кінець введення
    cmp bl, 0
    je end_input

    ; Знаходимо кількість входжень підрядка у введеному рядку
    lea si, buffer+2
    lea di, substring
    mov cx, 0 ; Записує кількість входжень
    call count_occurrences

    ; Записуємо результати
    mov bx, results_count
    mov dx, [bx]
    mov [bx], dx
    inc bx
    mov [bx], si
    add bx, 2
    mov results_count, bx

    ; Читаємо наступний рядок
    jmp read_loop

end_input:
    ; Сортуємо результати методом бульбашкового сортування
    mov cx, results_count
    mov dx, cx
    dec dx

sort_loop:
    mov bx, dx
    mov si, bx
inner_loop:
    cmp si, 0
    jle next_outer_iteration

    mov ax, [results+si-2]
    mov bx, [results+si-4]
    cmp ax, bx
    jbe next_inner_iteration

    ; Переставляємо елементи
    mov dx, [results+si-2]
    mov [results+si-2], ax
    mov [results+si], dx

next_inner_iteration:
    sub si, 2
    jmp inner_loop

next_outer_iteration:
    dec dx
    jmp sort_loop
    ; Кінець алгоритму сортування

    ; Виводимо результати
    mov cx, results_count
    mov si, offset results
print_loop:
    mov ax, [si]    ; кількість входжень
    mov bx, [si+2] ; індекс рядка
    add si, 4
    call print_number
    call print_space
    call print_number
    call print_newline

    loop print_loop

    mov ax, 4C00h
    int 21h

print_number:
    ; Перетворює число в рядок і виводить його
    push ax
    push bx
    push cx
    push dx

    mov cx, 10
    mov bx, 0
next_digit:
    xor dx, dx
    div cx
    add dl, '0'
    push dx
    inc bx
    test ax, ax
    jnz next_digit

print_loop_end:
    pop dx
    mov ah, 02h
    int 21h
    dec bx
    jnz print_loop_end

    pop dx
    pop cx
    pop bx
    pop ax
    ret

print_space:
    mov dl, ' '
    mov ah, 02h
    int 21h
    ret

print_newline:
    mov dl, 0Dh
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    int 21h
    ret

get_cmdline_arg:
    ; Отримує аргумент з командного рядка
    push si
    mov ah, 62h
    int 21h
    mov ah, 9
    int 21h
    pop si
    ret

count_occurrences:
    ; Рахує кількість входжень підрядка
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov ax, cx      ; Зберігаємо оригінальне значення CX
    mov cx, sub_length ; CX = довжина підрядка
    mov bx, input_length ; BX = довжина введеного рядка
    cld             ; Очищення флагу напрямку для REP SCAS
    mov si, di      ; SI - адреса підрядка
    mov di, si      ; DI - адреса введеного рядка
    rep scasb       ; Порівняти підрядок з введеним рядком
    sub di, si      ; DI = кількість порівнянь, тобто різниця між DI та SI
    mov si, ax      ; Повертаємо значення CX у SI
    mov cx, ax      ; CX = кількість порівнянь
    mov ax, bx      ; AX = довжина введеного рядка
    sub ax, cx      ; AX = AX - CX
    mov cx, ax      ; CX = кількість можливих входжень підрядка
    mov ax, bx      ; AX = довжина введеного рядка
    sub ax, si      ; AX = AX - SI
    mov di, ax      ; DI = кількість можливих входжень підрядка
    mov bx, di      ; BX = кількість можливих входжень підрядка
    cmp si, bx      ; Порівняння кількостей можливих входжень підрядка
    jb count_end    ; Якщо кількість входжень підрядка менше кількості можливих входжень, переходимо до count_end
    mov bx, cx      ; BX = кількість можливих входжень підрядка
    jmp count_end   ; Переходимо до count_end
count_end:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

CODE_SEGMENT ENDS

END START