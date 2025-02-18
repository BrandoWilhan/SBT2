#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>



int main (int argc, char *argv[]){
    int program_length, n_peers, i, n_args;

    extern void f1(int program_length, int n_peers, ...);

    if (argc < 4 || (argc - 2)%2 != 0) {
        printf("Para rodar, use ./carregador <tamanho_progra> <endereco> <espaco livre>\n");
        printf("Para até 4 pares <endereco> <espaco livre> \n");
        return 1;
    }
    n_args = argc - 1;

    int *args = (int *)malloc(n_args * sizeof(int));  

    if (args == NULL) {  
        printf("Erro na alocação de memória!\n");
        return 1;
    }

    n_peers = (argc-2)/2;

    for(i = 1; i < argc; i++){
        args[i-1] = atoi(argv[i]);
    }

    program_length = args[0];

    if(n_peers == 1){
        f1(program_length, n_peers, args[1], args[2]);
    }

    if(n_peers == 2){
        f1(program_length, n_peers, args[1], args[2], args[3], args[4]);
    }

    if(n_peers == 3){
        f1(program_length, n_peers, args[1], args[2], args[3], args[4], args[5], args[6]);
    }

    if(n_peers == 4){
        f1(
            program_length, n_peers, args[1], args[2], args[3], args[4], args[5], args[6],
             args[7], args[8]
        );
    }

    free(args);
    
    return 0;


}