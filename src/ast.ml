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

type type_spec =
  | Int
  | Char
  | Struct of string
[@@deriving sexp_of]

type decl =
  { type_ : type_spec
  ; pointer_depth : int
  ; name : string
  ; array_size : int option
  }
[@@deriving sexp_of]

type statement =
  | Global_decl of decl
  | Local_decl of decl
  | Struct_def of string * decl list
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
[@@deriving sexp_of]

and func_decl =
  { return_type : type_spec
  ; pointer_depth : int
  ; name : string
  ; params : decl list
  }
[@@deriving sexp_of]

type program = statement list
[@@deriving sexp_of]
