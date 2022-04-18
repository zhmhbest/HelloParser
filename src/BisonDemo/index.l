%option nodefault yylineno noyywrap

%{
    #include "main.h"
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
";"     { return T_EOS; }

"+" |
"-" |
"*" |
"/" |
"(" |
")"     { return yytext[0]; }
"**"    { return T_POW; }

"echo"  { return T_ECHO; }

{INTEGER}   {
    yylval.V_Integer = atoi(yytext);
    return T_Integer;
}

{FLOAT}    |
{EXPONENT} {
    yylval.V_Float = atof(yytext);
    return T_Float;
}

{BLANK}+                { /* ignore */ }

"/*"                    { BEGIN COMMENT_BLOC; }
<COMMENT_BLOC>.         { /* ignore */ }
<COMMENT_BLOC>{LINE}    { /* ignore */ }
<COMMENT_BLOC>"*/"      { BEGIN INITIAL; }

"//"                    { BEGIN COMMENT_LINE; }
<COMMENT_LINE>.         { /* ignore */ }
<COMMENT_LINE>{LINE}    { BEGIN INITIAL; }

.                       { yyerror("unexcept char"); }

%%
