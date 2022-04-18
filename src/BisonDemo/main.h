#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>

// Flex
extern FILE *yyin;   // 输入流
extern char *yytext; // TokenText
extern int yylineno; // 行号
extern int yylex(void);

// Bison
#ifndef YYSTYPE_IS_DECLARED
    #include "yacc.h"
    // extern enum yytokentype; // TokenType
    // extern union YYSTYPE;    // ValueType
#endif
extern YYSTYPE yylval;
extern int yyparse(void);
extern void yyerror(const char *, ...);
