%{
#include "common.h"
%}

%union {
  // const char* string_t;
  int         operation_t;
  int64_t     integer_t;
  double      float_t;
}
%token <integer_t>    TT_Integer
%token <float_t>      TT_Float
%token <operation_t>  TT_EOS  // End of Statement
%token <operation_t>  TT_Add
%token <operation_t>  TT_Sub
%token <operation_t>  TT_Mul
%token <operation_t>  TT_Div
%token <operation_t>  TT_Pow


%type <float_t>     expression
%type <float_t>     term
%type <float_t>     factor
%type <float_t>     number

%%

commands:
    statement
  | commands statement
  ;

statement: expression TT_EOS {
    printf(">>%lf\n", $1);
};

expression:
    term
  | expression TT_Add term {
    $$ = $1 + $3;
  }
  | expression TT_Sub term {
    $$ = $1 - $3;
  }
  ;

term:
    factor
  | term TT_Mul factor {
      $$ = $1 * $3;
  }
  | term TT_Div factor {
      $$ = $1 / $3;
  }
  ;

factor:
    number
  | factor TT_Pow number {
      $$ = pow($1, $3);
  }
  ;

number:
    TT_Integer { $$ = (double)$1; }
  | TT_Float { $$ = $1; }
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
    exit(1);
}
