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

type declarator =
  { name : string
  ; pointer_depth : int
  ; array_size : int option
  }
[@@deriving sexp_of]

type def =
  { decl_type : Type_system.t
  ; declarator : declarator
  }
[@@deriving sexp_of]

type param_decl = def
[@@deriving sexp_of]

type struct_specifier =
  { name : string
  ; def_list : def list option
  }
[@@deriving sexp_of]

type stmt =
  | Expr of expr
  | Compound of compound_stmt
  | Return of expr
  | Empty
  | If of expr * stmt * stmt option
  | While of expr * stmt
  | For of expr option * expr option * expr option * stmt
  | Break
  | Continue
[@@deriving sexp_of]

and compound_stmt =
  { def_list : def list
  ; stmt_list : stmt list
  }
[@@deriving sexp_of]

type func_decl =
  { return_type : Type_system.t
  ; pointer_depth : int
  ; name : string
  ; param_list : param_decl list
  }
[@@deriving sexp_of]

type ext_def =
  | Global_decl of def
  | Struct_decl of struct_specifier
  | Function_def of func_decl * compound_stmt
[@@deriving sexp_of]

type program = ext_def list
[@@deriving sexp_of]
