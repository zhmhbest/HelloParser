#include "flex_bison.h"
#include <stdarg.h>

void yyerror(const char *s, ...)
{
    va_list ap;
    va_start(ap, s);
    fprintf(stderr, "error(line:%d, text:%s): ", yylineno, yytext);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
    exit(1);
}