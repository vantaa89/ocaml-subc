open Base

exception Lvalue_not_assignable
exception Null_to_non_pointer
exception Incompatible_assignment
exception Invalid_binary_operands
exception Invalid_unary_operand
exception Not_comparable
exception Indirection_requires_pointer
exception Rvalue_address
exception Not_a_struct
exception Not_a_struct_pointer
exception No_such_member
exception Not_an_array
exception Subscript_not_integer
exception Incomplete_type
exception Incompatible_return_types
exception Not_a_function
exception Incompatible_arguments
exception Unbound_symbol of string
exception Duplicate_declaration of string
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
     | Struct (sname, _) ->
       (match List.find (Environment.struct_entries env sname) ~f:(fun e -> String.equal e.entry_name name) with
        | Some e -> e.entry_type
        | None -> Int)
     | _ -> Int)
  | Ast.Ptr_field (expr, name) ->
    (match type_of_expr env expr with
     | Pointer (Struct (sname, _)) ->
       (match List.find (Environment.struct_entries env sname) ~f:(fun e -> String.equal e.entry_name name) with
        | Some e -> e.entry_type
        | None -> Int)
     | _ -> Int)
  | Ast.Call (func_expr, _args) ->
    (match func_expr with
     | Ast.Identifier name ->
       (match Environment.fetch_decl env name with
        | Some (Environment.Func { return_type; _ }) -> return_type
        | _ -> Int)
     | _ -> type_of_expr env func_expr)
  | Ast.Int_const _ -> Type_system.Int
  | Ast.Char_const _ -> Type_system.Char
  | Ast.String_const _ -> Type_system.Pointer Char
  | Ast.Identifier name ->
    (match Environment.fetch_decl env name with
     | Some (Environment.Var { type_ }) -> type_
     | Some (Environment.Const { type_; _ }) -> type_
     | Some (Environment.Func { return_type; _ }) -> return_type
     | Some (Environment.Struct_type t) -> t
     | None -> Int)
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
        match lhs_ty with Array _ -> [Lvalue_not_assignable] | _ ->
        let rhs_ty = type_of_expr env rhs in
        if Type_system.equal rhs_ty Null then
          (match lhs_ty with Pointer _ -> [] | _ -> [Null_to_non_pointer])
        else if not (Type_system.equal lhs_ty rhs_ty) then
          [Incompatible_assignment]
        else []
    in
    assign_error @ sub_errors

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
        if not (Ast.is_lvalue inner) then [Rvalue_address]
        else (match ty with Array _ -> [Rvalue_address] | _ -> [])
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
      | Array _  -> []
      | _ -> [Not_an_array]
    in
    let idx_error =
      if not (Type_system.equal idx_ty Int) then [Subscript_not_integer] else []
    in
    sub_errors @ idx_error @ arr_error

  | Ast.Field (expr, name) ->
    let sub_errors = check_expr env expr in
    let field_errors = match type_of_expr env expr with
      | Struct (sname, _) ->
        if List.exists (Environment.struct_entries env sname) ~f:(fun e -> String.equal e.entry_name name)
        then [] else [No_such_member]
      | _ -> [Not_a_struct]
    in
    sub_errors @ field_errors

  | Ast.Ptr_field (expr, name) ->
    let sub_errors = check_expr env expr in
    let field_errors = match type_of_expr env expr with
      | Pointer (Struct (sname, _)) ->
        if List.exists (Environment.struct_entries env sname) ~f:(fun e -> String.equal e.entry_name name)
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
        (match Environment.fetch_decl env name with
         | Some (Environment.Func { params; _ }) ->
           (match List.for_all2 args params ~f:(fun arg param ->
              Type_system.assignable param.entry_type (type_of_expr env arg))
            with
            | Ok true -> []
            | _ -> [Incompatible_arguments])
         | Some _ -> [Not_a_function]
         | None -> [])
      | _ -> []
    in
    args_errors @ func_errors @ call_errors

  | Ast.Identifier name ->
    (match Environment.fetch_decl env name with
     | Some _ -> []
     | None -> [Unbound_symbol name])

  | Ast.Int_const _ | Ast.Char_const _ | Ast.String_const _ | Ast.Null -> []

