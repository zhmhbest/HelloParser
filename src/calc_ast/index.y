%{
#include "flex_bison.h"
#include "ast.h"
%}

%union {
  struct ast *a;
  double d;
}

/* declare tokens */
%token <d> NUMBER
%token EOL

%type <a> exp factor term

%%

calclist: /* nothing */
 | calclist exp EOL {
     printf("= %4.4g\n", ast_eval($2));
     ast_free($2);
     printf("> ");
 }
 | calclist EOL { printf("> "); }
 ;

exp: factor
 | exp '+' factor { $$ = ast_new('+', $1, $3); }
 | exp '-' factor { $$ = ast_new('-', $1, $3);}
 ;

factor: term
 | factor '*' term { $$ = ast_new('*', $1, $3); }
 | factor '/' term { $$ = ast_new('/', $1, $3); }
 ;

term: NUMBER   { $$ = ast_float($1); }
 | '(' exp ')' { $$ = $2; }
 | '-' term    { $$ = ast_new('M', $2, NULL); }
 ;
%%
