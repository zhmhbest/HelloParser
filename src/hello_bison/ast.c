#include "flex_bison.h"
#include "ast.h"

struct ast *ast_new(int nodetype, struct ast *l, struct ast *r)
{
    struct ast *a = malloc(sizeof(struct ast));
    if (!a)
        yyerror("out of memory");
    a->nodetype = nodetype;
    a->nodevalue.Pointer = NULL;
    a->l = l;
    a->r = r;
    return a;
}

struct ast *ast_float(double d)
{
    struct ast *a = malloc(sizeof(struct ast));
    if (!a)
        yyerror("out of memory");
    a->nodetype = TT_Float;
    a->nodevalue.Float = d;
    a->l = NULL;
    a->r = NULL;
    return a;
}

double ast_eval(struct ast *a)
{
    double v;
    switch (a->nodetype)
    {
    case TT_Float:
        // printf("val=%f\n", a->nodevalue.Float);
        v = a->nodevalue.Float;
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
    case TT_Pow:
        v = pow(ast_eval(a->l), ast_eval(a->r));
        break;
    case TT_Neg:
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
    case TT_Pow:
        ast_free(a->r);

    case TT_Neg:
        ast_free(a->l);

    case TT_Float:
        free(a);
        break;

    default:
        printf("internal error: free bad node %d\n", a->nodetype);
    }
}