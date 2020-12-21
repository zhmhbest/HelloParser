struct ast
{
  struct ast *l;
  struct ast *r;
  int nodetype;
  union
  {
    void *pointer_t;
    double float_t;
  } nodevalue;
};

struct ast *ast_new(int nodetype, struct ast *l, struct ast *r);
struct ast *ast_float(double d);
double ast_eval(struct ast *);
void ast_free(struct ast *);
