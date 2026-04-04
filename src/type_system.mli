open! Sexplib0.Sexp_conv

type t =
| Int
| Char
| Null
| Struct of string * struct_entry list option
| Array of t * int
| Pointer of t

and struct_entry = {
  entry_name: string;
  entry_type: t;
}
[@@deriving sexp_of]

val equal : t -> t -> bool

val size_of: lookup:(string -> struct_entry list) -> t -> int
