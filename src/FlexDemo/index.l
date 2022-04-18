%option nodefault yylineno noyywrap

%{
    #include <stdio.h>
    #include <string.h>

    FILE* yyin;
    char* yytext;
    int yylex(void);
    enum yytokentype {
        TT_ID = 100,
        TT_OP = 200,
        TT_Integer = 310,
        TT_Float = 320
    };
%}

%x COMMENT

LETTER  [_A-Za-z]
DIGIT   [0-9]
WORD    [_A-Za-z0-9]
BLANK   [\ \f\r\t\v]
LINE    (\r\n|\n|\r)

IDENTIFIER      {LETTER}{WORD}*
INTEGER         {DIGIT}+
FLOAT           {INTEGER}\.{INTEGER}

%%

{IDENTIFIER}            { return TT_ID; }
"-"?{INTEGER}           { return TT_Integer; }
"-"?{FLOAT}             { return TT_Float; }
"="                     { return TT_OP; }

{LINE}                  { /* ignore */ }
{BLANK}+                { /* ignore */ }

"#"                     { BEGIN COMMENT; }
<COMMENT>.              { /* ignore */ }
<COMMENT>{LINE}         { BEGIN INITIAL; }

.                       { printf("err(%s)\n", yytext); }

%%

int main() {
    yyin = fopen("./input.txt", "r");

    int token;
    while( token = yylex() ) {
        printf("line=%d, token=%d, text=[%s]\n", yylineno, token, yytext);
    }

    fclose(yyin);
}
