#include "flex_bison.h"

int main() {
    yyin = fopen("./input.txt", "r");
    yyparse();
    fclose(yyin);
    printf("bye\n");
}
