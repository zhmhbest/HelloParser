%option noyywrap nodefault yylineno

%{
#include "flex_bison.h"
%}

%x COMMENT_LINE

DIGIT       [0-9]
INTEGER     {DIGIT}+
FLOAT       {INTEGER}"."{INTEGER}?
EXPONENT    ([eE][-+]?{INTEGER})
NUMBER      ({INTEGER}|{FLOAT}){EXPONENT}?

BLANK       [\ \t]
LINE        (\r\n|\n|\r)

%%
"+" |
"-" |
"*" |
"/" |
"(" |
")" { return yytext[0]; }

{NUMBER}                { yylval.d = atof(yytext); return NUMBER; }

{LINE}                  { return EOL; }
{BLANK}+                { /* ignore */ }

"//"                    { BEGIN COMMENT_LINE; }
<COMMENT_LINE>.         { /* ignore */ }
<COMMENT_LINE>{LINE}    { BEGIN INITIAL; return EOL; }

. {
    fprintf(stderr, "Unexcept char '%s' at line: %d.\n", yytext, yylineno);
    exit(1);
}
%%
