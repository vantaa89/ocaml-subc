

%{

open Environment
open Type_system

let reduce_log _ = () (* Stdlib.print_endline s *)
let _ = empty
%}


%left COMMA
%right ASSIGN
%left LOGICAL_OR
%left LOGICAL_AND
%left EQUOP
%left RELOP
%left PLUS MINUS
%left STAR SLASH PERCENT
%right BANG INCOP DECOP
%left DOT STRUCTOP LPAREN RPAREN LBRACKET RBRACKET

%token            INT CHAR
%token            STRUCT
%token            LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token            DOT COMMA BANG STAR SLASH PERCENT PLUS MINUS
%token            AMP SEMI ASSIGN
%token            EOF
%token            RELOP EQUOP LOGICAL_AND LOGICAL_OR
%token            STRUCTOP INCOP DECOP
%token<string> ID CHAR_CONST STRING
%token<int>    INTEGER_CONST
%token RETURN IF ELSE WHILE FOR BREAK CONTINUE
%token SYM_NULL

%nonassoc IF_WITHOUT_ELSE
%nonassoc ELSE


%start program
%type<unit>  program
%type<t>  struct_specifier

%%

program : 
    ext_def_list                                         { reduce_log "program->ext_def_list" }

ext_def_list
  : ext_def_list ext_def                                 { reduce_log "ext_def_list->ext_def_list ext_def" }
  |                                                      { reduce_log "ext_def_list->epsilon" }
  ;

ext_def
  : type_specifier pointers ID SEMI                      { reduce_log "ext_def->type_specifier pointers ID ';'" }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET SEMI
                                                         { reduce_log "ext_def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'" }
  | struct_specifier SEMI                                { reduce_log "ext_def->struct_specifier ';'" }
  | func_decl compound_stmt                              { reduce_log "ext_def->func_decl compound_stmt" }
  ;

type_specifier
  : INT                                                  { reduce_log "type_specifier->TYPE"; Int }
  | CHAR                                                 { reduce_log "type_specifier->TYPE"; Char }
  | struct_specifier                                     { reduce_log "type_specifier->struct_specifier"; $1 }
  ;

struct_specifier
  : STRUCT ID LBRACE def_list RBRACE                     { reduce_log "struct_specifier->STRUCT ID '{' def_list '}'" }
  | STRUCT ID                                            { reduce_log "struct_specifier->STRUCT ID" }
  ;

func_decl
  : type_specifier pointers ID LPAREN RPAREN %prec DOT
                                                         { reduce_log "func_decl->type_specifier pointers ID '(' ')'" }
  | type_specifier pointers ID LPAREN param_list RPAREN %prec DOT
                                                         { reduce_log "func_decl->type_specifier pointers ID '(' param_list ')'" }
  ;

pointers
  : STAR                                                 { reduce_log "pointers->'*'" }
  |                                                      { reduce_log "pointers->epsilon" }
  ;

param_list
  : param_decl                                           { reduce_log "param_list->param_decl" }
  | param_list COMMA param_decl                          { reduce_log "param_list->param_list ',' param_decl" }
  ;

param_decl
  : type_specifier pointers ID                           { reduce_log "param_decl->type_specifier pointers ID" }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET
                                                         { reduce_log "param_decl->type_specifier pointers ID '[' INTEGER_CONST ']'" }
  ;

def_list
  : def_list def                                         { reduce_log "def_list->def_list def" }
  |                                                      { reduce_log "def_list->epsilon" }
  ;

def
  : type_specifier pointers ID SEMI                      { reduce_log "def->type_specifier pointers ID ';'" }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET SEMI
                                                         { reduce_log "def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'" }
  ;

compound_stmt
  : LBRACE def_list stmt_list RBRACE                     { reduce_log "compound_stmt->'{' def_list stmt_list '}'" }
  ;

stmt_list
  : stmt_list stmt                                       { reduce_log "stmt_list->stmt_list stmt" }
  |                                                      { reduce_log "stmt_list->epsilon" }
  ;

