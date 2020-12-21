#include "flex_bison.h"
#include "ast.h"

int main()
{
  printf("> ");
  return yyparse();
}

