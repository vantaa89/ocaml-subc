open! Base
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
  entry_type: t
}
[@@deriving sexp_of, equal]

let rec size_of ~lookup = function
| Int | Char -> 1   (* TODO: all primitive data types have the same unit size *)
| Null -> 0
| Struct (name, _) ->
  let entries = lookup name in
  List.fold entries ~init:0 ~f:(fun acc e -> acc + size_of ~lookup e.entry_type)
| Array (t, n_elem) -> (size_of ~lookup t) * n_elem
| Pointer _ -> 1

let rec wrap_pointer type_ pointer_depth =
  if pointer_depth = 0 then
    type_
else Pointer (wrap_pointer type_ (pointer_depth-1))


let comparable lhs rhs =
  (equal lhs Int && equal rhs Int) ||
  (equal lhs Char && equal rhs Char) ||
  (match lhs, rhs with
   | Pointer a, Pointer b -> equal a b
   | _ -> false)

let assignable lhs rhs =
  equal lhs rhs ||
  match lhs, rhs with
  | Pointer _, Null -> true
  | _ -> false