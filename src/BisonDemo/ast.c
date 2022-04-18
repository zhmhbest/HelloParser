#include "main.h"
#include "ast.h"

struct ast *ast_new(int nodetype, struct ast *l, struct ast *r)
{
    struct ast *a = malloc(sizeof(struct ast));
    if (!a)
        yyerror("out of memory");
    a->nodetype = nodetype;
    a->nodevalue.p = NULL;
    a->l = l;
    a->r = r;
    return a;
}

struct ast *ast_float(double d)
{
    struct ast *a = malloc(sizeof(struct ast));
    if (!a)
        yyerror("out of memory");
    a->nodetype = T_Float;
    a->nodevalue.f = d;
    a->l = NULL;
    a->r = NULL;
    return a;
}

double ast_eval(struct ast *a)
{
    double v;
    switch (a->nodetype)
    {
    case T_Float:
        // printf("val=%f\n", a->nodevalue.Float);
        v = a->nodevalue.f;
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
    case T_POW:
        v = pow(ast_eval(a->l), ast_eval(a->r));
        break;
    case T_UM:
        v = -ast_eval(a->l);
        break;
    default:
        printf("internal error: bad node %d\n", a->nodetype);
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
    case T_POW:
        ast_free(a->r);

    case T_UM:
        ast_free(a->l);

    case T_Float:
        free(a);
        break;

    default:
        printf("internal error: free bad node %d\n", a->nodetype);
    }
}