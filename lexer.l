%{
   #include <stdio.h>
   #include "y.tab.h"

   int count_lines = 0;
%}
%option yylineno

alpha             [a-zA-Z]
digit             [0-9]


intLiteral        [-+]?{digit}+
floatLiteral      {intLiteral}"."{digit}+
stringLiteral     \"[^\n\"]+\"
charLiteral       \'[^\\']\'
identifier        {alpha}({alpha}|{digit}|_)*

%%

"{"                     { return yytext[0]; }
"}"                     { return yytext[0]; }
"("                     { return yytext[0]; }
")"                     { return yytext[0]; }
"["                     { return yytext[0]; }
"]"                     { return yytext[0]; }
"."                     { return yytext[0]; }
","                     { return yytext[0]; }
":"                     { return yytext[0]; }
";"                     { return yytext[0]; }

"if"                    { return IF; }
"else"                  { return ELSE; }
"while"                 { return WHILE; }
"function"              { return FUNCTION; }
"return"                { return RETURN; }
"int"                   { return INT; }
"float"                 { return FLOAT; }
"void"                  { return VOID; }
"="                     { return ASSIGNMENT; }
">"                     { return GT; }
"<"                     { return LT; }
">="                    { return GTEQ; }
"<="                    { return LTEQ; }
"=="                    { return EQ; }
"&&"                    { return AND; }
"||"                    { return OR; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"++"                    { return INCREMENT; }
"--"                    { return DECREMENT; }
"^"                     { return POWER; }
"/"                     { return SLASH; }
"*"                     { return MULTIPLY; }
"log"                   { return LOG; }
{intLiteral}            { yylval.sValue = strdup(yytext); return INT_LITERAL; }
{floatLiteral}          { yylval.sValue = strdup(yytext); return FLOAT_LITERAL; }
{stringLiteral}         { yylval.sValue = strdup(yytext); return STRING_LITERAL; }
{charLiteral}           { yylval.sValue = strdup(yytext); return CHAR_LITERAL; }
{identifier}            { yylval.sValue = strdup(yytext); return ID; }
"//"[^\n]*              ; // Single line comment
"/"([^]|\+[^/])\+"/"    ; // Multi line comment
[ \t\r]*                ; // Ignora espaços em branco
[\n]                    { count_lines++; } // Conta quebra de linha
.                       { printf("Invalid character at line %d: '%s' (ASCII %d)\n", yylineno, yytext, yytext[0]); }

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif
