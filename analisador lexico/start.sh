#!/bin/bash
ENTRADAS_DIR="./entradas"

RESULTADO="resultado.txt"

> "$RESULTADO"

echo "Compilando o lexer e o parser..."
flex lexer.l
bison parser.y -o y.tab.c -d -v -g 
gcc lex.yy.c y.tab.c -o compiler

for arquivo in "$ENTRADAS_DIR"/*.txt; do
    nome_arquivo=$(basename "$arquivo")

    echo "Rodando no arquivo: $nome_arquivo" >> "$RESULTADO"

    ./compiler < "$arquivo" >> "$RESULTADO"

    echo "" >> "$RESULTADO"
done

echo "Processamento concluído. Resultados salvos em $RESULTADO."
