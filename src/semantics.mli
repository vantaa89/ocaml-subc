val check_program : on_exn:[`Abort] -> Ast.program -> Environment.t * exn list
val check_statement: Environment.t -> Ast.statement -> Environment.t * exn list

val type_of_expr: Environment.t -> Ast.expr -> Type_system.t
