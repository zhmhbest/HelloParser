#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>

// Flex
extern FILE *yyin;
extern char *yytext;
extern int yylineno;
extern int yylex(void);

// Bison
#ifndef YYSTYPE_IS_DECLARED
    #include "yacc.h"
    // extern enum yytokentype;
    // extern union YYSTYPE;
#endif
extern YYSTYPE yylval;
extern int yyparse(void);
extern void yyerror(const char *, ...);
// #define YYDEBUG 1