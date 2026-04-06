open Base

(* 3.3.1 Assignment *)
exception Lvalue_not_assignable
exception Null_to_non_pointer
exception Incompatible_assignment

(* 3.3.2 Binary operators *)
exception Invalid_binary_operands

(* 3.3.3 Unary operators *)
exception Invalid_unary_operand

(* 3.3.4/5 Relational & Equality *)
exception Not_comparable

(* 3.3.6 Indirection *)
exception Indirection_requires_pointer

(* 3.3.7 Address-of *)
exception Rvalue_address

(* 3.3.8 Member access *)
exception Not_a_struct
exception Not_a_struct_pointer
exception No_such_member

(* 3.3.9 Subscript *)
exception Not_an_array
exception Subscript_not_integer

(* 3.4 Struct declarations *)
exception Incomplete_type

(* 3.5 Function declarations *)
exception Incompatible_return_types
exception Not_a_function
exception Incompatible_arguments

(* Extra *)
exception Break_outside_loop
exception Continue_outside_loop

let rec type_of_expr env expr =
  match expr with
  | Ast.Assign (lhs, _rhs) -> type_of_expr env lhs
  | Ast.Binary (_op, lhs, rhs) ->
    ignore (type_of_expr env lhs);
    ignore (type_of_expr env rhs);
    Type_system.Int
  | Ast.Unary (op, expr) ->
    let ty = type_of_expr env expr in
    (match op with
     | Neg | Not | Pre_inc | Pre_dec -> ty
     | Addr_of -> Pointer ty
     | Deref ->
       (match ty with
        | Pointer inner -> inner
        | _ -> ty))
  | Ast.Postfix (_op, expr) -> type_of_expr env expr
  | Ast.Index (arr, _idx) ->
    (match type_of_expr env arr with
     | Array (elem_ty, _) -> elem_ty
     | Pointer elem_ty -> elem_ty
     | ty -> ty)
  | Ast.Field (expr, name) ->
    (match type_of_expr env expr with
     | Struct (_, entries) ->
       (match List.find entries ~f:(fun e -> String.equal e.entry_name name) with
        | Some e -> e.entry_type
        | None -> Int)
     | _ -> Int)
  | Ast.Ptr_field (expr, name) ->
    (match type_of_expr env expr with
     | Pointer (Struct (_, entries)) ->
       (match List.find entries ~f:(fun e -> String.equal e.entry_name name) with
        | Some e -> e.entry_type
        | None -> Int)
     | _ -> Int)
  | Ast.Call (func_expr, _args) ->
    (match func_expr with
     | Ast.Identifier name ->
       (try match Environment.fetch_decl env name with
        | Environment.Func { return_type; _ } -> return_type
        | _ -> Int
       with Environment.Unbound_symbol _ -> Int)
     | _ -> type_of_expr env func_expr)
  | Ast.Int_const _ -> Type_system.Int
  | Ast.Char_const _ -> Type_system.Char
  | Ast.String_const _ -> Type_system.Pointer Char
  | Ast.Identifier name ->
    (try match Environment.fetch_decl env name with
     | Environment.Var { type_ } -> type_
     | Environment.Const { type_; _ } -> type_
     | Environment.Func { return_type; _ } -> return_type
     | Environment.Struct_type t -> t
    with Environment.Unbound_symbol _ -> Int)
  | Ast.Null -> Type_system.Null

