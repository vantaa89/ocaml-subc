open Base

exception Return_error
exception Type_error
exception Break_outside_loop
exception Continue_outside_loop

let rec type_of_expr env expr = 
  match expr with
  | Ast.Assign (lhs, _rhs) -> type_of_expr env lhs
  | Ast.Binary (op, lhs, rhs) ->
    let lhs_ty = type_of_expr env lhs in
    let rhs_ty = type_of_expr env rhs in
    (match op with
     | Eq | Ne | Lt | Le | Gt | Ge | Logical_and | Logical_or -> Type_system.Int
     | Add ->
       (match lhs_ty, rhs_ty with
        | Pointer _, Int -> lhs_ty
        | Int, Pointer _ -> rhs_ty
        | _ -> Type_system.Int)
     | Sub ->
       (match lhs_ty, rhs_ty with
        | Pointer _, Int -> lhs_ty
        | Pointer _, Pointer _ -> Type_system.Int
        | _ -> Type_system.Int)
     | Mul | Div | Mod -> Type_system.Int)
  | Ast.Unary (_op, expr) -> type_of_expr env expr
  | Ast.Postfix (_op, expr) -> type_of_expr env expr
  | Ast.Index (arr, _idx) -> type_of_expr env arr   (* TODO: unwrap array type *)
  | Ast.Field (_expr, _name) -> Type_system.Int      (* TODO *)
  | Ast.Ptr_field (_expr, _name) -> Type_system.Int   (* TODO *)
  | Ast.Call (func, _args) -> type_of_expr env func   (* TODO: return type of func *)
  | Ast.Int_const _ -> Type_system.Int
  | Ast.Char_const _ -> Type_system.Char
  | Ast.String_const _ -> Type_system.Pointer Char
  | Ast.Identifier name ->
    (match Environment.fetch_decl env name with
     | Environment.Var { type_ } -> type_
     | Environment.Const { type_; _ } -> type_
     | _ -> Type_system.Int)   (* TODO *)
  | Ast.Null -> Type_system.Null

let rec check_statement env statement =
  match statement with
  | Ast.Global_decl decl ->
    if Environment.is_declared_global env decl.name then 
      (env, [Environment.Duplicate_declaration decl.name])
    else
      let new_env = Environment.declare_global env decl.name (Environment.decl_of_ast decl) in
      (new_env, [])
  | Ast.Local_decl decl -> 
    if Environment.is_declared_current_scope env decl.name then 
      (env, [Environment.Duplicate_declaration decl.name])
    else
      let new_env = Environment.declare_local env decl.name (Environment.decl_of_ast decl) in
      (new_env, [])
  | Ast.Struct_def (name, fields) -> 
    if Environment.is_declared_global env name then
      (env, [Environment.Duplicate_declaration name])
    else
      let struct_entry_list = List.map fields ~f:Ast.entry_of_decl in
      let struct_type = Type_system.Struct (name, struct_entry_list) in
      let new_env = Environment.declare_global env name (Environment.Struct_type struct_type) in
      (new_env, [])
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
        let (new_env, new_err) = check_statement env stmt in
        (new_env, new_err @ errors)
      ) in
      let env = Environment.pop_func_frame env in
      (env, body_error_list)
  | Ast.Expr _expr -> (env, [])   (* TODO *)
  | Ast.Return expr ->
    let current_func_decl = Environment.current_func_decl env in
    (match current_func_decl with
     | Some (Environment.Func { return_type; _ }) ->
       if not (Type_system.assignable return_type (type_of_expr env expr)) then 
        (env, [Return_error])
       else 
        (env, [])
     | _ -> (env, [Return_error])
    )
  | Ast.Empty -> (env, [])
  | Ast.If (cond, then_, else_) ->
    let cond_errors =
      match type_of_expr env cond with
      | Struct _ | Array _ -> [Type_error]
      | _ -> []   (* int, char, or pointer are allowed for condition *)
    in
    let (env, then_errors) = check_statement env then_ in
    let (env, else_errors) = match else_ with
      | Some s -> check_statement env s
      | None -> (env, [])
    in
    (env, else_errors @ then_errors @ cond_errors)
  | Ast.While (cond, body) ->
    let cond_errors =
      match type_of_expr env cond with
      | Struct _ | Array _ -> [Type_error]
      | _ -> []
    in
    let env = Environment.enter_loop env in
    let (env, body_errors) = check_statement env body in
    let env = Environment.exit_loop env in
    (env, body_errors @ cond_errors)
  | Ast.For (init, cond, step, body) ->
    let init_errors = match init with
      | Some e -> ignore (type_of_expr env e); []
      | None -> []
    in
    let cond_errors = match cond with
      | Some e ->
        (match type_of_expr env e with
         | Struct _ | Array _ -> [Type_error]
         | _ -> [])
      | None -> []
    in
    let step_errors = match step with
      | Some e -> ignore (type_of_expr env e); []
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
