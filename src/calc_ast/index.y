%{
#include "flex_bison.h"
#include "ast.h"
%}

%union {
  struct ast *a;
  double d;
}

%token <d> NUMBER
/* %token OPS */
%token EOL

%type <a> expression factor term

%%

statements: /* nothing */
 | statements expression EOL {
     printf("= %4.4g\n", ast_eval($2));
     ast_free($2);
     printf("> ");
 }
 | statements EOL { printf("> "); }
 ;

expression: factor
 | expression '+' factor { $$ = ast_new('+', $1, $3); }
 | expression '-' factor { $$ = ast_new('-', $1, $3);}
 ;

factor: term
 | factor '*' term { $$ = ast_new('*', $1, $3); }
 | factor '/' term { $$ = ast_new('/', $1, $3); }
 ;

term: NUMBER          { $$ = ast_float($1); }
 | '(' expression ')' { $$ = $2; }
 | '-' term           { $$ = ast_new('M', $2, NULL); }
 ;
%%
