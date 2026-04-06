open! Sexplib0.Sexp_conv

type t = 
| Int 
| Char 
| Null 
| Struct of string * entry list
| Array of t * int
| Pointer of t

and entry = {
  entry_name: string;
  entry_type: t;
}
[@@deriving sexp_of]

val size_of: lookup:(string -> entry list) -> t -> int
val wrap_pointer: t -> int -> t

val comparable: t -> t -> bool
val assignable: t -> t -> bool
val equal: t -> t -> bool