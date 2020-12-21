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
#endif
// extern enum yytokentype;
// extern YYSTYPE yylval;
extern int yyparse(void);
extern void yyerror(const char *, ...);

// AST(Abstract Syntax Tree)
struct ast
{
  int nodetype;
  struct ast *l;
  struct ast *r;
};

struct numval
{
  int nodetype; /* type K */
  double number;
};

/* build an AST */
struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newnum(double d);

/* evaluate an AST */
double eval(struct ast *);

/* delete and free an AST */
void treefree(struct ast *);