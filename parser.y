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

%token <sValue> ID INT_LITERAL  FLOAT_LITERAL STRING_LITERAL CHAR_LITERAL
%token <sValue> INTEGER
%token <sValue> FUNCTION
%token LCBRACKET RCBRACKET LPAREN RPAREN LBRACKET RBRACKET
%token IF ELSE WHILE RETURN
%token DOT COMMA COLON SEMICOLON ASSIGNMENT
%token GT LT GTEQ LTEQ EQ AND OR PLUS MINUS SLASH MULTIPLY POWER
%token INCREMENT DECREMENT
%token STRING FLOAT VOID

%type <sValue> param type expr varlist decl stmlist stm program arg_list

%start program

%left PLUS MINUS
%left SLASH MULTIPLY
%right POWER

%%

program:
    stmlist { printf("Program Parsed Successfully\n"); }
;

stmlist:
    stm
  | stm stmlist
;

stm:
    func_decl
  | WHILE LPAREN expr RPAREN LCBRACKET stmlist RCBRACKET { printf("WHILE statement\n"); free($3); }
  | IF LPAREN expr RPAREN LCBRACKET stmlist RCBRACKET { printf("IF statement\n"); free($3); }
  | IF LPAREN expr RPAREN LCBRACKET stmlist RCBRACKET ELSE LCBRACKET stmlist RCBRACKET {
        printf("IF-ELSE statement\n");
        free($3);
    }
  | decl SEMICOLON { printf("Variable Declaration\n"); free($1); }
  | ID ASSIGNMENT expr SEMICOLON { printf("Assignment statement\n"); free($1); free($3); }
  | ID LPAREN arg_list RPAREN SEMICOLON {
        if (strcmp($1, "log") == 0) {
            printf("Log statement: Printing %s\n", $3);
        } else {
            printf("Function call: %s(%s)\n", $1, $3);
        }
        free($1); free($3);
    }
  | "log" LPAREN arg_list RPAREN SEMICOLON {
        printf("Log statement: Printing %s\n", $3);
        free($3);
    }
;

varlist:
    ID { $$ = strdup($1); }
  | varlist COMMA ID { asprintf(&$$, "%s, %s", $1, $3); free($1); free($3); }
;

decl:
    varlist COLON type                        { asprintf(&$$, "%s : %s", $1, $3); free($1); free($3); }
  | varlist COLON type ASSIGNMENT expr        { asprintf(&$$, "%s : %s = %s", $1, $3, $5); free($1); free($3); free($5); }
;

func_decl:
    FUNCTION ID LPAREN param_list RPAREN COLON type LCBRACKET stmlist RCBRACKET {
        printf("Function %s returning %s defined\n", $2, $7);
        free($2); free($7);
    }
  | FUNCTION ID LPAREN param_list RPAREN COLON VOID LCBRACKET stmlist RCBRACKET {
        printf("Procedure %s with no return defined\n", $2);
        free($2);
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
  | VOID                       { $$ = strdup("void"); }
;

expr:
    ID                          { $$ = strdup($1); }
  | ID LPAREN arg_list RPAREN   { 
        if (strcmp($1, "log") == 0) {
            printf("Log statement: %s\n", $3);
        } else {
            printf("Function call: %s(%s)\n", $1, $3);
        }
        free($1); free($3);
    }
  | INT_LITERAL                      { $$ = strdup($1); }
  | expr PLUS expr              { asprintf(&$$, "(%s + %s)", $1, $3); free($1); free($3); }
  | expr MINUS expr             { asprintf(&$$, "(%s - %s)", $1, $3); free($1); free($3); }
  | expr MULTIPLY expr          { asprintf(&$$, "(%s * %s)", $1, $3); free($1); free($3); }
  | expr SLASH expr             { asprintf(&$$, "(%s / %s)", $1, $3); free($1); free($3); }
  | expr POWER expr             { asprintf(&$$, "(%s ^ %s)", $1, $3); free($1); free($3); }
  | expr INCREMENT              { asprintf(&$$, "(%s++)", $1); free($1); }
  | expr DECREMENT              { asprintf(&$$, "(%s--)", $1); free($1); }
  | LPAREN expr RPAREN          { $$ = $2; }
;

arg_list:
    expr                        { $$ = strdup($1); }
  | arg_list COMMA expr         { 
        asprintf(&$$, "%s, %s", $1, $3);
        free($1); free($3);
    }
;

%%

int main(void) {
    return yyparse();
}

int yyerror(char *msg) {
    fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    return 0;
}
