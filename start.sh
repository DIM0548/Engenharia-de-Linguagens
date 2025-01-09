#!/bin/bash

# Diretórios
ENTRADAS_DIR="./entradas"
SAIDA_DIR="./saida"
BUILD_DIR="./build"
BUILD_LEX="$BUILD_DIR/lex"
BUILD_YACC="$BUILD_DIR/yacc"

RESULTADO="$SAIDA_DIR/resultado.txt"

# Criação dos diretórios necessários
mkdir -p "$SAIDA_DIR"
mkdir -p "$BUILD_LEX"
mkdir -p "$BUILD_YACC"

# Limpa o arquivo de resultados
> "$RESULTADO"

echo "Compilando o lexer e o parser..."
flex lexer.l
bison parser.y -o y.tab.c -d -v -g 
gcc lex.yy.c y.tab.c -o "$BUILD_DIR/compiler"

# Organiza os arquivos gerados pelo lex
if [ -f lex.yy.c ]; then
    mv lex.yy.c "$BUILD_LEX/"
fi

# Organiza os arquivos gerados pelo yacc
if [ -f y.tab.c ]; then
    mv y.tab.c "$BUILD_YACC/"
fi

if [ -f y.tab.h ]; then
    mv y.tab.h "$BUILD_YACC/"
fi

if [ -f y.output ]; then
    mv y.output "$BUILD_YACC/"
fi

if [ -f y.gv ]; then
    mv y.gv "$BUILD_YACC/"
fi

# Processamento dos arquivos de entrada
for arquivo in "$ENTRADAS_DIR"/*.txt; do
    nome_arquivo=$(basename "$arquivo")
    resultado_arquivo="$SAIDA_DIR/${nome_arquivo%.txt}_resultado.txt"

    echo "Rodando no arquivo: $nome_arquivo" >> "$RESULTADO"

    # Executa o compilador e salva o resultado do arquivo individual
    "$BUILD_DIR/compiler" < "$arquivo" > "$resultado_arquivo"

    # Adiciona o resultado individual ao arquivo de resultado geral
    cat "$resultado_arquivo" >> "$RESULTADO"

    echo "" >> "$RESULTADO"
done

echo "Processamento concluído."
echo "Resultados salvos em $RESULTADO."
echo "Arquivos lex organizados em $BUILD_LEX."
echo "Arquivos yacc organizados em $BUILD_YACC."
