open! Sexplib0.Sexp_conv

type unary_op =
  | Neg
  | Not
  | Pre_inc
  | Pre_dec
  | Addr_of
  | Deref
[@@deriving sexp_of]

type postfix_op =
  | Post_inc
  | Post_dec
[@@deriving sexp_of]

type binary_op =
  | Eq
  | Ne
  | Lt
  | Le
  | Gt
  | Ge
  | Add
  | Sub
  | Mul
  | Div
  | Mod
  | Logical_and
  | Logical_or
[@@deriving sexp_of]

type expr =
  | Assign of expr * expr
  | Binary of binary_op * expr * expr
  | Unary of unary_op * expr
  | Postfix of postfix_op * expr
  | Index of expr * expr
  | Field of expr * string
  | Ptr_field of expr * string
  | Call of expr * expr list
  | Int_const of int
  | Char_const of string
  | String_const of string
  | Identifier of string
  | Null
[@@deriving sexp_of]

type decl_statement =
  { type_ : Type_system.t
  ; pointer_depth : int
  ; name : string
  ; array_size : int option
  }
[@@deriving sexp_of]

type stmt_kind =
  | Global_decl of decl_statement
  | Local_decl of decl_statement
  | Struct_def of string * decl_statement list
  | Func_def of func_decl * statement list
  | Expr of expr
  | Return of expr
  | Empty
  | If of expr * statement * statement option
  | While of expr * statement
  | For of expr option * expr option * expr option * statement
  | Break
  | Continue
  | Block of statement list

and statement =
  { line : int
  ; kind : stmt_kind
  }

and func_decl =
  { return_type : Type_system.t
  ; pointer_depth : int
  ; name : string
  ; params : decl_statement list
  }
[@@deriving sexp_of]

type program = statement list
[@@deriving sexp_of]

let is_lvalue = function
  | Identifier _ | Index _ | Field _ | Ptr_field _ -> true
  | Unary (Deref, _) -> true
  | _ -> false

let entry_of_decl { type_; pointer_depth; name; array_size } =
  let entry_type = Type_system.wrap_pointer type_ pointer_depth in
  match array_size with
  | None -> Type_system.{ entry_name = name; entry_type }
  | Some array_size -> Type_system.{ entry_name = name; entry_type = Array (entry_type, array_size) }
