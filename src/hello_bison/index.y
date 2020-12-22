%{
#include "flex_bison.h"
%}

/* 定义yylval的类型 */
%union {
  const char* string_t;
  int64_t     integer_t;
  double      float_t;
}

/* 定义Token类型 */
%token TT_EOS  // End of Statement
%token TT_Pow

/* 定义返回指定Token时yylval的类型 */
%token <integer_t>    TT_Integer
%token <float_t>      TT_Float

/* 定义文法类型 */
%type <float_t>     expression
%type <float_t>     number

/* 定义运算优先级 */
/* %left      左结合
 * %right     右结合
 * %nonassoc  不可结合
 */
%left '+' '-'
%left '*' '/'
%left TT_Pow

/* 文法的开始符号（省略则默认第一条） */
%start statements

%%

statements:
    /* nothing */
  | statements statement
  | statements TT_EOS    /* 空语句 */
  ;

statement: expression TT_EOS {
    printf(">%lf\n", $1);
};

expression:
    number
  | expression '+' expression  { $$ = $1 + $3; }
  | expression '-' expression  { $$ = $1 - $3; }
  | expression '*' expression  { $$ = $1 * $3; }
  | expression '/' expression  { $$ = $1 / $3; }
  | expression TT_Pow expression  { $$ = pow($1, $3); }
  | '(' expression ')'            { $$ = $2; }
  | '-' expression             { $$ = -$2; }
  ;

number:
    TT_Integer { $$ = (double)$1; }
  | TT_Float   { $$ = $1; }
  ;

%%
