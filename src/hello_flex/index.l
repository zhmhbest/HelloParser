%option noyywrap yylineno

%{
    #include <stdio.h>
    #include <string.h>
    FILE *yyin;
    char *yytext;
    int yylineno;
    // void yyrestart(FILE*);
    // extern int yylval;
    int yylex(void);

    // #define YY_WRAP_EOF 1
    // #define YY_WRAP_NXT 0
    // int yywrap(void);

    // Type
    enum yytokentype {
        TT_Indentifier = 258,
        TT_Integer,
        TT_Float,
        TT_Operation
    };
%}

/* 状态声明
 * INITIAL 默认状态名
 * %x 自定义的状态名
 */
%x COMMENT_LINE

/* 正则表达式
 * "..."   原样匹配
 * {...}   已定义的样式
 * .../... 预判/右侧内容，但返回给分析器继续匹配
 * 其它与JS正则一致
 */
LETTER  [_A-Za-z]
DIGIT   [0-9]
WORD    [_A-Za-z0-9]
BLANK   [\ \f\r\t\v]
LINE    (\r\n|\n|\r)

IDENTIFIER      {LETTER}{WORD}*
INTEGER         {DIGIT}+
FLOAT           {INTEGER}\.{INTEGER}

%%

{IDENTIFIER}            { return TT_Indentifier; }
"-"?{INTEGER}           { return TT_Integer; }
"-"?{FLOAT}             { return TT_Float; }
"="                     { return TT_Operation; }
{LINE}                  { /* ignore */ }
{BLANK}+                { /* ignore */ }

"#"                     { BEGIN COMMENT_LINE; }
<COMMENT_LINE>.         { /* ignore */ }
<COMMENT_LINE>{LINE}    { BEGIN INITIAL; }

.                       { printf("err(%s)\n", yytext); }

%%

// int yywrap() {
//     // YY_WRAP_EOF: 读取全部结束
//     // YY_WRAP_NXT: 如果要接着读其它文件，在这里fopen，并将文件指针赋给yyin，并返回YY_WRAP_NXT
//     yyin = NULL
//     return YY_WRAP_EOF;
// }

int main() {
    yyin = fopen("./input.txt", "r");
    // yyrestart(fopen("./input.txt", "r"));

    int tok;
    while( tok = yylex() ) {
        printf("line=%d, type=%X, text=[%s]\n", yylineno, tok, yytext);
    }

    fclose(yyin);
}
