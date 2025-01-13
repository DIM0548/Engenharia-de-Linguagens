# Compilador para Linguagem (Nome)

Este projeto consiste em um compilador para uma linguagem  (nome), desenvolvido com ferramentas como **Flex**, **Bison**, e **GCC**. O compilador suporta análise léxica, análise sintática e geração de código intermediário em **C**.

## 📋 Pré-requisitos

Para executar este projeto, os seguintes programas devem estar instalados no sistema:

- **GCC**: Compilador de C.
- **Flex**: Ferramenta para análise léxica.
- **Bison**: Gerador de analisadores sintáticos.
- **Make** (opcional): Para automatizar a compilação.
- **Graphviz** (opcional): Para visualização de arquivos `.gv`.

### 🛠️ Instalação dos Programas

- No **Linux/Ubuntu**:
    ```bash
    sudo apt update
    sudo apt install gcc flex bison make graphviz
## 🚀 Como Executar
- Clone o repositório:
    ```bash
    git clone https://github.com/DIM0548/Engenharia-de-Linguagens.git <PASTA_DO_REPOSITORIO>
    cd <PASTA_DO_REPOSITORIO>
> Arquivo de entrada: Coloque os arquivos de entrada na <a href="./entradas/" style="color:gold;">pasta entradas</a> com extensão `.txt`.
- Compile o projeto:
    ```bash
    sh start.sh
> Os resultados estarão na <a href="./saida/" style="color:gold;">pasta saida</a>.
- Visualize a estrutura de gramática (opcional): Converta o arquivo .gv gerado para uma imagem:
    ```bash
    dot -Tpng build/yacc/y.gv -o build/yacc/grammar.png
## 📂 Estrutura de Diretórios

    .
    ├── entradas/       # 📥 Arquivos de entrada (programas na linguagem personalizada)
    ├── saida/          # 📤 Resultados do compilador  
    ├── build/          # 🔧 Arquivos gerados (compilador e intermediários) 
    │   ├── lex/        # 📜 Arquivos gerados pelo Flex  
    │   └── yacc/       # 🛠️ Arquivos gerados pelo Bison 
    ├── lexer.l         # 🖊️ Analisador léxico (Flex) 
    ├── parser.y        # 📐 Analisador sintático (Bison) 
    ├── start.sh        # 🤖 Script para automação 
    └── README.md       # 📘 Documentação do projeto

## ✅ Lista de Afazeres

### 📄 Documentação do Compilador
- [ ] **Introdução**: Visão geral do projeto.
- [ ] **Design da Implementação**:
    - [ ] Transformação do código-fonte em unidades léxicas.
    - [ ] Representação de símbolos e tabela de símbolos.
    - [ ] Tratamento de estruturas condicionais e de repetição.
    - [ ] Tratamento de subprogramas.
    - [ ] Verificações de tipos, faixas e duplicidade de declaração.
- [ ] **Instruções de Uso**: Como compilar e rodar o programa.

---

### 💻 Implementação do Compilador
- [ ] **Programas escritos na linguagem personalizada**:
    - [ ] **Problema 1**: Avaliação de expressão matemática.
    - [ ] **Problema 2**: Classificação de números em intervalos.
    - [ ] **Problema 3**: Operações com matrizes.
    - [ ] **Problema 4**: Subprogramas com números racionais.
    - [ ] **Problema 5**: Cálculo do MDC com passagem por referência.
    - [ ] **Problema 6**: Operações com árvores binárias de busca.

---

### 🛠️ Funcionalidades do Compilador
- [ ] **Erro Léxico e Sintático**: Detecção e tratamento de erros.
- [ ] **Variáveis**: Detectar omissões, duplicidade no mesmo escopo e escopos distintos.
- [ ] **Expressões**: Testar coerções e compatibilizações de tipos.
- [ ] **Passagem de Parâmetros**: Garantir transmissão correta e integridade após retorno.

---

### 🕒 Prazos

* Data final: **21 de janeiro de 2025, até 14h30.**
* Submissão: Compactar todos os arquivos e enviar no SIGAA.


## 📝 Autores

- **Allyson G. S. Carmo** - [AllysonGustavo1](https://github.com/AllysonGustavo1)
- **Edivânia P. Oliveira** - [edivaniap](https://github.com/edivaniap)
- **Ianco S. Oliveira** - [ianco-so](https://github.com/ianco-so)
- **João V. S. Saturnino** - [jv]()
