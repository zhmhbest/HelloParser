%lex
%%

/* 词法分析 */
<<EOF>>               return 'EOF'
";"                   return 'EOS'
(\r\n)|\n|\r          return 'EOS'
[\ \t]+               /* ignore */

[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"**"                  return '**'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"("                   return '('
")"                   return ')'
"PI"                  return 'PI'
"E"                   return 'E'
"echo"                return 'ECHO'
.                     return 'INVALID'

/lex

/* 语法定义 */
%left '+' '-'
%left '*' '/'
%left '**'
%nonassoc UMINUS
%start statements

%%

/* 语法分析 */
statements:
    /* nothing */
  | statements statement     EOS
  | statements statement     EOF
  | statements /* nothing */ EOS
  | statements /* nothing */ EOF
  ;

statement:
    ECHO expression { typeof console !== 'undefined' ? console.log($2) : print($2); }
  ;

expression:
    Number
  | '(' expression ')'          { $$ = $2; }
  | expression '+'  expression  { $$ = $1 + $3; }
  | expression '-'  expression  { $$ = $1 - $3; }
  | expression '*'  expression  { $$ = $1 * $3; }
  | expression '/'  expression  { $$ = $1 / $3; }
  | expression '**' expression  { $$ = Math.pow($1, $3); }
  | '-' expression %prec UMINUS { $$ = -$2; }
  ;

Number:
   NUMBER { $$ = Number(yytext); }
 | E      { $$ = Math.E; }
 | PI     { $$ = Math.PI; }
 ;
