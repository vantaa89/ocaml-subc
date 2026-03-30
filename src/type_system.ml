type t = 
| Int 
| Char 
| Null 
| Struct of struct_entry list
| Array of t * int
| Pointer of t
| Function of { params: t list; ret: t}

and struct_entry = {
  entry_name: string;
  entry_type: t
}

let rec size_of = function
| Int | Char -> 1   (* TODO: all primitive data types have the same unit size *)
| Null -> 0
| Struct [] -> 0
| Struct (hd::tl) -> 
  size_of hd.entry_type + size_of (Struct tl)
| Array (t, n_elem) -> (size_of t) * n_elem
| Pointer _ -> 1
| Function _ -> 1

