%{
#include "main.h"
#include "ast.h"
%}

/* 定义yylval的类型 */
%union {
    char*       V_String;   // 字符串
    int64_t     V_Integer;  // 整数
    double      V_Float;    // 浮点数
    struct ast* V_AST;      // 分析树
}

/* 定义Token类型 */
%token              T_EOS
%token              T_POW
%token              T_UM
%token              T_ECHO
%token <V_Integer>  T_Integer
%token <V_Float>    T_Float

/* 定义文法类型 */
%type <V_AST>         expression
%type <V_Float>       number

/* 定义运算优先级 */
/* %left      左结合
 * %right     右结合
 * %nonassoc  不可结合
 * 定义靠后的优先级更高
 */
%left '+' '-'
%left '*' '/'
%left T_POW
%nonassoc T_UM

/* 文法的开始符号（省略则默认第一条） */
%start statements

%%

statements:
      /* nothing */
    | statements statement     T_EOS
    | statements /* nothing */ T_EOS
    ;

statement:
    T_ECHO expression {
        printf(">%lf\n", ast_eval($2));
        ast_free($2);
    }
    ;

expression:
      number                     { $$ = ast_float($1); }
    | '(' expression ')'            { $$ = $2; }
    | expression '+' expression     { $$ = ast_new('+', $1, $3); }
    | expression '-' expression     { $$ = ast_new('-', $1, $3); }
    | expression '*' expression     { $$ = ast_new('*', $1, $3); }
    | expression '/' expression     { $$ = ast_new('/', $1, $3); }
    | expression T_POW expression   { $$ = ast_new(T_POW, $1, $3); }
    | '-' expression %prec T_UM     { $$ = ast_new(T_UM , $2, NULL); }
    ;

number:
      T_Integer   { $$ = $1; }
    | T_Float     { $$ = $1; }
    ;

%%
