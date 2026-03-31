open Base

let check_statement env statement =
  match statement with
  | Ast.Global_decl decl ->
    Environment.declare_global decl.name (Environment.decl_of_ast decl) env
  (* TODO: complete this *)
  | Ast.Local_decl _decl -> env
  | Ast.Struct_def (_name, _fields) -> env
  | Ast.Func_def (_func_decl, _body) -> env
  | Ast.Expr _expr -> env
  | Ast.Return _expr -> env
  | Ast.Empty -> env
  | Ast.If (_cond, _then_, _else_) -> env
  | Ast.While (_cond, _body) -> env
  | Ast.For (_init, _cond, _step, _body) -> env
  | Ast.Break -> env
  | Ast.Continue -> env
  | Ast.Block _stmts -> env

let check_program ~on_exn:`Abort program = 
  let env = Environment.empty in
  List.fold program ~init:env
  ~f:check_statement
