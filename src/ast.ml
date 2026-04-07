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
  { line : int
  ; type_ : Type_system.t
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

let entry_of_decl { type_; pointer_depth; name; array_size; _ } =
  let entry_type = Type_system.wrap_pointer type_ pointer_depth in
  match array_size with
  | None -> Type_system.{ entry_name = name; entry_type }
  | Some array_size -> Type_system.{ entry_name = name; entry_type = Array (entry_type, array_size) }


(* Pretty-printing: AST -> source code *)

let string_of_base_type = function
  | Type_system.Int -> "int"
  | Type_system.Char -> "char"
  | Type_system.Struct_ref name | Type_system.Struct (name, _) -> "struct " ^ name
  | _ -> "int"

let rec decompose_entry_type = function
  | Type_system.Pointer inner ->
    let (base, depth, arr) = decompose_entry_type inner in
    (base, depth + 1, arr)
  | Type_system.Array (inner, size) ->
    let (base, depth, _) = decompose_entry_type inner in
    (base, depth, Some size)
  | base -> (base, 0, None)

let string_of_type_entry { Type_system.entry_name; entry_type } =
  let (base, depth, arr) = decompose_entry_type entry_type in
  let type_str = string_of_base_type base in
  let ptr_str = if depth > 0 then " " ^ String.make depth '*' else " " in
  let arr_str = match arr with None -> "" | Some n -> "[" ^ string_of_int n ^ "]" in
  type_str ^ ptr_str ^ entry_name ^ arr_str ^ ";\n"

let string_of_decl (d : decl_statement) =
  let ptr_str = if d.pointer_depth > 0 then " " ^ String.make d.pointer_depth '*' else " " in
  let arr_str = match d.array_size with
    | None -> ""
    | Some n -> "[" ^ string_of_int n ^ "]"
  in
  match d.type_ with
  | Type_system.Struct (name, entries) ->
    "struct " ^ name ^ " {\n" ^
    String.concat "" (List.map string_of_type_entry entries) ^
    "}" ^ ptr_str ^ d.name ^ arr_str
  | _ ->
    string_of_base_type d.type_ ^ ptr_str ^ d.name ^ arr_str

let string_of_binop = function
  | Eq -> "==" | Ne -> "!="
  | Lt -> "<" | Le -> "<=" | Gt -> ">" | Ge -> ">="
  | Add -> "+" | Sub -> "-" | Mul -> "*" | Div -> "/" | Mod -> "%"
  | Logical_and -> "&&" | Logical_or -> "||"

let string_of_unaryop = function
  | Neg -> "-" | Not -> "!" | Pre_inc -> "++" | Pre_dec -> "--"
  | Addr_of -> "&" | Deref -> "*"

let string_of_postfixop = function
  | Post_inc -> "++" | Post_dec -> "--"

let prec_of_binop = function
  | Logical_or -> 2
  | Logical_and -> 3
  | Eq | Ne -> 4
  | Lt | Le | Gt | Ge -> 5
  | Add | Sub -> 6
  | Mul | Div | Mod -> 7

let prec_of_expr = function
  | Assign _ -> 1
  | Binary (op, _, _) -> prec_of_binop op
  | Unary _ -> 8
  | Postfix _ | Index _ | Field _ | Ptr_field _ | Call _ -> 9
  | Int_const _ | Char_const _ | String_const _ | Identifier _ | Null -> 10

let rec string_of_expr_prec ctx expr =
  let s = string_of_expr_raw expr in
  let p = prec_of_expr expr in
  if p < ctx then "(" ^ s ^ ")" else s

and string_of_expr_raw = function
  | Int_const n -> string_of_int n
  | Char_const s -> "'" ^ s ^ "'"
  | String_const s -> "\"" ^ s ^ "\""
  | Identifier s -> s
  | Null -> "NULL"
  | Assign (lhs, rhs) ->
    string_of_expr_prec 8 lhs ^ " = " ^ string_of_expr_prec 1 rhs
  | Binary (op, lhs, rhs) ->
    let p = prec_of_binop op in
    string_of_expr_prec p lhs ^ " " ^ string_of_binop op ^ " " ^ string_of_expr_prec (p + 1) rhs
  | Unary (op, e) ->
    let op_str = string_of_unaryop op in
    let e_str = string_of_expr_prec 8 e in
    let needs_space = match op with
      | Neg -> String.length e_str > 0 && e_str.[0] = '-'
      | Addr_of -> String.length e_str > 0 && e_str.[0] = '&'
      | _ -> false
    in
    if needs_space then op_str ^ " " ^ e_str else op_str ^ e_str
  | Postfix (op, e) ->
    string_of_expr_prec 9 e ^ string_of_postfixop op
  | Index (e, idx) ->
    string_of_expr_prec 9 e ^ "[" ^ string_of_expr_prec 0 idx ^ "]"
  | Field (e, f) ->
    string_of_expr_prec 9 e ^ "." ^ f
  | Ptr_field (e, f) ->
    string_of_expr_prec 9 e ^ "->" ^ f
  | Call (e, args) ->
    string_of_expr_prec 9 e ^ "(" ^
    String.concat ", " (List.map (string_of_expr_prec 0) args) ^
    ")"

let string_of_expr e = string_of_expr_prec 0 e

let string_of_func_decl ({ return_type; pointer_depth; name; params } : func_decl) =
  let type_str = string_of_base_type return_type in
  let ptr_str = if pointer_depth > 0 then " " ^ String.make pointer_depth '*' else " " in
  let params_str = String.concat ", " (List.map string_of_decl params) in
  type_str ^ ptr_str ^ name ^ "(" ^ params_str ^ ")"

let indent_str n = String.make (n * 4) ' '

let rec needs_block_for_else stmt =
  match stmt.kind with
  | If (_, _, None) -> true
  | If (_, _, Some else_stmt) -> needs_block_for_else else_stmt
  | While (_, body) | For (_, _, _, body) -> needs_block_for_else body
  | _ -> false

let rec string_of_stmt indent ({ kind; _ } : statement) =
  let ind = indent_str indent in
  match kind with
  | Global_decl d | Local_decl d -> ind ^ string_of_decl d ^ ";\n"
  | Struct_def (name, members) ->
    ind ^ "struct " ^ name ^ " {\n" ^
    String.concat "" (List.map (fun d -> indent_str (indent + 1) ^ string_of_decl d ^ ";\n") members) ^
    ind ^ "};\n"
  | Func_def (decl, body) ->
    ind ^ string_of_func_decl decl ^ " {\n" ^
    String.concat "" (List.map (string_of_stmt (indent + 1)) body) ^
    ind ^ "}\n"
  | Expr e -> ind ^ string_of_expr e ^ ";\n"
  | Return e -> ind ^ "return " ^ string_of_expr e ^ ";\n"
  | Empty -> ind ^ ";\n"
  | If (cond, then_stmt, None) ->
    ind ^ "if (" ^ string_of_expr cond ^ ") " ^ string_of_stmt_body indent then_stmt
  | If (cond, then_stmt, Some else_stmt) ->
    let then_str =
      if needs_block_for_else then_stmt then
        "{\n" ^ string_of_stmt (indent + 1) then_stmt ^ ind ^ "}\n"
      else
        string_of_stmt_body indent then_stmt
    in
    ind ^ "if (" ^ string_of_expr cond ^ ") " ^ then_str ^
    ind ^ "else " ^ string_of_stmt_body indent else_stmt
  | While (cond, body) ->
    ind ^ "while (" ^ string_of_expr cond ^ ") " ^ string_of_stmt_body indent body
  | For (init, cond, step, body) ->
    ind ^ "for (" ^
    (match init with None -> "" | Some e -> string_of_expr e) ^ "; " ^
    (match cond with None -> "" | Some e -> string_of_expr e) ^ "; " ^
    (match step with None -> "" | Some e -> string_of_expr e) ^ ") " ^
    string_of_stmt_body indent body
  | Break -> ind ^ "break;\n"
  | Continue -> ind ^ "continue;\n"
  | Block stmts ->
    ind ^ "{\n" ^ String.concat "" (List.map (string_of_stmt (indent + 1)) stmts) ^ ind ^ "}\n"

and string_of_stmt_body indent stmt =
  match stmt.kind with
  | Block stmts ->
    "{\n" ^
    String.concat "" (List.map (string_of_stmt (indent + 1)) stmts) ^
    indent_str indent ^ "}\n"
  | _ ->
    "\n" ^ string_of_stmt (indent + 1) stmt

let string_of_program stmts =
  String.concat "" (List.map (string_of_stmt 0) stmts)
