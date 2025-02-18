segment .data

msg         db  "Hello World! Function", 0ah, 0
MSG_SIZE    EQU $-msg
buffer      times 12 db  0
BUFFER_SIZE EQU $-buffer

segment .text
global f1
;EBP + 8 tamanho do programa
;EBP + 8*i + 12 ; i = 0  até i = 3 ;; endereços de memória
;EBP + 8*i + 16 ; i = 0  até i = 3 ;; memoria livre disponivel

f1:
    enter 0,0
    mov eax, [EBP + 8]
    mov edi, buffer
    call int_to_str
    push dword buffer
    push dword BUFFER_SIZE
    call print
    add esp, 8
    push dword msg  ; Empurrando o endereço diretamente para a pilha
    push dword MSG_SIZE
    call print
    
    leave
    ret

print: 
    enter 0,0
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4          ;chamada de sistema syswrite
    mov ebx, 1          ;stdout
    mov ecx, [EBP + 12] ;msg
    mov edx, [EBP + 8]  ;msg_size
    int 80h

    pop edx
    pop ecx
    pop ebx
    pop eax
    leave
    ret


int_to_str:
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ecx, 10          ; Base 10
    mov esi, edi         ; `esi` aponta para o início do buffer
    cmp eax, 0           ; Verifica se o número é negativo
    jge .loop            ; Se for positivo, continua normalmente


.loop:
    xor edx, edx         ; Limpa EDX antes da divisão
    div ecx              ; Divide EAX por 10, resto em EDX (dígito extraído)
    add dl, '0'          ; Converte número para ASCII
    mov [edi], dl        ; Armazena no buffer
    inc edi              ; Avança para próxima posição

    test eax, eax        ; Se EAX == 0, terminou a conversão
    jnz .loop

    mov byte [edi], 0    ; Adiciona terminador nulo (`\0`)
    dec edi              ; `edi` agora aponta para o último caractere válido

.reverse:
    cmp esi, edi         ; Se `esi >= edi`, terminamos a inversão
    jge .done

    mov al, [esi]        ; Troca caracteres
    mov ah, [edi]
    mov [esi], ah
    mov [edi], al

    inc esi              ; Move início para frente
    dec edi              ; Move fim para trás
    jmp .reverse

.done:
    mov eax, buffer 
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret