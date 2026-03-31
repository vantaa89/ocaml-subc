exception No_local_scope
exception Duplicate_declaration of string
exception Unbound_symbol of string

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
      ; params : (string * Type_system.t) list
      }
  | Struct of Type_system.struct_entry list

type scope

type t

val empty : t

val declare_global : string -> decl -> t -> t
val declare_local : string -> decl -> t -> t
val fetch_decl : string -> t -> decl

val push_scope : t -> t
val pop_scope : t -> scope * t
