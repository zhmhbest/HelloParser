%option noyywrap nodefault yylineno
%{
#include "flex_bison.h"
%}

%x COMMENT_LINE
%x COMMENT_BLOC

DIGIT   [0-9]
BLANK   [\ \t]
LINE    (\r\n|\n|\r)

INTEGER         {DIGIT}+
FLOAT           {INTEGER}"."{INTEGER}?
EXPONENT        ({INTEGER}|{FLOAT})([eE][-+]?{INTEGER})

%%

{LINE}  |
";"     { return TT_EOS; }

"+" |
"-" |
"*" |
"/" |
"(" |
")"     { return yytext[0]; }
"**"    { return TT_Pow; }

{INTEGER}   {
    yylval.Integer = atoi(yytext);
    return TT_Integer;
}

{FLOAT}    |
{EXPONENT} {
    yylval.Float = atof(yytext);
    return TT_Float;
}

{BLANK}+                { /* ignore */ }

"/*"                    { BEGIN COMMENT_BLOC; }
<COMMENT_BLOC>.         { /* ignore */ }
<COMMENT_BLOC>{LINE}    { /* ignore */ }
<COMMENT_BLOC>"*/"      { BEGIN INITIAL; }

"//"                    { BEGIN COMMENT_LINE; }
<COMMENT_LINE>.         { /* ignore */ }
<COMMENT_LINE>{LINE}    { BEGIN INITIAL; }

.                       {
    yyerror("unexcept char");
}

%%
