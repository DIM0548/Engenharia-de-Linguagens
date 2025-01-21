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
/* %token LCBRACKET RCBRACKET LPAREN RPAREN LBRACKET RBRACKET               // BRACKETS AND PARENTHESES */
%token IF ELSE WHILE RETURN                                                 // CONTROL FLOW         
/* %token DOT COMMA COLON SEMICOLON                                         // PUNCTUATION */
%token GT LT GTEQ LTEQ EQ AND OR                                            // RELATIONAL OPERATORS (GREATER, LESS, GREATER OR EQUAL, LESS OR EQUAL, EQUAL, AND, OR)
%token PLUS MINUS SLASH MULTIPLY POWER ASSIGNMENT                           // BINARY OPERATORS and ASSIGNMENT
%token INCREMENT DECREMENT                                                  // UNARY OPERATORS
%token STRING FLOAT VOID INT STRUCT                                         // TYPES


// NON-TERMINALS
%type <sValue> param type expr varlist  stmlist stm program arg_list
%type <sValue> declarations declaration var_decl struct_decl func_decl // DECLARATIONS ex: a: int; function main(): void;

// OPERATOR PRECEDENCE
%left PLUS MINUS
%left SLASH MULTIPLY
%right POWER

// START SYMBOL
%start program
%%

program:
  /* stmlist { 
    check_main();  
    printf("Program Parsed Successfully\n"); 
  } */
  declarations { 
    check_main();  
    printf("Program Parsed Successfully\n"); 
  }
;


declarations: 
  declaration                 {}
  | declaration declarations  {}
;

declaration: 
  var_decl      { printf("Variable Declaration\n"); }
  | func_decl   { printf("Function Declaration\n"); }
  | struct_decl { printf("Struct Declaration\n"); }
;

stmlist:
    stm
  | stm stmlist
;

var_decl: 
  varlist ':' type ';'                    { asprintf(&$$, "%s : %s", $1, $3); free($1); free($3); }
  | varlist ':' type ASSIGNMENT expr ';'  { asprintf(&$$, "%s : %s = %s", $1, $3, $5); free($1); free($3); free($5); }
;

func_decl: 
  FUNCTION ID '(' param_list ')' ':' type '{' stmlist '}' 
  {
    printf("Function %s returning %s\n", $2, $7);
    free($2); free($7);
  }
  /* | FUNCTION ID '(' param_list ')' ':' VOID '{' stmlist '}' // vOID não é um type?
  {
    printf("Procedure %s with no return defined\n", $2);
    free($2);
  } */
  | FUNCTION ID '(' ')' ':' type '{' stmlist '}' 
  {
    printf("Function %s returning %s defined\n", $2, $6);
    free($2); free($6);
  }
;

struct_decl:
  STRUCT ID
  {
    check_struct($2);
    // Do something abouth the scope
  } 
  '{' var_decl '}' //TODO: ver se é melhor var_decl ou talvez criar um novo tipo de declaração (struct_var_decl, talvez) 
  { 
    printf("Struct %s defined\n", $2); 
    free($2); 
  }
;
varlist:
  ID                { $$ = strdup($1); }
  | varlist ',' ID  { asprintf(&$$, "%s, %s", $1, $3); free($1); free($3); }
;

stm:
  var_decl { printf("Variable Declaration\n"); free($1); }
  | WHILE '(' expr ')' '{' stmlist '}' { printf("WHILE statement\n"); free($3); }
  | IF '(' expr ')' '{' stmlist '}' { printf("IF statement\n"); free($3); }
  | IF '(' expr ')' '{' stmlist '}' ELSE '{' stmlist '}' {
      printf("IF-ELSE statement\n");
      free($3);
    }
  | expr ';' { printf("Expression statement\n"); free($1); }
  | ID ASSIGNMENT expr ';' { printf("Assignment statement\n"); free($1); free($3); } // Não é melhorar escreever uma estrutura de atribuição?
  | LOG '(' arg_list ')' ';' {
      printf("Log statement: Printing %s\n", $3);
      free($3);
    }
;

param_list:
    /* vazio */
  | param
  | param ',' param_list
;

param:ID ':' type { printf("Parameter %s of type %s\n", $1, $3); free($1); free($3); };

type:
  INT           { $$ = strdup("int"); }
  | INT '[' ']' { $$ = strdup("int[]"); } // TODO: Implementar arrays
  | FLOAT       { $$ = strdup("float"); }
  | VOID        { $$ = strdup("void"); }
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
  | '(' expr ')'          { $$ = $2; }
;

arg_list:
    expr                        { $$ = strdup($1); }
  | arg_list ',' expr         { 
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
