# SBT2
# Carregador de Programa

Este projeto implementa um **carregador de programa** que aloca um programa em um ou mais blocos de memória especificados na linha de comando. Ele verifica se o programa cabe na memória disponível e exibe uma mensagem informando os endereços utilizados ou se a alocação falhou.

## Como Compilar e Executar

### **Compilação**
Para compilar o programa, siga os seguintes passos:

1. **Montar o arquivo Assembly**:
   ```bash
   nasm -f elf -o loader_counter.o loader_counter.asm
   ```
   O formato **ELF** (Executable and Linkable Format) é usado para compatibilidade com o GCC.

2. **Compilar e ligar com o arquivo C**:
   ```bash
   gcc -m32 -o carregador carregador.c loader_counter.o -no-pie
   ```
   - **`-m32`**: Garante que o programa seja compilado em **32 bits**, compatível com o **NASM ELF**.
   - **`-no-pie`**: Evita warnings de endereço relativo no Assembly.

### **Execução**
O programa deve ser executado passando argumentos na linha de comando:
```bash
./carregador <tamanho_do_programa> <endereco1> <tamanho_memoria1> [<endereco2> <tamanho_memoria2> ...]
```

- **`<tamanho_do_programa>`**: O tamanho do programa a ser carregado.
- **`<endereco>` `<tamanho_memoria_disponivel>`**: Pares de endereços de memória disponíveis.
- É possível passar até **4 pares** de endereços e tamanhos.

### **Exemplo de Uso**
```bash
./carregador 125 100 500 4000 300 20000 125 30000 345
```

## Possíveis Saídas do Programa
O programa pode retornar **três cenários diferentes**:

1. **Memória insuficiente**: Se o programa **não couber** em nenhum bloco de memória disponível, a saída será:
   ```
   nao foi possivel carregar o programa na memoria, nao há espaco
   ```

2. **O programa cabe em um único bloco**: Se o programa couber em um único par `<endereco> <tamanho_memoria_disponivel>`, será exibido:
   ```
   o programa foi carregado nos seguintes par(es) <endereco_inicial> <endereco_final>
   ```

3. **O programa precisa ser dividido**: Se for necessário distribuir o programa em múltiplos blocos de memória, a saída será semelhante a:
   ```
   o programa foi carregado nos seguintes par(es) <endereco_inicial> <endereco_final>
   100 500
   4000 4300
   20000 20125
   ```
   Cada linha indica um **endereço inicial** e um **endereço final** onde o programa foi alocado.

## Estrutura do Projeto
O projeto é composto pelos seguintes arquivos:

- **`carregador.c`**: Código principal em C, responsável por receber os argumentos e chamar a função Assembly.
- **`loader_counter.asm`**: Código Assembly que verifica e aloca o programa na memória.
- **`README.md`**: Este arquivo com as instruções de uso.

## Observações Técnicas
- O Assembly **usa registradores** para manipular os endereços e tamanhos.
- A lógica principal está na função `f1` dentro do Assembly.
- O programa **calcula se há memória suficiente** e decide **onde carregar o programa**.
- A flag `-m32` é **obrigatória** pois o Assembly está escrito para arquitetura **x86 de 32 bits**.
- A flag `-no-pie` é usada para **evitar warnings** de endereço relativo.

## Autoria
Desenvolvido como parte de um projeto de **Sistemas de Software Básico**. Para dúvidas ou sugestões, abra uma issue no repositório.

---
📌 **Agora, seu programa tem um README pronto para o GitHub!** 🚀

