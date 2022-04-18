struct ast
{
    struct ast *l;
    struct ast *r;
    int nodetype;
    union
    {
        void *p;
        double f;
    } nodevalue;
};

struct ast *ast_new(int, struct ast *, struct ast *);
struct ast *ast_float(double);
double ast_eval(struct ast *);
void ast_free(struct ast *);
