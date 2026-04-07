

%{

let print_log = Logger.print_log

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
%type<Ast.program> program

%%

program :
    ext_def_list EOF                                     {
      print_log "program->ext_def_list";
      List.rev $1
    }

ext_def_list
  : ext_def_list ext_def                                 {
      print_log "ext_def_list->ext_def_list ext_def";
      $2 :: $1
    }
  |                                                      {
      print_log "ext_def_list->epsilon";
      []
    }
  ;

ext_def
  : type_specifier pointers ID SEMI                      {
      print_log "ext_def->type_specifier pointers ID ';'";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Global_decl { line = $startpos.Lexing.pos_lnum; type_ = $1; pointer_depth = $2; name = $3; array_size = None } }
    }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET SEMI
                                                         {
      print_log "ext_def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Global_decl { line = $startpos.Lexing.pos_lnum; type_ = $1; pointer_depth = $2; name = $3; array_size = Some $5 } }
    }
  | struct_specifier SEMI                                {
      print_log "ext_def->struct_specifier ';'";
      $1
    }
  | func_decl compound_stmt                              {
      print_log "ext_def->func_decl compound_stmt";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Func_def ($1, $2) }
    }
  ;

type_specifier
  : INT                                                  {
      print_log "type_specifier->TYPE";
      Type_system.Int
    }
  | CHAR                                                 {
      print_log "type_specifier->TYPE";
      Type_system.Char
    }
  | STRUCT ID                                            {
      print_log "struct_specifier->STRUCT ID";
      print_log "type_specifier->struct_specifier";
      Type_system.Struct_ref $2
    }
  ;

struct_specifier
  : STRUCT ID LBRACE def_list RBRACE                     {
      print_log "struct_specifier->STRUCT ID '{' def_list '}'";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Struct_def ($2, List.rev $4) }
    }
  ;

func_decl
  : type_specifier pointers ID LPAREN RPAREN %prec DOT
                                                         {
      print_log "func_decl->type_specifier pointers ID '(' ')'";
      Ast.({ return_type = $1; pointer_depth = $2; name = $3; params = [] })
    }
  | type_specifier pointers ID LPAREN param_list RPAREN %prec DOT
                                                         {
      print_log "func_decl->type_specifier pointers ID '(' param_list ')'";
      Ast.({ return_type = $1; pointer_depth = $2; name = $3; params = List.rev $5 })
    }
  ;

pointers
  : STAR                                                 { print_log "pointers->'*'"; 1 }
  |                                                      { print_log "pointers->epsilon"; 0 }
  ;

param_list
  : param_decl                                           {
      print_log "param_list->param_decl";
      [$1]
    }
  | param_list COMMA param_decl                          {
      print_log "param_list->param_list ',' param_decl";
      $3 :: $1
    }
  ;

param_decl
  : type_specifier pointers ID                           {
      print_log "param_decl->type_specifier pointers ID";
      Ast.({ line = $startpos.Lexing.pos_lnum; type_ = $1; pointer_depth = $2; name = $3; array_size = None })
    }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET
                                                         {
      print_log "param_decl->type_specifier pointers ID '[' INTEGER_CONST ']'";
      Ast.({ line = $startpos.Lexing.pos_lnum; type_ = $1; pointer_depth = $2; name = $3; array_size = Some $5 })
    }
  ;

def_list
  : def_list def                                         {
      print_log "def_list->def_list def";
      $2 :: $1
    }
  |                                                      {
      print_log "def_list->epsilon";
      []
    }
  ;

