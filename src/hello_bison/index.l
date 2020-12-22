%option noyywrap nodefault yylineno
%{
#include "flex_bison.h"
%}

%x COMMENT_LINE
%x COMMENT_BLOC

DIGIT   [0-9]
BLANK   [\ \f\r\t\v]
LINE    (\r\n|\n|\r)
INTEGER         {DIGIT}+
FLOAT           {INTEGER}\.{INTEGER}

%%

";"     { yylval.operation_t = TT_EOS; return TT_EOS; }
"+"     { yylval.operation_t = TT_Add; return TT_Add; }
"-"     { yylval.operation_t = TT_Sub; return TT_Sub; }
"*"     { yylval.operation_t = TT_Mul; return TT_Mul; }
"/"     { yylval.operation_t = TT_Div; return TT_Div; }
"**"    { yylval.operation_t = TT_Pow; return TT_Pow; }

"-"?{INTEGER}   {
    yylval.integer_t = atoi(yytext);
    return TT_Integer;
}

"-"?{FLOAT}     {
    yylval.float_t = atof(yytext);
    return TT_Float;
}

{BLANK}+                { /* ignore */ }
{LINE}                  { /* ignore */ }

"/*"                    { BEGIN COMMENT_BLOC; }
<COMMENT_BLOC>.         { /* ignore */ }
<COMMENT_BLOC>{LINE}    { /* ignore */ }
<COMMENT_BLOC>"*/"      { BEGIN INITIAL; }

"//"                    { BEGIN COMMENT_LINE; }
<COMMENT_LINE>.         { /* ignore */ }
<COMMENT_LINE>{LINE}    { BEGIN INITIAL; }

.                       {
    fprintf(stderr, "Unexcept char '%s' at line: %d.\n", yytext, yylineno);
    exit(1);
}

%%
