#include "flex_bison.h"
#include "ast.h"

struct ast *
ast_new(int nodetype, struct ast *l, struct ast *r)
{
    struct ast *a = malloc(sizeof(struct ast));
    if (!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->nodevalue.pointer_t = NULL;
    a->l = l;
    a->r = r;
    return a;
}

struct ast *
ast_float(double d)
{
    struct ast *a = malloc(sizeof(struct ast));
    if (!a)
    {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = 'K';
    a->nodevalue.float_t = d;
    a->l = NULL;
    a->r = NULL;
    return a;
}

double
ast_eval(struct ast *a)
{
    double v;
    switch (a->nodetype)
    {
    case 'K':
        v = a->nodevalue.float_t;
        break;
    case '+':
        v = ast_eval(a->l) + ast_eval(a->r);
        break;
    case '-':
        v = ast_eval(a->l) - ast_eval(a->r);
        break;
    case '*':
        v = ast_eval(a->l) * ast_eval(a->r);
        break;
    case '/':
        v = ast_eval(a->l) / ast_eval(a->r);
        break;
    case 'M':
        v = -ast_eval(a->l);
        break;
    default:
        printf("internal error: bad node %c\n", a->nodetype);
    }
    return v;
}

void ast_free(struct ast *a)
{
    switch (a->nodetype)
    {
    case '+':
    case '-':
    case '*':
    case '/':
        ast_free(a->r);

    case 'M':
        ast_free(a->l);

    case 'K':
        free(a);
        break;

    default:
        printf("internal error: free bad node %c\n", a->nodetype);
    }
}