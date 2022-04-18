
### 环境准备

**Windows**：

- [MinGW-W64 x86_64-posix-seh 7z](https://sourceforge.net/projects/mingw-w64/files/mingw-w64/)
- [LibIntl for Windows Binaries Zip](http://gnuwin32.sourceforge.net/packages/libintl.htm)
- [LibIconv for Windows Binaries Zip](http://gnuwin32.sourceforge.net/packages/libiconv.htm)
- [Flex for Windows Binaries Zip](http://gnuwin32.sourceforge.net/packages/flex.htm)
- [Bison for Windows Binaries Zip](http://gnuwin32.sourceforge.net/packages/bison.htm)

**Ubuntu/Debian**：

```bash
sudo apt install build-essential
sudo apt install flex bison
```

### Flex

```cpp
/* 定义部分 */
%%
/* 规则部分 */
%%
/* 附加代码 */
```

#### Flex定义部分

```cpp
/* 参数开关
 * %option ...
 *
 * nodefault : 输入无法被匹配时报错
 * yylineno  : 解析时记录行号
 * noyywrap  : 不启用yywrap函数
 *
 */
%option nodefault yylineno


/* 代码定义 */
%{
    #include <stdio.h>
    #include <string.h>

    FILE* yyin;         // （内置）读取的输入
    char* yytext;       // （内置）当前token的文本
    int yylex(void);    // （内置）解析方法
    void* yylval;       // （自定）当前token的值

    // 以下内容需要开启yywrap
    #define YY_WRAP_EOF 1
    #define YY_WRAP_NXT 0
    int yywrap(void);
%}


/* 状态声明 */
%x COMMENT
/* INITIAL : 默认状态（不需要声明）
 * COMMENT : 注释状态（由上述代码定义）*/


/* 正则表达式
 * "..."    : 原样匹配字符串
 * {...}    : 已定义的样式
 * ...{n,m} : ...重复n到m次
 */
LINE    (\r\n|\n|\r)
INTEGER ([1-9][0-9]*|0)
```

#### Flex规则部分

```cpp
正则表达式 | "字符串" {
    // yytext: 正则规则匹配到的字符串（读取此值）
    // yylval: 匹配的字符串所代表的值（写入此值）
    return TokenType
}

"#"             { BEGIN COMMENT; /* 切换到注释状态 */ }
<COMMENT>.      { /* IGNORE */ }
<COMMENT>{LINE} { BEGIN INITIAL; /* 切换到默认状态 */ }
```

#### Flex附加代码

```cpp
// 以下内容需要开启yywrap
int yywrap() {
    // 读取全部结束
    yyin = NULL;
    return YY_WRAP_EOF;

    // Or

    // 继续读取其它文件
    yyin = fopen("...", "r");
    return YY_WRAP_NXT;
}


int main(char** argv) {
    yyin = fopen("./input.txt", "r");

    int token;
    while( token = yylex() ) {
        printf("line=%d, type=%X, text=[%s]\n", yylineno, token, yytext);
    }

    fclose(yyin);
}
```

### Bison

```cpp
/* 定义部分 */
%%
/* 文法部分 */
%%
/* 附加代码 */
```

#### Bison定义部分

```cpp
/* 代码定义 */
%{
    //
%}


/* 定义YYSTYPE（最后生成到头文件）
 *
 * YYSTYPE yylval
 *
 */
%union {
    char*       V_String;   // 字符串
    int64_t     V_Integer;  // 整数
    double      V_Float;    // 浮点数
    struct ast* V_AST;      // 分析树
}


/* 定义Token返回类型（最后生成到头文件）
 *
 * %token TokenType
 * %token <ValueType> TokenType
 *
 */
%token              T_EOS     // End of Statement
%token              T_POW     // 次幂
%token              T_UM      // 取负（unitary minus）
%token <V_Integer>  T_Integer
%token <V_Float>    T_Float


/* 定义文法类型（文法由多个Token或子文法组成）
 *
 * %type <ValueType> Grammar
 *
 */
%type <V_AST>       expression
%type <V_Float>     number


/* 定义运算优先级（行数靠后的优先级更高）
 *
 * %left      左结合
 * %right     右结合
 * %nonassoc  不可结合
 *
 */
%left '+' '-'
%left '*' '/'
%nonassoc T_UM


/* 文法的开始符号（省略则默认第一条） */
%start statements
```

#### Bison文法部分

```bison
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
      number                        { $$ = ast_float($1); }
    | '(' expression ')'            { $$ = $2; }
    | expression '+'   expression   { $$ = ast_new('+', $1, $3); }
    | expression '-'   expression   { $$ = ast_new('-', $1, $3); }
    | expression '*'   expression   { $$ = ast_new('*', $1, $3); }
    | expression '/'   expression   { $$ = ast_new('/', $1, $3); }
    | expression T_POW expression   { $$ = ast_new(T_POW, $1, $3); }
    | '-' expression %prec T_UM     { $$ = ast_new(T_UM, $2, NULL); }
    ;

number:
      TT_Integer { $$ = $1; }
    | TT_Float   { $$ = $1; }
    ;
```

#### Bison附加代码

```cpp
int main()
{
    yyin = fopen("./input.txt", "r");
    yyparse();
    fclose(yyin);
    printf("bye\n");
}
```
