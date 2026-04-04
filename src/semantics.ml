open Base

exception Type_error of string

let lookup_struct_field env sname field_name errs_so_far =
  try
    match Environment.fetch_decl env sname with
    | Environment.Struct_type (_, entries) ->
      (match List.find entries ~f:(fun e -> String.equal e.entry_name field_name) with
       | Some entry -> (entry.Type_system.entry_type, errs_so_far)
       | None -> (Type_system.Int, errs_so_far @ [Type_error ("struct " ^ sname ^ " has no field named " ^ field_name)]))
    | _ -> (Type_system.Int, errs_so_far @ [Type_error (sname ^ " is not a struct type")])
  with
  | Environment.Unbound_symbol msg -> (Type_system.Int, errs_so_far @ [Type_error msg])

let rec type_of_expr env = function
  | Ast.Assign (a, b) ->
    let (type_a, errs_a) = type_of_expr env a in
    let (type_b, errs_b) = type_of_expr env b in
    let errs = errs_a @ errs_b in
    if not (Type_system.equal type_a type_b) then
      (type_a, errs @ [Type_error "incompatible types for assignment operation"])
    else (type_a, errs)
  | Ast.Binary (op, a, b) ->
    let (type_a, errs_a) = type_of_expr env a in
    let (type_b, errs_b) = type_of_expr env b in
    let errs = errs_a @ errs_b in
    (match op with
     | Ast.Eq | Ast.Ne | Ast.Lt | Ast.Le | Ast.Gt | Ast.Ge
     | Ast.Logical_and | Ast.Logical_or ->
       (Type_system.Int, errs)
     | Ast.Add ->
       (match type_a, type_b with
        | Type_system.Pointer _, Type_system.Int -> (type_a, errs)
        | Type_system.Int, Type_system.Pointer _ -> (type_b, errs)
        | _ ->
          if not (Type_system.equal type_a type_b) then (type_a, errs @ [Type_error "incompatible types for binary operation"])
          else (type_a, errs))
     | Ast.Sub ->
       (match type_a, type_b with
        | Type_system.Pointer _, Type_system.Int -> (type_a, errs)
        | Type_system.Pointer _, Type_system.Pointer _ -> (Type_system.Int, errs)
        | _ ->
          if not (Type_system.equal type_a type_b) then (type_a, errs @ [Type_error "incompatible types for binary operation"])
          else (type_a, errs))
     | Ast.Mul | Ast.Div | Ast.Mod ->
       if not (Type_system.equal type_a type_b) then (type_a, errs @ [Type_error "incompatible types for binary operation"])
       else (type_a, errs))
  | Ast.Unary (op, a) ->
    let (type_a, errs_a) = type_of_expr env a in
    (match op with
     | Ast.Neg | Ast.Not | Ast.Pre_inc | Ast.Pre_dec -> (type_a, errs_a)
     | Ast.Addr_of -> (Type_system.Pointer type_a, errs_a)
     | Ast.Deref ->
       (match type_a with
        | Type_system.Pointer inner -> (inner, errs_a)
        | _ -> (type_a, errs_a @ [Type_error "dereferencing a non-pointer type"])))
  | Ast.Postfix (_op, a) -> type_of_expr env a
  | Ast.Index (a, b) ->
    let (type_a, errs_a) = type_of_expr env a in
    let (_type_b, errs_b) = type_of_expr env b in
    let errs = errs_a @ errs_b in
    (match type_a with
     | Type_system.Array (elem, _) -> (elem, errs)
     | Type_system.Pointer elem -> (elem, errs)
     | _ -> (type_a, errs @ [Type_error "indexing a non-array type"]))
  | Ast.Field (a, name) ->
    let (type_a, errs_a) = type_of_expr env a in
    (match type_a with
     | Type_system.Struct (sname, _) -> lookup_struct_field env sname name errs_a
     | _ -> (Type_system.Int, errs_a @ [Type_error "field access on non-struct type"]))
  | Ast.Ptr_field (a, name) ->
    let (type_a, errs_a) = type_of_expr env a in
    (match type_a with
     | Type_system.Pointer (Type_system.Struct (sname, _)) -> lookup_struct_field env sname name errs_a
     | _ -> (Type_system.Int, errs_a @ [Type_error "-> on non-pointer-to-struct type"]))
  | Ast.Call (func, args) ->
    let args_results = List.map args ~f:(type_of_expr env) in
    let arg_types = List.map args_results ~f:fst in
    let errs_args = List.concat_map args_results ~f:snd in
    (match func with
     | Ast.Identifier fname ->
       (try
          match Environment.fetch_decl env fname with
          | Environment.Func { return_type; params } ->
            let n_args = List.length arg_types in
            let n_params = List.length params in
            if n_args <> n_params then
              (return_type, errs_args @
                [Type_error (fname ^ ": expected " ^ Int.to_string n_params
                             ^ " args, got " ^ Int.to_string n_args)])
            else
              let param_types = List.map params ~f:snd in
              let mismatches = List.filter_mapi (List.zip_exn arg_types param_types)
                ~f:(fun _ (at, pt) ->
                  if Type_system.equal at pt then None
                  else Some (Type_error (fname ^ ": argument type mismatch")))
              in
              (return_type, errs_args @ mismatches)
          | _ -> (Type_system.Int, errs_args @ [Type_error (fname ^ " is not a function")])
        with
        | Environment.Unbound_symbol msg -> (Type_system.Int, errs_args @ [Type_error msg]))
     | _ ->
       let (_type_f, errs_f) = type_of_expr env func in
       (Type_system.Int, errs_f @ errs_args @ [Type_error "indirect function call not supported"]))
  | Ast.Int_const _ -> (Type_system.Int, [])
  | Ast.Char_const _ -> (Type_system.Char, [])
  | Ast.String_const _ -> (Type_system.Pointer Type_system.Char, [])
  | Ast.Identifier name ->
    (try
       let decl = Environment.fetch_decl env name in
       (Environment.type_of_decl decl, [])
     with
     | Environment.Unbound_symbol msg -> (Type_system.Int, [Type_error msg]))
  | Ast.Null -> (Type_system.Null, [])