let rec check_expr env expr =
  match expr with
  | Ast.Assign (lhs, rhs) ->
    let sub_errors = check_expr env rhs @ check_expr env lhs in
    let assign_error =
      if not (Ast.is_lvalue lhs) then
        [Lvalue_not_assignable]
      else
        let lhs_ty = type_of_expr env lhs in
        let rhs_ty = type_of_expr env rhs in
        if Type_system.equal rhs_ty Null then
          (match lhs_ty with Pointer _ -> [] | _ -> [Null_to_non_pointer])
        else if not (Type_system.equal lhs_ty rhs_ty) then
          [Incompatible_assignment]
        else []
    in
    sub_errors @ assign_error

  | Ast.Binary (op, lhs, rhs) ->
    let sub_errors = check_expr env rhs @ check_expr env lhs in
    let lhs_ty = type_of_expr env lhs in
    let rhs_ty = type_of_expr env rhs in
    let op_error = match op with
      | Add | Sub | Mul | Div | Mod | Logical_and | Logical_or ->
        if not (Type_system.equal lhs_ty Int) || not (Type_system.equal rhs_ty Int)
        then [Invalid_binary_operands] else []
      | Lt | Le | Gt | Ge | Eq | Ne ->
        if not (Type_system.comparable lhs_ty rhs_ty) then [Not_comparable] else []
    in
    sub_errors @ op_error

  | Ast.Unary (op, inner) ->
    let sub_errors = check_expr env inner in
    let ty = type_of_expr env inner in
    let op_error = match op with
      | Neg | Not ->
        if not (Type_system.equal ty Int) then [Invalid_unary_operand] else []
      | Pre_inc | Pre_dec ->
        if not (Type_system.equal ty Int || Type_system.equal ty Char)
        then [Invalid_unary_operand] else []
      | Deref ->
        (match ty with Pointer _ -> [] | _ -> [Indirection_requires_pointer])
      | Addr_of ->
        if not (Ast.is_lvalue inner) then [Rvalue_address] else []
    in
    sub_errors @ op_error

  | Ast.Postfix (_op, inner) ->
    let sub_errors = check_expr env inner in
    let ty = type_of_expr env inner in
    let op_error =
      if not (Type_system.equal ty Int || Type_system.equal ty Char)
      then [Invalid_unary_operand] else []
    in
    sub_errors @ op_error

  | Ast.Index (arr, idx) ->
    let sub_errors = check_expr env idx @ check_expr env arr in
    let arr_ty = type_of_expr env arr in
    let idx_ty = type_of_expr env idx in
    let arr_error = match arr_ty with
      | Array _ | Pointer _ -> []
      | _ -> [Not_an_array]
    in
    let idx_error =
      if not (Type_system.equal idx_ty Int) then [Subscript_not_integer] else []
    in
    sub_errors @ idx_error @ arr_error

  | Ast.Field (expr, name) ->
    let sub_errors = check_expr env expr in
    let field_errors = match type_of_expr env expr with
      | Struct (_, entries) ->
        if List.exists entries ~f:(fun e -> String.equal e.entry_name name)
        then [] else [No_such_member]
      | _ -> [Not_a_struct]
    in
    sub_errors @ field_errors

  | Ast.Ptr_field (expr, name) ->
    let sub_errors = check_expr env expr in
    let field_errors = match type_of_expr env expr with
      | Pointer (Struct (_, entries)) ->
        if List.exists entries ~f:(fun e -> String.equal e.entry_name name)
        then [] else [No_such_member]
      | _ -> [Not_a_struct_pointer]
    in
    sub_errors @ field_errors

  | Ast.Call (func_expr, args) ->
    let func_errors = check_expr env func_expr in
    let args_errors = List.fold args ~init:[] ~f:(fun errs arg ->
      check_expr env arg @ errs) in
    let call_errors = match func_expr with
      | Ast.Identifier name ->
        (try match Environment.fetch_decl env name with
         | Environment.Func { params; _ } ->
           (match List.for_all2 args params ~f:(fun arg param ->
              Type_system.assignable param.entry_type (type_of_expr env arg))
            with
            | Ok true -> []
            | _ -> [Incompatible_arguments])
         | _ -> [Not_a_function]
        with Environment.Unbound_symbol _ -> [])
      | _ -> []
    in
    args_errors @ func_errors @ call_errors

  | Ast.Identifier name ->
    (try ignore (Environment.fetch_decl env name); []
     with Environment.Unbound_symbol _ -> [Environment.Unbound_symbol name])

  | Ast.Int_const _ | Ast.Char_const _ | Ast.String_const _ | Ast.Null -> []

