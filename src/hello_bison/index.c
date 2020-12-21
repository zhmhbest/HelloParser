#include "common.h"

int main() {
    yyin = fopen("./input.txt", "r");
    yyparse();
    fclose(yyin);
    printf("bye\n");
}