def
  : type_specifier pointers ID SEMI                      {
      print_log "def->type_specifier pointers ID ';'";
      Ast.({ line = $startpos.Lexing.pos_lnum; type_ = $1; pointer_depth = $2; name = $3; array_size = None })
    }
  | type_specifier pointers ID LBRACKET INTEGER_CONST RBRACKET SEMI
                                                         {
      print_log "def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'";
      Ast.({ line = $startpos.Lexing.pos_lnum; type_ = $1; pointer_depth = $2; name = $3; array_size = Some $5 })
    }
  | STRUCT ID LBRACE def_list RBRACE pointers ID SEMI    {
      print_log "def->STRUCT ID '{' def_list '}' pointers ID ';'";
      let entries = List.rev_map Ast.entry_of_decl $4 in
      Ast.({ line = $startpos.Lexing.pos_lnum; type_ = Type_system.Struct ($2, entries); pointer_depth = $6; name = $7; array_size = None })
    }
  ;

compound_stmt
  : LBRACE local_def_list stmt_list RBRACE               {
      print_log "compound_stmt->'{' def_list stmt_list '}'";
      List.rev_append $2 (List.rev $3)
    }
  ;

local_def_list
  : local_def_list def                                   {
      print_log "def_list->def_list def";
      Ast.{ line = $startpos($2).Lexing.pos_lnum; kind = Local_decl $2 } :: $1
    }
  |                                                      {
      print_log "def_list->epsilon";
      []
    }
  ;

stmt_list
  : stmt_list stmt                                       {
      print_log "stmt_list->stmt_list stmt";
      $2 :: $1
    }
  |                                                      {
      print_log "stmt_list->epsilon";
      []
    }
  ;

stmt
  : expr SEMI                                            {
      print_log "stmt->expr ';'";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Expr $1 }
    }
  | compound_stmt                                        {
      print_log "stmt->compound_stmt";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Block $1 }
    }
  | RETURN expr SEMI                                     {
      print_log "stmt->RETURN expr ';'";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Return $2 }
    }
  | SEMI                                                 {
      print_log "stmt->';'";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Empty }
    }
  | IF LPAREN expr RPAREN stmt %prec IF_WITHOUT_ELSE     {
      print_log "stmt->IF '(' expr ')' stmt";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = If ($3, $5, None) }
    }
  | IF LPAREN expr RPAREN stmt ELSE stmt                 {
      print_log "stmt->IF '(' expr ')' stmt ELSE stmt";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = If ($3, $5, Some $7) }
    }
  | WHILE LPAREN expr RPAREN stmt                        {
      print_log "stmt->WHILE '(' expr ')' stmt";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = While ($3, $5) }
    }
  | FOR LPAREN expr_e SEMI expr_e SEMI expr_e RPAREN stmt
                                                         {
      print_log "stmt->FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = For ($3, $5, $7, $9) }
    }
  | BREAK SEMI                                           {
      print_log "stmt->BREAK ';'";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Break }
    }
  | CONTINUE SEMI                                        {
      print_log "stmt->CONTINUE ';'";
      Ast.{ line = $startpos.Lexing.pos_lnum; kind = Continue }
    }
  ;

expr_e
  : expr                                                 {
      print_log "expr_e->expr";
      Some $1
    }
  |                                                      {
      print_log "expr_e->epsilon";
      None
    }
  ;

expr
  : unary ASSIGN expr                                    {
      print_log "expr->unary '=' expr";
      Ast.Assign ($1, $3)
    }
  | binary                                               {
      print_log "expr->binary";
      $1
    }
  ;

