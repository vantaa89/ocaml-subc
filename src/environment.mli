exception No_local_scope
exception Duplicate_declaration of string
exception Unbound_symbol of string

module StringMap : sig 
    type nonrec 'v t 
end

type t

type decl 

type scope

val empty: t

val declare_global: t -> string -> decl -> t
val declare_local: t -> string -> decl -> t
val fetch_decl: t -> string -> decl

val push_scope: t -> t
val pop_scope: t -> t * scope

val alist_of_scope: scope -> (string * decl) list
