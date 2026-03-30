exception No_local_scope
exception Duplicate_declaration of string
exception Unbound_symbol of string

module StringMap : sig 
    type nonrec 'v t 
end

type t

type decl 

type scope

val declare_global: t -> string -> decl -> t
val declare_local: t -> string -> decl -> t
val fetch_decl: t -> string -> decl