binary
  : binary RELOP binary                                  {
      print_log "binary->binary RELOP binary";
      let op = match $2 with
        | "<" -> Ast.Lt | "<=" -> Ast.Le
        | ">" -> Ast.Gt | ">=" -> Ast.Ge
        | _ -> failwith ("Unknown relop: " ^ $2)
      in Ast.Binary (op, $1, $3)
    }
  | binary EQUOP binary                                  {
      print_log "binary->binary EQUOP binary";
      let op = match $2 with
        | "==" -> Ast.Eq | "!=" -> Ast.Ne
        | _ -> failwith ("Unknown equop: " ^ $2)
      in Ast.Binary (op, $1, $3)
    }
  | binary PLUS binary                                   {
      print_log "binary->binary '+' binary";
      Ast.Binary (Ast.Add, $1, $3)
    }
  | binary MINUS binary                                  {
      print_log "binary->binary '-' binary";
      Ast.Binary (Ast.Sub, $1, $3)
    }
  | binary STAR binary                                   {
      print_log "binary->binary '*' binary";
      Ast.Binary (Ast.Mul, $1, $3)
    }
  | binary SLASH binary                                  {
      print_log "binary->binary '/' binary";
      Ast.Binary (Ast.Div, $1, $3)
    }
  | binary PERCENT binary                                {
      print_log "binary->binary '%%' binary";
      Ast.Binary (Ast.Mod, $1, $3)
    }
  | unary %prec ASSIGN                                   {
      print_log "binary->unary";
      $1
    }
  | binary LOGICAL_AND binary                            {
      print_log "binary->binary LOGICAL_AND binary";
      Ast.Binary (Ast.Logical_and, $1, $3)
    }
  | binary LOGICAL_OR binary                             {
      print_log "binary->binary LOGICAL_OR binary";
      Ast.Binary (Ast.Logical_or, $1, $3)
    }
  ;

unary
  : LPAREN expr RPAREN                                   {
      print_log "unary->'(' expr ')'";
      $2
    }
  | INTEGER_CONST                                        {
      print_log "unary->INTEGER_CONST";
      Ast.Int_const $1
    }
  | CHAR_CONST                                           {
      print_log "unary->CHAR_CONST";
      Ast.Char_const $1
    }
  | STRING                                               {
      print_log "unary->STRING";
      Ast.String_const $1
    }
  | ID                                                   {
      print_log "unary->ID";
      Ast.Identifier $1
    }
  | MINUS unary %prec BANG                               {
      print_log "unary->'-' unary";
      Ast.Unary (Ast.Neg, $2)
    }
  | BANG unary                                           {
      print_log "unary->'!' unary";
      Ast.Unary (Ast.Not, $2)
    }
  | unary INCOP %prec DOT                                {
      print_log "unary->unary INCOP";
      Ast.Postfix (Ast.Post_inc, $1)
    }
  | unary DECOP %prec DOT                                {
      print_log "unary->unary DECOP";
      Ast.Postfix (Ast.Post_dec, $1)
    }
  | INCOP unary %prec BANG                               {
      print_log "unary->INCOP unary";
      Ast.Unary (Ast.Pre_inc, $2)
    }
  | DECOP unary %prec BANG                               {
      print_log "unary->DECOP unary";
      Ast.Unary (Ast.Pre_dec, $2)
    }
  | AMP unary %prec BANG                                 {
      print_log "unary->'&' unary";
      Ast.Unary (Ast.Addr_of, $2)
    }
  | STAR unary %prec BANG                                {
      print_log "unary->'*' unary";
      Ast.Unary (Ast.Deref, $2)
    }
  | unary LBRACKET expr RBRACKET                         {
      print_log "unary->unary '[' expr ']'";
      Ast.Index ($1, $3)
    }
  | unary DOT ID                                         {
      print_log "unary->unary '.' ID";
      Ast.Field ($1, $3)
    }
  | unary STRUCTOP ID                                    {
      print_log "unary->unary STRUCTOP ID";
      Ast.Ptr_field ($1, $3)
    }
  | unary LPAREN args RPAREN %prec DOT                   {
      print_log "unary->unary '(' args ')'";
      Ast.Call ($1, List.rev $3)
    }
  | unary LPAREN RPAREN %prec DOT                        {
      print_log "unary->unary '(' ')'";
      Ast.Call ($1, [])
    }
  | SYM_NULL                                             {
      print_log "unary->SYM_NULL";
      Ast.Null
    }
  ;

args
  : expr                                                 {
      print_log "args->expr";
      [$1]
    }
  | args COMMA expr                                      {
      print_log "args->args ',' expr";
      $3 :: $1
    }
  ;


%%
