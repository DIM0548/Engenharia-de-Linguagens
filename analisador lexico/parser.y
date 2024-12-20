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
  char *sValue; /* Para valores do tipo string */
}

%token <sValue> NUMBER ID
%token <sValue> INTEGER
%token LCBRACKET RCBRACKET LPAREN RPAREN LBRACKET RBRACKET
%token IF ELSE WHILE FUNCTION RETURN
%token DOT COMMA COLON SEMICOLON ASSIGNMENT
%token GT LT GTEQ LTEQ EQ AND OR PLUS MINUS SLASH
%token INCREMENT DECREMENT
%token MULTIPLY

%type <sValue> param type expr

%start program

%left PLUS MINUS
%left SLASH
%left MULTIPLY
%left LPAREN RPAREN

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
  | ID ASSIGNMENT expr SEMICOLON { 
        printf("%s ASSIGN %s\n", $1, $3); 
        free($1); free($3); 
    }
  | expr SEMICOLON { 
        printf("Expression result: %s\n", $1); 
        free($1); 
    }
  | WHILE LCBRACKET stmlist RCBRACKET { 
        printf("WHILE\n"); 
    }
  | IF LPAREN expr RPAREN LCBRACKET stmlist RCBRACKET { 
        printf("IF statement\n");
        free($3);
    }
;


func_decl:
  FUNCTION ID LPAREN param_list RPAREN COLON type LCBRACKET stmlist RCBRACKET {
    printf("Function %s defined\n", $2);
    free($2);
  }
;

param_list:
  /* Vazio */
  | param { printf("Single parameter\n"); }
  | param COMMA param_list { printf("Parameter list\n"); }
;

param:
  ID COLON type { printf("Parameter %s of type %s\n", $1, $3); free($1); free($3); }
;

type:
  INTEGER { $$ = strdup("int"); }
  | INTEGER LBRACKET RBRACKET { $$ = strdup("int[]"); }
;

expr:
    ID                          { $$ = strdup($1); }
  | NUMBER                      { $$ = strdup($1); }
  | expr PLUS expr              { 
        asprintf(&$$, "(%s + %s)", $1, $3); 
        free($1); free($3); 
    }
  | expr MINUS expr             { 
        asprintf(&$$, "(%s - %s)", $1, $3); 
        free($1); free($3); 
    }
  | expr MULTIPLY expr          { 
        asprintf(&$$, "(%s * %s)", $1, $3); 
        free($1); free($3); 
    }
  | expr SLASH expr             { 
        asprintf(&$$, "(%s / %s)", $1, $3); 
        free($1); free($3); 
    }
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
