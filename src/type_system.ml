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
[@@deriving sexp_of]

let rec equal a b =
  match a, b with
  | Int, Int | Char, Char | Null, Null -> true
  | Struct (n1, _), Struct (n2, _) -> String.equal n1 n2
  | Array (t1, s1), Array (t2, s2) -> s1 = s2 && equal t1 t2
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

let rec wrap_pointer type_ pointer_depth =
  if pointer_depth = 0 then
    type_
else Pointer (wrap_pointer type_ (pointer_depth-1))


let comparable lhs rhs =
  (equal lhs Int && equal rhs Int) ||
  (equal lhs Char && equal rhs Char) ||
  (match lhs, rhs with
   | Pointer a, Pointer b -> equal a b
   | Pointer _, Null | Null, Pointer _ -> true
   | _ -> false)

let assignable lhs rhs =
  equal lhs rhs ||
  match lhs, rhs with
  | Pointer _, Null -> true
  | Array (t1, _), Array (t2, _) when t1 = t2 -> true
  | _ -> false