open! Base

type t =
| Int
| Char
| Null
| Struct of string * struct_entry list option
| Array of t * int
| Pointer of t

and struct_entry = {
  entry_name: string;
  entry_type: t
}
[@@deriving sexp_of]

let rec equal a b = match a, b with
  | Int, Int | Char, Char | Null, Null -> true
  | Struct (n1, _), Struct (n2, _) -> String.equal n1 n2
  | Array (t1, n1), Array (t2, n2) -> equal t1 t2 && n1 = n2
  | Pointer t1, Pointer t2 -> equal t1 t2
  | _ -> false

let rec size_of ~lookup = function
| Int | Char -> 1   (* TODO: all primitive data types have the same unit size *)
| Null -> 0
| Struct (name, _) ->
  let entries = lookup name in
  List.fold entries ~init:0 ~f:(fun acc e -> acc + size_of ~lookup e.entry_type)
| Array (t, n_elem) -> (size_of ~lookup t) * n_elem
| Pointer _ -> 1
