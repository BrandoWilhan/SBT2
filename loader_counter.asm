segment .data

sem_espaco              db  "nao foi possivel carregar o programa na memoria, nao há espaco", 0ah, 0
SEM_ESPACO_SIZE         EQU $-sem_espaco

programa_carregado      db  "o programa foi carregado no(s) seguinte(s) par(es) <endereco_inicial> <endereco_final>", 0ah, 0
PROGRAMA_CARREGADO_S    EQU $-programa_carregado

espaco                  db  " ", 0
ESPACO_S                EQU $-espaco

nwln                  db  0ah
NWLN_S                EQU $-nwln

buffer      times 12    db  0
BUFFER_SIZE             EQU $-buffer

segment .text
global f1
;EBP + 8 tamanho do programa
;EBP + 12 numero de pares de endereco memoria
;EBP + 8*i + 16 ; i = 0  até i = 3 ;; endereços de memória
;EBP + 8*i + 20 ; i = 0  até i = 3 ;; memoria livre disponivel

f1:
    enter 0,0
    mov esi, 0
    mov ecx, [EBP + 12] ;numero de pares
    mov eax, 0

    .verifica_se_cabe:

        mov edx, [EBP + 8*esi + 20] ; memorias
        add eax, edx 
        cmp [EBP + 8], edx
        je .iguais

        inc esi
        
        loop .verifica_se_cabe


    cmp [EBP + 8], eax ;compara com tamanho do programa
    jg .nao_cabe


    mov esi, 0
    mov ecx, [EBP + 12] ;numero de pares
    call mostrar_msg_carregado
    mov eax, [EBP + 8] ;tamanho do programa
    ;faz isso (numero_de_pares_vezes):
    .dividido:
        mov ebx,[EBP + 8*esi + 16]  ;endereco inicial
        ;mostrar inicial
        mov edx, [EBP + 8*esi + 20] ;tamanho de memoria
        
        push eax

        mov eax, ebx
        mov edi, buffer
        call int_to_str
        push dword buffer
        push dword BUFFER_SIZE
        call print
        add esp, 8      ; esquece numero mostrado 

        pop eax

        cmp eax, edx 
        jb .menor_que_o_bloco   ;ultimo bloco de memoria
        

        call clear_buffer
        ;mostra espaco
        push dword espaco
        push dword ESPACO_S
        call print
        add esp, 8      ; esquece valor mostrado 
        
        push eax
        push edx
        dec edx

        add ebx, edx
        ;mostrar end final
        mov eax, ebx
        mov edi, buffer
        call int_to_str
        push dword buffer
        push dword BUFFER_SIZE
        call print
        add esp, 8
        ;nwln
        push dword nwln
        push dword NWLN_S
        call print
        add esp, 8
        inc esi

        pop edx
        pop eax
        
        sub eax, edx
        
        loop .dividido
        
    
    .iguais:
        call mostrar_msg_carregado
        mov ebx,[EBP + 8*esi + 16]  ;endereco inicial
        ;mostrar inicial
        mov eax, ebx
        mov edi, buffer
        call int_to_str
        push dword buffer
        push dword BUFFER_SIZE
        call print
        add esp, 8      ; esquece numero mostrado 

        dec edx

        call clear_buffer
        ;mostra espaco
        push dword espaco
        push dword ESPACO_S
        call print
        add esp, 8      ; esquece valor mostrado 

        add ebx, edx
        ;mostrar end final
        mov eax, ebx
        mov edi, buffer
        call int_to_str
        push dword buffer
        push dword BUFFER_SIZE
        call print
        add esp, 8
        ;nwln
        push dword nwln
        push dword NWLN_S
        call print
        add esp, 8
        jmp .return    

    .nao_cabe:
        
        push dword sem_espaco
        push dword SEM_ESPACO_SIZE
        call print
        add esp, 8  
        jmp .return
    
    .menor_que_o_bloco:
        

        call clear_buffer
        ;mostra espaco
        push dword espaco
        push dword ESPACO_S
        call print
        add esp, 8      ; esquece valor mostrado 

        dec eax
        add ebx, eax
        ;mostrar end final
        mov eax, ebx
        mov edi, buffer
        call int_to_str
        push dword buffer
        push dword BUFFER_SIZE
        call print
        add esp, 8
        ;nwln
        push dword nwln
        push dword NWLN_S
        call print
        add esp, 8

    .return:
        leave
        ret

clear_buffer:
    enter 0,0
    push eax
    push ecx
    mov ecx, BUFFER_SIZE  ; Número de bytes a limpar
    mov edi, buffer       ; Aponta para o início do buffer
    mov al, 0          ; Define o valor de limpeza como `0`
    rep stosb             ; Limpa todo o buffer
    pop ecx
    pop eax
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
    mov ecx, [EBP + 12] ;numero de pares ;msg
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

mostrar_msg_carregado:
    enter 0,0
    

    push dword programa_carregado
    push dword PROGRAMA_CARREGADO_S
    call print
    add esp, 8      ; esquece valor mostrado

    leave
    ret