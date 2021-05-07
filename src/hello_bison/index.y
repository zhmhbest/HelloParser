%{
#include "flex_bison.h"
#include "ast.h"
%}

/* 定义yylval的类型 */
%union {
  int64_t     Integer;
  double      Float;
  struct ast* AST;
}

/* 定义Token类型 */
%token TT_EOS       // End of Statement
%token TT_Pow       // 次幂
%token TT_Neg       // 取负（unitary minus）
%token TT_ECHO      // 关键字：echo

/* 定义返回指定Token时yylval的类型 */
%token <Integer>    TT_Integer
%token <Float>      TT_Float

/* 定义文法类型 */
%type <AST>         expression
%type <Float>       number

/* 定义运算优先级 */
/* %left      左结合
 * %right     右结合
 * %nonassoc  不可结合
 * 定义靠后的优先级更高
 */
%left '+' '-'
%left '*' '/'
%left TT_Pow
%nonassoc TT_Neg

/* 文法的开始符号（省略则默认第一条） */
%start statements

%%

statements:
    /* nothing */
  | statements statement     TT_EOS
  | statements /* nothing */ TT_EOS
  ;

statement:
    TT_ECHO expression {
        printf(">%lf\n", ast_eval($2));
        ast_free($2);
    }
  ;

expression:
    number                        { $$ = ast_float($1); }
  | '(' expression ')'            { $$ = $2; }
  | expression '+' expression     { $$ = ast_new('+', $1, $3); }
  | expression '-' expression     { $$ = ast_new('-', $1, $3); }
  | expression '*' expression     { $$ = ast_new('*', $1, $3); }
  | expression '/' expression     { $$ = ast_new('/', $1, $3); }
  | expression TT_Pow expression  { $$ = ast_new(TT_Pow, $1, $3); }
  | '-' expression %prec TT_Neg   { $$ = ast_new(TT_Neg, $2, NULL); }
  ;

number:
    TT_Integer { $$ = (double)$1; }
  | TT_Float   { $$ = $1; }
  ;

%%
