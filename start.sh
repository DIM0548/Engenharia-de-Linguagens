#!/bin/bash

# Diretórios
ENTRADAS_DIR="./problemas"
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
# Compila o lexer
if ! flex lexer.l; then
    echo "Erro ao compilar o lexer."
    exit 1
fi

# Compila o parser
if ! bison parser.y -o y.tab.c -d -v -g; then
    echo "Erro ao compilar o parser. Verifique sua gramática."
    exit 1
fi

# Compila o executável do compilador
if ! gcc lex.yy.c y.tab.c -o "$BUILD_DIR/compiler"; then
    echo "Erro ao compilar o compilador. Verifique o código fonte."
    exit 1
fi

# Organiza os arquivos gerados pelo lex
if [ -f lex.yy.c ]; then
    mv lex.yy.c "$BUILD_LEX/"
fi

# Organiza os arquivos gerados pelo yacc
if [ -f y.tab.c ]; then
    mv y.tab.c "$BUILD_YACC/"
else
    echo "Erro: y.tab.c não foi gerado."
    exit 1
fi

if [ -f y.tab.h ]; then
    mv y.tab.h "$BUILD_YACC/"
else
    echo "Erro: y.tab.h não foi gerado."
    exit 1
fi

if [ -f y.output ]; then
    mv y.output "$BUILD_YACC/"
fi

if [ -f y.gv ]; then
    mv y.gv "$BUILD_YACC/"
fi

# Processamento dos arquivos de entrada
for arquivo in "$ENTRADAS_DIR"/*.poti; do
    if [ -f "$arquivo" ]; then
        nome_arquivo=$(basename "$arquivo")
        resultado_arquivo="$SAIDA_DIR/${nome_arquivo%.txt}_resultado.txt"

        echo "Rodando no arquivo: $nome_arquivo" >> "$RESULTADO"

        # Executa o compilador e salva o resultado do arquivo individual
        if "$BUILD_DIR/compiler" < "$arquivo" > "$resultado_arquivo" 2>> "$resultado_arquivo"; then
            cat "$resultado_arquivo" >> "$RESULTADO"
        else
            echo "Erro ao processar o arquivo $nome_arquivo. Consulte $resultado_arquivo para detalhes." >> "$RESULTADO"
        fi

        echo "" >> "$RESULTADO"
    else
        echo "Nenhum arquivo encontrado em $ENTRADAS_DIR."
    fi
done

echo "Processamento concluído."
echo "Resultados salvos em $RESULTADO."
echo "Arquivos lex organizados em $BUILD_LEX."
echo "Arquivos yacc organizados em $BUILD_YACC."
