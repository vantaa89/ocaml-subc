exception Type_error of string

val type_of_expr: Environment.t -> Ast.expr -> Type_system.t * exn list
val check_expr: Environment.t -> Ast.expr -> exn list
val check_program : Ast.program -> Environment.t * exn list
val check_statement: Environment.t -> Ast.statement -> Environment.t * exn list