stmt
  : expr SEMI                                            { reduce_log "stmt->expr ';'" }
  | compound_stmt                                        { reduce_log "stmt->compound_stmt" }
  | RETURN expr SEMI                                     { reduce_log "stmt->RETURN expr ';'" }
  | SEMI                                                 { reduce_log "stmt->';'" }
  | IF LPAREN expr RPAREN stmt %prec IF_WITHOUT_ELSE     { reduce_log "stmt->IF '(' expr ')' stmt" }
  | IF LPAREN expr RPAREN stmt ELSE stmt                 { reduce_log "stmt->IF '(' expr ')' stmt ELSE stmt" }
  | WHILE LPAREN expr RPAREN stmt                        { reduce_log "stmt->WHILE '(' expr ')' stmt" }
  | FOR LPAREN expr_e SEMI expr_e SEMI expr_e RPAREN stmt
                                                         { reduce_log "stmt->FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt" }
  | BREAK SEMI                                           { reduce_log "stmt->BREAK ';'" }
  | CONTINUE SEMI                                        { reduce_log "stmt->CONTINUE ';'" }
  ;

expr_e
  : expr                                                 { reduce_log "expr_e->expr" }
  |                                                      { reduce_log "expr_e->epsilon" }
  ;

expr
  : unary ASSIGN expr                                    { reduce_log "expr->unary '=' expr" }
  | binary                                               { reduce_log "expr->binary" }
  ;

binary
  : binary RELOP binary                                  { reduce_log "binary->binary RELOP binary" }
  | binary EQUOP binary                                  { reduce_log "binary->binary EQUOP binary" }
  | binary PLUS binary                                   { reduce_log "binary->binary '+' binary" }
  | binary MINUS binary                                  { reduce_log "binary->binary '-' binary" }
  | binary STAR binary                                   { reduce_log "binary->binary '*' binary" }
  | binary SLASH binary                                  { reduce_log "binary->binary '/' binary" }
  | binary PERCENT binary                                { reduce_log "binary->binary '%%' binary" }
  | unary %prec ASSIGN                                   { reduce_log "binary->unary" }
  | binary LOGICAL_AND binary                            { reduce_log "binary->binary LOGICAL_AND binary" }
  | binary LOGICAL_OR binary                             { reduce_log "binary->binary LOGICAL_OR binary" }
  ;

unary
  : LPAREN expr RPAREN                                   { reduce_log "unary->'(' expr ')'" }
  | INTEGER_CONST                                        { reduce_log "unary->INTEGER_CONST" }
  | CHAR_CONST                                           { reduce_log "unary->CHAR_CONST" }
  | STRING                                               { reduce_log "unary->STRING" }
  | ID                                                   { reduce_log "unary->ID" }
  | MINUS unary %prec BANG                               { reduce_log "unary->'-' unary" }
  | BANG unary                                           { reduce_log "unary->'!' unary" }
  | unary INCOP %prec DOT                                { reduce_log "unary->unary INCOP" }
  | unary DECOP %prec DOT                                { reduce_log "unary->unary DECOP" }
  | INCOP unary %prec BANG                               { reduce_log "unary->INCOP unary" }
  | DECOP unary %prec BANG                               { reduce_log "unary->DECOP unary" }
  | AMP unary %prec BANG                                 { reduce_log "unary->'&' unary" }
  | STAR unary %prec BANG                                { reduce_log "unary->'*' unary" }
  | unary LBRACKET expr RBRACKET                         { reduce_log "unary->unary '[' expr ']'" }
  | unary DOT ID                                         { reduce_log "unary->unary '.' ID" }
  | unary STRUCTOP ID                                    { reduce_log "unary->unary STRUCTOP ID" }
  | unary LPAREN args RPAREN %prec DOT                   { reduce_log "unary->unary '(' args ')'" }
  | unary LPAREN RPAREN %prec DOT                        { reduce_log "unary->unary '(' ')'" }
  | SYM_NULL                                             { reduce_log "unary->SYM_NULL" }
  ;

args
  : expr                                                 { reduce_log "args->expr" }
  | args COMMA expr                                      { reduce_log "args->args ',' expr" }
  ;


%%
