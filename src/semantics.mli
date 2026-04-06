exception Lvalue_not_assignable
exception Null_to_non_pointer
exception Incompatible_assignment
exception Invalid_binary_operands
exception Invalid_unary_operand
exception Not_comparable
exception Indirection_requires_pointer
exception Rvalue_address
exception Not_a_struct
exception Not_a_struct_pointer
exception No_such_member
exception Not_an_array
exception Subscript_not_integer
exception Incomplete_type
exception Incompatible_return_types
exception Not_a_function
exception Incompatible_arguments
exception Break_outside_loop
exception Continue_outside_loop

val check_program : on_exn:[`Abort] -> Ast.program -> Environment.t * exn list
val check_statement: Environment.t -> Ast.statement -> Environment.t * exn list

val type_of_expr: Environment.t -> Ast.expr -> Type_system.t

val string_of_error : exn -> string