let rec check_statement env statement =
  match statement with
  | Ast.Global_decl decl ->
    if Environment.is_declared_global env decl.name then
      (env, [Environment.Duplicate_declaration decl.name])
    else
      let env = Environment.declare_global env decl.name (Environment.decl_of_ast decl) in
      (env, [])
  | Ast.Local_decl decl ->
    if Environment.is_declared_current_scope env decl.name then
      (env, [Environment.Duplicate_declaration decl.name])
    else
      let env = Environment.declare_local env decl.name (Environment.decl_of_ast decl) in
      (env, [])
  | Ast.Struct_def (name, fields) ->
    if Environment.is_declared_global env name then
      (env, [Environment.Duplicate_declaration name])
    else
      let struct_entry_list = List.map fields ~f:Ast.entry_of_decl in
      let struct_type = Type_system.Struct (name, struct_entry_list) in
      let env = Environment.declare_global env name (Environment.Struct_type struct_type) in
      (env, [])
  | Ast.Func_def (func_decl, body) ->
    let name = func_decl.name in
    if Environment.is_declared_global env name then
      (env, [Environment.Duplicate_declaration name])
    else
      let func_decl = Environment.Func {
        return_type = func_decl.return_type;
        params = List.map func_decl.params ~f:Ast.entry_of_decl
      } in
      let env = Environment.declare_global env name func_decl in
      let env = Environment.push_func_frame env func_decl in
      let _, body_error_list = List.fold body ~init:(env, []) ~f:(fun (env, errors) stmt ->
        let (env, new_err) = check_statement env stmt in
        (env, new_err @ errors)
      ) in
      let env = Environment.pop_func_frame env in
      (env, body_error_list)
  | Ast.Expr expr -> (env, check_expr env expr)
  (* 3.5 Return type check *)
  | Ast.Return expr ->
    let expr_errors = check_expr env expr in
    let return_errors = match Environment.current_func_decl env with
      | Some (Environment.Func { return_type; _ }) ->
        let ret_ty = type_of_expr env expr in
        if Type_system.equal ret_ty Null then
          (match return_type with Pointer _ -> [] | _ -> [Incompatible_return_types])
        else if not (Type_system.equal return_type ret_ty) then
          [Incompatible_return_types]
        else []
      | _ -> [Incompatible_return_types]
    in
    (env, return_errors @ expr_errors)
  | Ast.Empty -> (env, [])
  | Ast.If (cond, then_, else_) ->
    let cond_errors = check_expr env cond in
    let (env, then_errors) = check_statement env then_ in
    let (env, else_errors) = match else_ with
      | Some s -> check_statement env s
      | None -> (env, [])
    in
    (env, else_errors @ then_errors @ cond_errors)
  | Ast.While (cond, body) ->
    let cond_errors = check_expr env cond in
    let env = Environment.enter_loop env in
    let (env, body_errors) = check_statement env body in
    let env = Environment.exit_loop env in
    (env, body_errors @ cond_errors)
  | Ast.For (init, cond, step, body) ->
    let init_errors = match init with
      | Some e -> check_expr env e
      | None -> []
    in
    let cond_errors = match cond with
      | Some e -> check_expr env e
      | None -> []
    in
    let step_errors = match step with
      | Some e -> check_expr env e
      | None -> []
    in
    let env = Environment.enter_loop env in
    let (env, body_errors) = check_statement env body in
    let env = Environment.exit_loop env in
    (env, body_errors @ step_errors @ cond_errors @ init_errors)
  | Ast.Break ->
    if Environment.in_loop env then (env, [])
    else (env, [Break_outside_loop])
  | Ast.Continue ->
    if Environment.in_loop env then (env, [])
    else (env, [Continue_outside_loop])
  | Ast.Block stmts ->
    let env = Environment.push_scope env in
    let (env, errors) = List.fold stmts ~init:(env, []) ~f:(fun (env, errors) stmt ->
      let (env, new_errors) = check_statement env stmt in
      (env, new_errors @ errors)
    ) in
    let (_scope, env) = Environment.pop_scope env in
    (env, errors)

let check_program ~on_exn:`Abort program =
  let env = Environment.empty in
  List.fold program ~init:(env, [])
  ~f:(fun (env, errors) stmt ->
    let (env', new_errors) = check_statement env stmt in
    (env', new_errors @ errors))

let string_of_error = function
  (* 3.1 *)
  | Environment.Unbound_symbol _ -> "error: use of undeclared identifier"
  (* 3.2 *)
  | Environment.Duplicate_declaration _ -> "error: redeclaration"
  (* 3.3.1 *)
  | Lvalue_not_assignable -> "error: lvalue is not assignable"
  | Null_to_non_pointer -> "error: cannot assign 'NULL' to non-pointer type"
  | Incompatible_assignment -> "error: incompatible types for assignment operation"
  (* 3.3.2 *)
  | Invalid_binary_operands -> "error: invalid operands to binary expression"
  (* 3.3.3 *)
  | Invalid_unary_operand -> "error: invalid argument type to unary expression"
  (* 3.3.4/5 *)
  | Not_comparable -> "error: types are not comparable in binary expression"
  (* 3.3.6 *)
  | Indirection_requires_pointer -> "error: indirection requires pointer operand"
  (* 3.3.7 *)
  | Rvalue_address -> "error: cannot take the address of an rvalue"
  (* 3.3.8 *)
  | Not_a_struct -> "error: member reference base type is not a struct"
  | Not_a_struct_pointer -> "error: member reference base type is not a struct pointer"
  | No_such_member -> "error: no such member in struct"
  (* 3.3.9 *)
  | Not_an_array -> "error: subscripted value is not an array"
  | Subscript_not_integer -> "error: array subscript is not an integer"
  (* 3.4 *)
  | Incomplete_type -> "error: incomplete type"
  (* 3.5 *)
  | Incompatible_return_types -> "error: incompatible return types"
  | Not_a_function -> "error: not a function"
  | Incompatible_arguments -> "error: incompatible arguments in function call"
  (* extra *)
  | Break_outside_loop -> "error: break statement not in loop"
  | Continue_outside_loop -> "error: continue statement not in loop"
  | e -> Exn.to_string e
