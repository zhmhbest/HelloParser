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

BLANK   [\ \f\r\t\v]
LINE    (\r\n|\n|\r)

LETTER  [_A-Za-z]
WORD    [_A-Za-z0-9]
IDENTIFIER  {LETTER}{WORD}*

INT_BIN     0[Bb][0-1]+
INT_OCT     0[0-7]+
INT_DEC     [1-9][0-9]*
INT_HEX     0[Xx][0-9a-fA-F]+
INTEGER     -?({INT_BIN}|{INT_HEX}|{INT_OCT}|{INT_DEC})
DECIMAL     -?{INT_DEC}

FLOAT_DEC   -?{DECIMAL}\.{DECIMAL}
FLOAT_EXP   ({FLOAT_DEC}|{DECIMAL})[Ee]{DECIMAL}
FLOAT       {FLOAT_DEC}|{FLOAT_EXP}

%%

{IDENTIFIER}            { return TT_ID; }
{INTEGER}               { return TT_Integer; }
{FLOAT}                 { return TT_Float; }
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