(* --- Helpers for statement checking --- *)

let check_expr env expr = snd (type_of_expr env expr)

let rec check_type_exists env = function
  | Type_system.Struct (name, _) ->
    (try
       match Environment.fetch_decl env name with
       | Environment.Struct_type _ -> []
       | _ -> [Type_error (name ^ " is not a struct type")]
     with Environment.Unbound_symbol _ ->
       [Type_error ("undefined struct type: " ^ name)])
  | Type_system.Pointer t | Type_system.Array (t, _) -> check_type_exists env t
  | _ -> []

let resolve_return_type (fd : Ast.func_decl) =
  let rec wrap n t = if n <= 0 then t else wrap (n - 1) (Type_system.Pointer t) in
  wrap fd.pointer_depth fd.return_type

let make_func_decl (fd : Ast.func_decl) : Environment.decl =
  let ret = resolve_return_type fd in
  let params = List.map fd.params ~f:(fun (p : Ast.decl_statement) ->
    (p.name, Environment.type_of_decl (Environment.decl_of_ast p)))
  in
  Func { return_type = ret; params }

let check_redecl env name =
  try ignore (Environment.fetch_decl env name);
    [Type_error ("redeclaration of " ^ name)]
  with Environment.Unbound_symbol _ -> []

(* Extract and register inline struct definitions from a type *)
let rec register_inline_structs env = function
  | Type_system.Struct (name, Some entries) ->
    let (env, nested_errs) = List.fold entries ~init:(env, []) ~f:(fun (env, errs) entry ->
      let (env', new_errs) = register_inline_structs env entry.Type_system.entry_type in
      (env', errs @ new_errs))
    in
    let redef_errs = check_redecl env name in
    (Environment.declare_global env name (Struct_type (name, entries)), nested_errs @ redef_errs)
  | Type_system.Pointer t | Type_system.Array (t, _) ->
    register_inline_structs env t
  | _ -> (env, [])

(* --- Statement checking (internal, with return type context) --- *)

let rec check_stmt ~ret_type env = function
  | Ast.Global_decl decl ->
    let decl_val = Environment.decl_of_ast decl in
    let ty = Environment.type_of_decl decl_val in
    let (env, inline_errs) = register_inline_structs env ty in
    let redef_errs = check_redecl env decl.name in
    let type_errs = check_type_exists env ty in
    (Environment.declare_global env decl.name decl_val, inline_errs @ redef_errs @ type_errs)

  | Ast.Local_decl decl ->
    let decl_val = Environment.decl_of_ast decl in
    let ty = Environment.type_of_decl decl_val in
    let (env, inline_errs) = register_inline_structs env ty in
    let type_errs = check_type_exists env ty in
    (match Environment.declare_local env decl.name decl_val with
     | env' -> (env', inline_errs @ type_errs)
     | exception (Environment.Duplicate_declaration name) ->
       (env, inline_errs @ [Type_error ("redeclaration of " ^ name)] @ type_errs)
     | exception exn -> (env, inline_errs @ [exn] @ type_errs))

  | Ast.Struct_def (name, entries) ->
    let (env, nested_errs) = List.fold entries ~init:(env, []) ~f:(fun (env, errs) entry ->
      let (env', new_errs) = register_inline_structs env entry.Type_system.entry_type in
      (env', errs @ new_errs))
    in
    let redef_errs = check_redecl env name in
    (Environment.declare_global env name (Struct_type (name, entries)), nested_errs @ redef_errs)

  | Ast.Func_def (fd, body) ->
    let ret = resolve_return_type fd in
    let (env, inline_errs) = register_inline_structs env ret in
    let redef_errs = check_redecl env fd.name in
    let env = Environment.declare_global env fd.name (make_func_decl fd) in
    let func_env = Environment.push_scope env in
    let (func_env, param_errs) =
      List.fold fd.params ~init:(func_env, []) ~f:(fun (e, errs) (p : Ast.decl_statement) ->
        match Environment.declare_local e p.name (Environment.decl_of_ast p) with
        | e' -> (e', errs)
        | exception (Environment.Duplicate_declaration name) ->
          (e, errs @ [Type_error ("redeclaration of parameter " ^ name)])
        | exception exn -> (e, errs @ [exn]))
    in
    let (_, body_errs) = check_stmts ~ret_type:(Some ret) func_env body in
    (env, inline_errs @ redef_errs @ param_errs @ body_errs)

  | Ast.Expr expr ->
    let (_, errs) = type_of_expr env expr in
    (env, errs)

  | Ast.Return expr ->
    let (t, errs) = type_of_expr env expr in
    let ret_errs = match ret_type with
      | Some rt when not (Type_system.equal t rt) ->
        [Type_error ("return type mismatch: expected "
                     ^ Sexp.to_string (Type_system.sexp_of_t rt)
                     ^ ", got " ^ Sexp.to_string (Type_system.sexp_of_t t))]
      | _ -> []
    in
    (env, errs @ ret_errs)

  | Ast.Empty | Ast.Break | Ast.Continue -> (env, [])

  | Ast.If (cond, then_, else_opt) ->
    let (_, ce) = type_of_expr env cond in
    let (_, te) = check_stmt ~ret_type env then_ in
    let ee = match else_opt with
      | Some s -> snd (check_stmt ~ret_type env s)
      | None -> []
    in
    (env, ce @ te @ ee)

  | Ast.While (cond, body) ->
    let (_, ce) = type_of_expr env cond in
    let (_, be) = check_stmt ~ret_type env body in
    (env, ce @ be)

  | Ast.For (init, cond, step, body) ->
    let ie = match init with Some e -> snd (type_of_expr env e) | None -> [] in
    let ce = match cond with Some e -> snd (type_of_expr env e) | None -> [] in
    let se = match step with Some e -> snd (type_of_expr env e) | None -> [] in
    let (_, be) = check_stmt ~ret_type env body in
    (env, ie @ ce @ se @ be)

  | Ast.Block stmts ->
    let scoped = Environment.push_scope env in
    let (_, errs) = check_stmts ~ret_type scoped stmts in
    (env, errs)

and check_stmts ~ret_type env stmts =
  List.fold stmts ~init:(env, []) ~f:(fun (e, errs) s ->
    let (e', new_errs) = check_stmt ~ret_type e s in
    (e', errs @ new_errs))

(* --- Public interface --- *)

let check_statement env stmt = check_stmt ~ret_type:None env stmt

let check_program program =
  List.fold program ~init:(Environment.empty, []) ~f:(fun (env, errs) stmt ->
    let (env', new_errs) = check_statement env stmt in
    (env', errs @ new_errs))
