

%{

open Ast
open Type_system

let reduce_log _ = () (* Stdlib.print_endline s *)

let apply_pointers base_type pointer_depth =
  let rec loop acc n =
    if n <= 0 then acc else loop (Pointer acc) (n - 1)
  in
  loop base_type pointer_depth

let make_declaration decl_type pointer_depth name array_size =
  { decl_type = apply_pointers decl_type pointer_depth
  ; declarator = { name; pointer_depth; array_size }
  }

let binary_of_relop = function
  | "<" -> Lt
  | "<=" -> Le
  | ">" -> Gt
  | ">=" -> Ge
  | op -> failwith ("unknown relational operator: " ^ op)

let binary_of_equop = function
  | "==" -> Eq
  | "!=" -> Ne
  | op -> failwith ("unknown equality operator: " ^ op)
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
%token<string>    RELOP EQUOP
%token            LOGICAL_AND LOGICAL_OR
%token            STRUCTOP INCOP DECOP
%token<string> ID CHAR_CONST STRING
%token<int>    INTEGER_CONST
%token RETURN IF ELSE WHILE FOR BREAK CONTINUE
%token SYM_NULL

%nonassoc IF_WITHOUT_ELSE
%nonassoc ELSE


%start program
%type<Ast.program>  program
%type<Ast.ext_def list> ext_def_list
%type<Ast.ext_def> ext_def
%type<Type_system.t> type_specifier
%type<Ast.struct_specifier> struct_specifier
%type<Ast.func_decl> func_decl
%type<int> pointers
%type<Ast.param_decl list> param_list
%type<Ast.param_decl> param_decl
%type<Ast.def list> def_list
%type<Ast.def> def
%type<Ast.compound_stmt> compound_stmt
%type<Ast.stmt list> stmt_list
%type<Ast.stmt> stmt
%type<Ast.expr option> expr_e
%type<Ast.expr> expr
%type<Ast.expr> binary
%type<Ast.expr> unary
%type<Ast.expr list> args

%%

program : 
    ext_def_list EOF                                     {
      reduce_log "program->ext_def_list";
      $1
    }

ext_def_list
  : ext_def_list ext_def                                 {
      reduce_log "ext_def_list->ext_def_list ext_def";
      $1 @ [$2]
    }
  |                                                      {
      reduce_log "ext_def_list->epsilon";
      []
    }
  ;

ext_def
  : type_specifier pointers ID SEMI                      {
      reduce_log "ext_def->type_specifier pointers ID ';'";
      Global_decl (make_declaration $1 $2 $3 None)
    }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET SEMI
                                                         {
      reduce_log "ext_def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'";
      Global_decl (make_declaration $1 $2 $3 (Some $5))
    }
  | struct_specifier SEMI                                {
      reduce_log "ext_def->struct_specifier ';'";
      Struct_decl $1
    }
  | func_decl compound_stmt                              {
      reduce_log "ext_def->func_decl compound_stmt";
      Function_def ($1, $2)
    }
  ;

type_specifier
  : INT                                                  { reduce_log "type_specifier->TYPE"; Int }
  | CHAR                                                 { reduce_log "type_specifier->TYPE"; Char }
  | struct_specifier                                     {
      reduce_log "type_specifier->struct_specifier";
      Struct
        (List.map
           (fun decl ->
             { entry_name = decl.declarator.name
             ; entry_type = decl.decl_type
             })
           (match $1.def_list with
            | Some def_list -> def_list
            | None -> []))
    }
  ;

struct_specifier
  : STRUCT ID LBRACE def_list RBRACE                     {
      reduce_log "struct_specifier->STRUCT ID '{' def_list '}'";
      { name = $2; def_list = Some $4 }
    }
  | STRUCT ID                                            {
      reduce_log "struct_specifier->STRUCT ID";
      { name = $2; def_list = None }
    }
  ;

func_decl
  : type_specifier pointers ID LPAREN RPAREN %prec DOT
                                                         {
      reduce_log "func_decl->type_specifier pointers ID '(' ')'";
      { return_type = apply_pointers $1 $2; pointer_depth = $2; name = $3; param_list = [] }
    }
  | type_specifier pointers ID LPAREN param_list RPAREN %prec DOT
                                                         {
      reduce_log "func_decl->type_specifier pointers ID '(' param_list ')'";
      { return_type = apply_pointers $1 $2; pointer_depth = $2; name = $3; param_list = $5 }
    }
  ;

pointers
  : STAR                                                 { reduce_log "pointers->'*'"; 1 }
  |                                                      { reduce_log "pointers->epsilon"; 0 }
  ;

param_list
  : param_decl                                           { reduce_log "param_list->param_decl"; [$1] }
  | param_list COMMA param_decl                          { reduce_log "param_list->param_list ',' param_decl"; $1 @ [$3] }
  ;

param_decl
  : type_specifier pointers ID                           {
      reduce_log "param_decl->type_specifier pointers ID";
      make_declaration $1 $2 $3 None
    }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET
                                                         {
      reduce_log "param_decl->type_specifier pointers ID '[' INTEGER_CONST ']'";
      make_declaration $1 $2 $3 (Some $5)
    }
  ;

def_list
  : def_list def                                         { reduce_log "def_list->def_list def"; $1 @ [$2] }
  |                                                      { reduce_log "def_list->epsilon"; [] }
  ;

def
  : type_specifier pointers ID SEMI                      {
      reduce_log "def->type_specifier pointers ID ';'";
      make_declaration $1 $2 $3 None
    }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET SEMI
                                                         {
      reduce_log "def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'";
      make_declaration $1 $2 $3 (Some $5)
    }
  ;

compound_stmt
  : LBRACE def_list stmt_list RBRACE                     {
      reduce_log "compound_stmt->'{' def_list stmt_list '}'";
      { def_list = $2; stmt_list = $3 }
    }
  ;

stmt_list
  : stmt_list stmt                                       { reduce_log "stmt_list->stmt_list stmt"; $1 @ [$2] }
  |                                                      { reduce_log "stmt_list->epsilon"; [] }
  ;

stmt
  : expr SEMI                                            { reduce_log "stmt->expr ';'"; Expr $1 }
  | compound_stmt                                        { reduce_log "stmt->compound_stmt"; Compound $1 }
  | RETURN expr SEMI                                     { reduce_log "stmt->RETURN expr ';'"; Return $2 }
  | SEMI                                                 { reduce_log "stmt->';'"; Empty }
  | IF LPAREN expr RPAREN stmt %prec IF_WITHOUT_ELSE     { reduce_log "stmt->IF '(' expr ')' stmt"; If ($3, $5, None) }
  | IF LPAREN expr RPAREN stmt ELSE stmt                 { reduce_log "stmt->IF '(' expr ')' stmt ELSE stmt"; If ($3, $5, Some $7) }
  | WHILE LPAREN expr RPAREN stmt                        { reduce_log "stmt->WHILE '(' expr ')' stmt"; While ($3, $5) }
  | FOR LPAREN expr_e SEMI expr_e SEMI expr_e RPAREN stmt
                                                         { reduce_log "stmt->FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt"; For ($3, $5, $7, $9) }
  | BREAK SEMI                                           { reduce_log "stmt->BREAK ';'"; Break }
  | CONTINUE SEMI                                        { reduce_log "stmt->CONTINUE ';'"; Continue }
  ;

expr_e
  : expr                                                 { reduce_log "expr_e->expr"; Some $1 }
  |                                                      { reduce_log "expr_e->epsilon"; None }
  ;

expr
  : unary ASSIGN expr                                    { reduce_log "expr->unary '=' expr"; Assign ($1, $3) }
  | binary                                               { reduce_log "expr->binary"; $1 }
  ;

binary
  : binary RELOP binary                                  { reduce_log "binary->binary RELOP binary"; Binary (binary_of_relop $2, $1, $3) }
  | binary EQUOP binary                                  { reduce_log "binary->binary EQUOP binary"; Binary (binary_of_equop $2, $1, $3) }
  | binary PLUS binary                                   { reduce_log "binary->binary '+' binary"; Binary (Add, $1, $3) }
  | binary MINUS binary                                  { reduce_log "binary->binary '-' binary"; Binary (Sub, $1, $3) }
  | binary STAR binary                                   { reduce_log "binary->binary '*' binary"; Binary (Mul, $1, $3) }
  | binary SLASH binary                                  { reduce_log "binary->binary '/' binary"; Binary (Div, $1, $3) }
  | binary PERCENT binary                                { reduce_log "binary->binary '%%' binary"; Binary (Mod, $1, $3) }
  | unary %prec ASSIGN                                   { reduce_log "binary->unary"; $1 }
  | binary LOGICAL_AND binary                            { reduce_log "binary->binary LOGICAL_AND binary"; Binary (Logical_and, $1, $3) }
  | binary LOGICAL_OR binary                             { reduce_log "binary->binary LOGICAL_OR binary"; Binary (Logical_or, $1, $3) }
  ;

unary
  : LPAREN expr RPAREN                                   { reduce_log "unary->'(' expr ')'"; $2 }
  | INTEGER_CONST                                        { reduce_log "unary->INTEGER_CONST"; Int_const $1 }
  | CHAR_CONST                                           { reduce_log "unary->CHAR_CONST"; Char_const $1 }
  | STRING                                               { reduce_log "unary->STRING"; String_const $1 }
  | ID                                                   { reduce_log "unary->ID"; Identifier $1 }
  | MINUS unary %prec BANG                               { reduce_log "unary->'-' unary"; Unary (Neg, $2) }
  | BANG unary                                           { reduce_log "unary->'!' unary"; Unary (Not, $2) }
  | unary INCOP %prec DOT                                { reduce_log "unary->unary INCOP"; Postfix (Post_inc, $1) }
  | unary DECOP %prec DOT                                { reduce_log "unary->unary DECOP"; Postfix (Post_dec, $1) }
  | INCOP unary %prec BANG                               { reduce_log "unary->INCOP unary"; Unary (Pre_inc, $2) }
  | DECOP unary %prec BANG                               { reduce_log "unary->DECOP unary"; Unary (Pre_dec, $2) }
  | AMP unary %prec BANG                                 { reduce_log "unary->'&' unary"; Unary (Addr_of, $2) }
  | STAR unary %prec BANG                                { reduce_log "unary->'*' unary"; Unary (Deref, $2) }
  | unary LBRACKET expr RBRACKET                         { reduce_log "unary->unary '[' expr ']'"; Index ($1, $3) }
  | unary DOT ID                                         { reduce_log "unary->unary '.' ID"; Field ($1, $3) }
  | unary STRUCTOP ID                                    { reduce_log "unary->unary STRUCTOP ID"; Ptr_field ($1, $3) }
  | unary LPAREN args RPAREN %prec DOT                   { reduce_log "unary->unary '(' args ')'"; Call ($1, $3) }
  | unary LPAREN RPAREN %prec DOT                        { reduce_log "unary->unary '(' ')'"; Call ($1, []) }
  | SYM_NULL                                             { reduce_log "unary->SYM_NULL"; Null }
  ;

args
  : expr                                                 { reduce_log "args->expr"; [$1] }
  | args COMMA expr                                      { reduce_log "args->args ',' expr"; $1 @ [$3] }
  ;


%%
