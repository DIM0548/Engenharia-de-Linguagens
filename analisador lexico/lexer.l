%{
#include <stdio.h>
#include "y.tab.h"
%}

%%

[ \t\n\r]               ;
"//"[^\n]*            ;
[0-9]+                { yylval.sValue = strdup(yytext); return NUMBER; }
"{"                   { return LCBRACKET; }
"}"                   { return RCBRACKET; }
"("                   { return LPAREN; }
")"                   { return RPAREN; }
"["                   { return LBRACKET; }
"]"                   { return RBRACKET; }
"if"                  { return IF; }
"else"                { return ELSE; }
"while"               { return WHILE; }
"function"            { return FUNCTION; }
"return"              { return RETURN; }
"int"                 { return INTEGER; }
"float"               { return FLOAT; }
"."                   { return DOT; }
","                   { return COMMA; }
":"                   { return COLON; }
";"                   { return SEMICOLON; }
"="                   { return ASSIGNMENT; }
":="                  { return ASSIGNMENT; }
">"                   { return GT; }
"<"                   { return LT; }
">="                  { return GTEQ; }
"<="                  { return LTEQ; }
"=="                  { return EQ; }
"&&"                  { return AND; }
"||"                  { return OR; }
"+"                   { return PLUS; }
"-"                   { return MINUS; }
"++"                  { return INCREMENT; }
"--"                  { return DECREMENT; }
"/"                   { return SLASH; }
"*"                   { return MULTIPLY; }
[a-zA-Z][a-zA-Z0-9]*  { yylval.sValue = strdup(yytext); return ID; }
.                     { printf("Invalid character at line %d: '%s' (ASCII %d)\n", yylineno, yytext, yytext[0]); }

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif
