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
  entry_type: t
}
[@@deriving sexp_of]

let rec size_of ~lookup = function
| Int | Char -> 1   (* TODO: all primitive data types have the same unit size *)
| Null -> 0
| Struct name ->
  let entries = lookup name in
  List.fold_left (fun acc e -> acc + size_of ~lookup e.entry_type) 0 entries
| Array (t, n_elem) -> (size_of ~lookup t) * n_elem
| Pointer _ -> 1
