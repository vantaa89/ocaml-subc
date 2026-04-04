exception Type_error of int * string

val type_of_expr: line:int -> Environment.t -> Ast.expr -> Type_system.t * exn list
val check_expr: line:int -> Environment.t -> Ast.expr -> exn list
val check_program : Ast.program -> Environment.t * exn list
val check_statement: Environment.t -> Ast.statement -> Environment.t * exn list
