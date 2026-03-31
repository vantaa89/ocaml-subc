Parser regression tests

  $ ../../src/main.exe --emit-log < arrays.c
  ext_def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  ext_def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  ext_def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID '[' INTEGER_CONST ']'
  param_list->param_decl
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID
  param_list->param_list ',' param_decl
  func_decl->type_specifier pointers ID '(' param_list ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  unary->ID
  binary->unary
  unary->ID
  binary->unary
  binary->binary RELOP binary
  expr->binary
  expr_e->expr
  unary->ID
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->ID
  binary->unary
  unary->ID
  unary->ID
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary RELOP binary
  expr->binary
  expr_e->expr
  unary->ID
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->ID
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '*' binary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->ID
  binary->unary
  expr->binary
  args->expr
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  args->args ',' expr
  unary->unary '(' args ')'
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

  $ ../../src/main.exe --emit-log < basic_types.c
  ext_def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  ext_def->type_specifier pointers ID ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  ext_def->type_specifier pointers ID ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  ext_def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  ext_def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

  $ ../../src/main.exe --emit-log < comprehensive.c
  ext_def_list->epsilon
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  def_list->def_list def
  struct_specifier->STRUCT ID '{' def_list '}'
  ext_def->struct_specifier ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  ext_def->type_specifier pointers ID ';'
  ext_def_list->ext_def_list ext_def
  struct_specifier->STRUCT ID
  type_specifier->struct_specifier
  pointers->epsilon
  ext_def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID '[' INTEGER_CONST ']'
  param_list->param_decl
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID
  param_list->param_list ',' param_decl
  func_decl->type_specifier pointers ID '(' param_list ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  unary->ID
  binary->unary
  unary->ID
  binary->unary
  binary->binary RELOP binary
  expr->binary
  expr_e->expr
  unary->ID
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->ID
  binary->unary
  unary->ID
  unary->ID
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->ID
  binary->unary
  binary->binary '/' binary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID
  param_list->param_decl
  func_decl->type_specifier pointers ID '(' param_list ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  unary->ID
  binary->unary
  unary->ID
  binary->unary
  binary->binary RELOP binary
  expr->binary
  expr_e->expr
  unary->ID
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->ID
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  binary->unary
  unary->ID
  binary->unary
  binary->binary EQUOP binary
  expr->binary
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->IF '(' expr ')' stmt
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt
  stmt_list->stmt_list stmt
  unary->INTEGER_CONST
  unary->'-' unary
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->'*'
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->'*' unary
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  unary->'(' expr ')'
  unary->'*' unary
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  unary->'(' expr ')'
  unary->'*' unary
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  unary->'(' expr ')'
  unary->'*' unary
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  unary->'(' expr ')'
  unary->'*' unary
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  args->expr
  unary->unary '(' args ')'
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  unary->'-' unary
  binary->unary
  binary->binary EQUOP binary
  expr->binary
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->ID
  unary->ID
  unary->ID
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->unary '.' ID
  binary->unary
  expr->binary
  args->expr
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  args->args ',' expr
  unary->unary '(' args ')'
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->IF '(' expr ')' stmt
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

  $ ../../src/main.exe --emit-log < control_flow.c
  ext_def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary EQUOP binary
  expr->binary
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->IF '(' expr ')' stmt ELSE stmt
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary RELOP binary
  expr->binary
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->ID
  binary->unary
  unary->ID
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->WHILE '(' expr ')' stmt
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary RELOP binary
  expr->binary
  expr_e->expr
  unary->ID
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  expr_e->expr
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary EQUOP binary
  expr->binary
  def_list->epsilon
  stmt_list->epsilon
  stmt->CONTINUE ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->IF '(' expr ')' stmt
  stmt_list->stmt_list stmt
  unary->ID
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '*' binary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary RELOP binary
  expr->binary
  def_list->epsilon
  stmt_list->epsilon
  stmt->BREAK ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->IF '(' expr ')' stmt
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->FOR '(' expr_e ';' expr_e ';' expr_e ')' stmt
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

  $ ../../src/main.exe --emit-log < functions.c
  ext_def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID
  param_list->param_decl
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID
  param_list->param_list ',' param_decl
  func_decl->type_specifier pointers ID '(' param_list ')'
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  binary->unary
  unary->ID
  binary->unary
  binary->binary '+' binary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID '[' INTEGER_CONST ']'
  param_list->param_decl
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID
  param_list->param_list ',' param_decl
  func_decl->type_specifier pointers ID '(' param_list ')'
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->ID
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  type_specifier->TYPE
  pointers->epsilon
  param_decl->type_specifier pointers ID
  param_list->param_decl
  func_decl->type_specifier pointers ID '(' param_list ')'
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary RELOP binary
  expr->binary
  def_list->epsilon
  stmt_list->epsilon
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  stmt->compound_stmt
  stmt->IF '(' expr ')' stmt
  stmt_list->stmt_list stmt
  unary->ID
  binary->unary
  unary->ID
  unary->ID
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '-' binary
  expr->binary
  args->expr
  unary->unary '(' args ')'
  binary->unary
  binary->binary '*' binary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  args->expr
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  args->args ',' expr
  unary->unary '(' args ')'
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  unary->unary '[' expr ']'
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  args->expr
  unary->unary '(' args ')'
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

  $ ../../src/main.exe --emit-log < invalid_features.c
  ext_def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  stmt_list->epsilon
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

  $ ../../src/main.exe --emit-log < nested_comments.c
  ext_def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

  $ ../../src/main.exe --emit-log < pointers.c
  ext_def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  ext_def->type_specifier pointers ID ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  type_specifier->TYPE
  pointers->'*'
  param_decl->type_specifier pointers ID
  param_list->param_decl
  func_decl->type_specifier pointers ID '(' param_list ')'
  def_list->epsilon
  stmt_list->epsilon
  unary->ID
  unary->'*' unary
  unary->ID
  unary->'*' unary
  binary->unary
  unary->INTEGER_CONST
  binary->unary
  binary->binary '+' binary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->'*' unary
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->'*'
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->'*'
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->ID
  unary->'&' unary
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->ID
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->'*' unary
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->'*' unary
  unary->CHAR_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->ID
  unary->'&' unary
  binary->unary
  expr->binary
  args->expr
  unary->unary '(' args ')'
  binary->unary
  expr->binary
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->'*' unary
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

  $ ../../src/main.exe --emit-log < structs.c
  ext_def_list->epsilon
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  struct_specifier->STRUCT ID '{' def_list '}'
  ext_def->struct_specifier ';'
  ext_def_list->ext_def_list ext_def
  def_list->epsilon
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID '[' INTEGER_CONST ']' ';'
  def_list->def_list def
  type_specifier->TYPE
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  struct_specifier->STRUCT ID '{' def_list '}'
  ext_def->struct_specifier ';'
  ext_def_list->ext_def_list ext_def
  type_specifier->TYPE
  pointers->epsilon
  func_decl->type_specifier pointers ID '(' ')'
  def_list->epsilon
  struct_specifier->STRUCT ID
  type_specifier->struct_specifier
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  struct_specifier->STRUCT ID
  type_specifier->struct_specifier
  pointers->epsilon
  def->type_specifier pointers ID ';'
  def_list->def_list def
  stmt_list->epsilon
  unary->ID
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->ID
  unary->unary '.' ID
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  expr->unary '=' expr
  stmt->expr ';'
  stmt_list->stmt_list stmt
  unary->INTEGER_CONST
  binary->unary
  expr->binary
  stmt->RETURN expr ';'
  stmt_list->stmt_list stmt
  compound_stmt->'{' def_list stmt_list '}'
  ext_def->func_decl compound_stmt
  ext_def_list->ext_def_list ext_def
  program->ext_def_list

