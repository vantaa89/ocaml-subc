exception No_local_scope

type decl =
  | Var of
      { type_ : Type_system.t
      }
  | Const of
      { type_ : Type_system.t
      ; value : int option
      }
  | Func of
      { return_type : Type_system.t
      ; params : Type_system.entry list
      }
  | Struct_type of Type_system.t

type scope

type t

val empty : t

val declare_global : t -> string -> decl -> t
val declare_local : t -> string -> decl -> t
val fetch_decl : t -> string -> decl option
val struct_entries : t -> string -> Type_system.entry list

val push_scope : t -> t
val pop_scope : t -> scope * t

val decl_of_ast : Ast.decl_statement -> decl

val is_declared_global : t -> string -> bool
val is_func : t -> string -> bool
val is_struct_defined : t -> Type_system.t -> bool
val is_declared_current_scope : t -> string -> bool

val push_func_frame : t -> decl -> t
val pop_func_frame : t -> t
val current_func_decl: t -> decl option

val enter_loop : t -> t
val exit_loop : t -> t
val in_loop : t -> bool