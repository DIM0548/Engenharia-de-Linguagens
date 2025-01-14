%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  #include "./lib/check.h"

  int yylex(void);
  int yyerror(char *s);
  extern int yylineno;
  extern char *yytext;
%}

%union {
  char *sValue;
}
// TERMINALS
%token <sValue> ID                                                          // IDENTIFIER
%token <sValue> INT_LITERAL FLOAT_LITERAL STRING_LITERAL CHAR_LITERAL       // LITERALS
%token <sValue> FUNCTION                                                    // FUNCTION
%token LOG                                                                  // LOG and PRINT
%token LCBRACKET RCBRACKET LPAREN RPAREN LBRACKET RBRACKET                  // BRACKETS AND PARENTHESES
%token IF ELSE WHILE RETURN                                                 // CONTROL FLOW         
%token DOT COMMA COLON SEMICOLON                                            // PUNCTUATION
%token GT LT GTEQ LTEQ EQ AND OR                                            // RELATIONAL OPERATORS (GREATER, LESS, GREATER OR EQUAL, LESS OR EQUAL, EQUAL, AND, OR)
%token PLUS MINUS SLASH MULTIPLY POWER ASSIGNMENT                           // BINARY OPERATORS and ASSIGNMENT
%token INCREMENT DECREMENT                                                  // UNARY OPERATORS
%token STRING FLOAT VOID INT                                                // TYPES


// NON-TERMINALS
%type <sValue> param type expr varlist decl stmlist stm program arg_list


// OPERATOR PRECEDENCE
%left PLUS MINUS
%left SLASH MULTIPLY
%right POWER

// START SYMBOL
%start program
%%

program:
  stmlist { 
    check_main();  
    printf("Program Parsed Successfully\n"); 
  }
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
  | LOG LPAREN arg_list RPAREN SEMICOLON {
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
    INT                    { $$ = strdup("int"); }
  | INT LBRACKET RBRACKET  { $$ = strdup("int[]"); } // TODO: Implementar arrays
  | FLOAT                      { $$ = strdup("float"); }
  | VOID                       { $$ = strdup("void"); }
;

expr:
    ID                          { $$ = strdup($1); }
  | FLOAT_LITERAL               { $$ = strdup($1); }
  | INT_LITERAL                 { $$ = strdup($1); }
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
  | STRING_LITERAL             { $$ = strdup($1); }
;


%%

int main(void) {
    return yyparse();
}

int yyerror(char *msg) {
    fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    return 0;
}
