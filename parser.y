%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char *yytext;
%}

%union {
  char *sValue;
}

%token <sValue> NUMBER ID
%token <sValue> INTEGER
%token <sValue> FUNCTION
%token LCBRACKET RCBRACKET LPAREN RPAREN LBRACKET RBRACKET
%token IF ELSE WHILE RETURN
%token DOT COMMA COLON SEMICOLON ASSIGNMENT
%token GT LT GTEQ LTEQ EQ AND OR PLUS MINUS SLASH
%token INCREMENT DECREMENT
%token MULTIPLY
%token FLOAT

%type <sValue> param type expr varlist decl stmlist stm program

%start program

%left PLUS MINUS
%left SLASH MULTIPLY

%%

program:
    stmlist { printf("PROG\n"); }
;

stmlist:
    stm { printf("STM\n"); }
  | stm stmlist { printf("STM-STMLIST\n"); }
;

stm:
    func_decl { printf("FUNCTION DECL\n"); }
  | WHILE LPAREN expr RPAREN LCBRACKET stmlist RCBRACKET { printf("WHILE statement\n"); free($3); }
  | IF LPAREN expr RPAREN LCBRACKET stmlist RCBRACKET { printf("IF statement\n"); free($3); }
  | IF LPAREN expr RPAREN LCBRACKET stmlist RCBRACKET ELSE LCBRACKET stmlist RCBRACKET {
        printf("IF-ELSE statement\n");
        free($3);
    }
  | decl SEMICOLON { printf("Variable Declaration\n"); free($1); }
;

varlist:
    ID { $$ = strdup($1); }
  | varlist COMMA ID { asprintf(&$$, "%s, %s", $1, $3); free($1); free($3); }
;

decl:
    varlist COLON type { asprintf(&$$, "%s : %s", $1, $3); free($1); free($3); }
;

func_decl:
    FUNCTION ID LPAREN param_list RPAREN COLON type LCBRACKET stmlist RCBRACKET {
        printf("Function %s returning %s defined\n", $2, $7);
        free($2); free($7);
    }
;

param_list:
    /* vazio */
  | param
  | param COMMA param_list
;

param:
    ID COLON type { printf("Parameter %s of type %s\n", $1, $3); free($1); free($3); }
;

type:
    INTEGER                    { $$ = strdup("int"); }
  | INTEGER LBRACKET RBRACKET  { $$ = strdup("int[]"); }
  | FLOAT                      { $$ = strdup("float"); }
;

expr:
    ID                          { $$ = strdup($1); }
  | ID DOT ID LPAREN expr RPAREN {
        asprintf(&$$, "%s.%s(%s)", $1, $3, $5);
        free($1); free($3); free($5);
    }
  | NUMBER                      { $$ = strdup($1); }
  | expr PLUS expr              { asprintf(&$$, "(%s + %s)", $1, $3); free($1); free($3); }
  | expr MINUS expr             { asprintf(&$$, "(%s - %s)", $1, $3); free($1); free($3); }
  | expr MULTIPLY expr          { asprintf(&$$, "(%s * %s)", $1, $3); free($1); free($3); }
  | expr SLASH expr             { asprintf(&$$, "(%s / %s)", $1, $3); free($1); free($3); }
  | LPAREN expr RPAREN          { $$ = $2; }
;

%%

int main(void) {
    return yyparse();
}

int yyerror(char *msg) {
    fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    return 0;
}
