#include "main.h"
#include <stdarg.h>

int main()
{
    yyin = fopen("./input.txt", "r");
    yyparse();
    fclose(yyin);
    printf("bye\n");
}

void yyerror(const char *s, ...)
{
    va_list ap;
    va_start(ap, s);
    fprintf(stderr, "error(line:%d, text:%s): ", yylineno, yytext);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
    exit(1);
}