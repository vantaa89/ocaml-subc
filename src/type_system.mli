open! Sexplib0.Sexp_conv

type t = 
| Int 
| Char 
| Null 
| Struct of string
| Array of t * int
| Pointer of t
[@@deriving sexp_of]

and struct_entry = {
  entry_name: string;
  entry_type: t;
}
[@@deriving sexp_of]

val size_of: lookup:(string -> struct_entry list) -> t -> int