let rec check_statement env stmt =
  let line = stmt.Ast.line in
  let tag errs = List.map errs ~f:(fun e -> (line, e)) in
  match stmt.Ast.kind with
  | Global_decl decl ->
    if Environment.is_declared_global env decl.name then
      (env, [(line, Duplicate_declaration decl.name)])
    else
      let env = Environment.declare_global env decl.name (Environment.decl_of_ast decl) in
      (env, [])
  | Local_decl decl ->
    if Environment.is_declared_current_scope env decl.name then
      (env, [(line, Duplicate_declaration decl.name)])
    else
      let env = Environment.declare_local env decl.name (Environment.decl_of_ast decl) in
      (env, [])
  | Struct_def (name, fields) ->
    if Environment.is_declared_global env name then
      (env, [(line, Duplicate_declaration name)])
    else
      let check_field env (field : Ast.decl_statement) =
        match field.type_ with
        | Struct (inner_name, []) ->
          if Environment.is_declared_global env inner_name then (env, [])
          else (env, [(field.line, Incomplete_type)])
        | Struct (inner_name, _) ->
          if Environment.is_declared_global env inner_name then
            (env, [(field.line, Duplicate_declaration inner_name)])
          else
            (Environment.declare_global env inner_name (Environment.Struct_type field.type_), [])
        | _ -> (env, [])
      in
      let (env, field_errors) = List.fold fields ~init:(env, []) ~f:(fun (env, errs) field ->
        let (env, new_errs) = check_field env field in
        (env, new_errs @ errs))
      in
      let struct_type = Type_system.Struct (name, List.map fields ~f:Ast.entry_of_decl) in
      let env = Environment.declare_global env name (Environment.Struct_type struct_type) in
      (env, field_errors)
  | Func_def (func_decl, body) ->
    let name = func_decl.name in
    if Environment.is_declared_global env name then
      (env, [(line, Duplicate_declaration name)])
    else
      let func_decl = Environment.Func {
        return_type = Type_system.wrap_pointer func_decl.return_type func_decl.pointer_depth;
        params = List.map func_decl.params ~f:Ast.entry_of_decl
      } in
      let env = Environment.declare_global env name func_decl in
      let env = Environment.push_func_frame env func_decl in
      let _, body_error_list = List.fold body ~init:(env, []) ~f:(fun (env, errors) s ->
        let (env, new_err) = check_statement env s in
        (env, new_err @ errors)
      ) in
      let env = Environment.pop_func_frame env in
      (env, body_error_list)
  | Expr expr -> (env, tag (check_expr env expr))
  | Return expr ->
    let expr_errors = tag (check_expr env expr) in
    let return_errors = match Environment.current_func_decl env with
      | Some (Environment.Func { return_type; _ }) ->
        let ret_ty = type_of_expr env expr in
        if Type_system.equal ret_ty Null then
          (match return_type with Pointer _ -> [] | _ -> tag [Incompatible_return_types])
        else if not (Type_system.equal return_type ret_ty) then
          tag [Incompatible_return_types]
        else []
      | _ -> tag [Incompatible_return_types]
    in
    (env, return_errors @ expr_errors)
  | Empty -> (env, [])
  | If (cond, then_, else_) ->
    let cond_errors = tag (check_expr env cond) in
    let (env, then_errors) = check_statement env then_ in
    let (env, else_errors) = match else_ with
      | Some s -> check_statement env s
      | None -> (env, [])
    in
    (env, else_errors @ then_errors @ cond_errors)
  | While (cond, body) ->
    let cond_errors = tag (check_expr env cond) in
    let env = Environment.enter_loop env in
    let (env, body_errors) = check_statement env body in
    let env = Environment.exit_loop env in
    (env, body_errors @ cond_errors)
  | For (init, cond, step, body) ->
    let init_errors = match init with
      | Some e -> tag (check_expr env e)
      | None -> []
    in
    let cond_errors = match cond with
      | Some e -> tag (check_expr env e)
      | None -> []
    in
    let step_errors = match step with
      | Some e -> tag (check_expr env e)
      | None -> []
    in
    let env = Environment.enter_loop env in
    let (env, body_errors) = check_statement env body in
    let env = Environment.exit_loop env in
    (env, body_errors @ step_errors @ cond_errors @ init_errors)
  | Break ->
    if Environment.in_loop env then (env, [])
    else (env, [(line, Break_outside_loop)])
  | Continue ->
    if Environment.in_loop env then (env, [])
    else (env, [(line, Continue_outside_loop)])
  | Block stmts ->
    let env = Environment.push_scope env in
    let (env, errors) = List.fold stmts ~init:(env, []) ~f:(fun (env, errors) s ->
      let (env, new_errors) = check_statement env s in
      (env, new_errors @ errors)
    ) in
    let (_scope, env) = Environment.pop_scope env in
    (env, errors)

let check_program program =
  let env = Environment.empty in
  List.fold program ~init:(env, [])
  ~f:(fun (env, errors) stmt ->
    let (env', new_errors) = check_statement env stmt in
    (env', new_errors @ errors))

let string_of_error = function
  | Unbound_symbol _ -> "error: use of undeclared identifier"
  | Duplicate_declaration _ -> "error: redeclaration"
  | Lvalue_not_assignable -> "error: lvalue is not assignable"
  | Null_to_non_pointer -> "error: cannot assign 'NULL' to non-pointer type"
  | Incompatible_assignment -> "error: incompatible types for assignment operation"
  | Invalid_binary_operands -> "error: invalid operands to binary expression"
  | Invalid_unary_operand -> "error: invalid argument type to unary expression"
  | Not_comparable -> "error: types are not comparable in binary expression"
  | Indirection_requires_pointer -> "error: indirection requires pointer operand"
  | Rvalue_address -> "error: cannot take the address of an rvalue"
  | Not_a_struct -> "error: member reference base type is not a struct"
  | Not_a_struct_pointer -> "error: member reference base type is not a struct pointer"
  | No_such_member -> "error: no such member in struct"
  | Not_an_array -> "error: subscripted value is not an array"
  | Subscript_not_integer -> "error: array subscript is not an integer"
  | Incomplete_type -> "error: incomplete type"
  | Incompatible_return_types -> "error: incompatible return types"
  | Not_a_function -> "error: not a function"
  | Incompatible_arguments -> "error: incompatible arguments in function call"
  (* extra *)
  | Break_outside_loop -> "error: break statement not in loop"
  | Continue_outside_loop -> "error: continue statement not in loop"
  | e -> Exn.to_string e
