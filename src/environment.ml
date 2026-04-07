open Base

exception No_local_scope
exception Duplicate_declaration of string
exception Unbound_symbol of string

type decl =
  | Var of
      { type_ : Type_system.t
      }
  | Const of
      { type_ : Type_system.t
      ; value : int option
      }
  | Func of
      { return_type : Type_system.t
      ; params : Type_system.entry list
      }
  | Struct_type of Type_system.t

type scope = (string, decl, String.comparator_witness) Map.t

type t = {
  global : scope;
  locals : scope list;
  current_func_decl: decl option;  (* The function declaration currently being defined *)
  loop_depth: int;
}

let empty = {
  global = Map.empty (module String);
  locals = [];
  current_func_decl = None;
  loop_depth = 0;
}

let decl_of_ast (decl : Ast.decl_statement) =
  let base = decl.type_ in
  let with_pointer =
    if decl.pointer_depth > 0 then Type_system.Pointer base else base
  in
  let ty = match decl.array_size with
    | Some n -> Type_system.Array (with_pointer, n)
    | None -> with_pointer
  in
  Var { type_ = ty }

let declare_global env name decl =
  { env with global = Map.set env.global ~key:name ~data:decl }

let declare_local env name decl =
  match env.locals with
  | [] -> raise No_local_scope
  | hd :: tl ->
    { env with locals = Map.set hd ~key:name ~data:decl :: tl }

let fetch_decl env name =
  let rec fetch_from_scopes = function
    | [] -> None
    | hd :: tl ->
      (match Map.find hd name with
       | Some decl -> Some decl
       | None -> fetch_from_scopes tl)
  in
  match fetch_from_scopes env.locals with
  | Some decl -> decl
  | None ->
    (match Map.find env.global name with
     | Some decl -> decl
     | None -> raise (Unbound_symbol ("The symbol " ^ name ^ " is unbound")))

let push_scope env =
  { env with locals = Map.empty (module String) :: env.locals }

let pop_scope env =
  match env.locals with
  | [] -> raise No_local_scope
  | hd :: tl -> (hd, { env with locals = tl })


let is_declared_global env name = 
  Option.is_some (Map.find env.global name)
  
let is_declared_current_scope env name = 
  match env.locals with
  | [] -> false
  | current_scope::_ -> Option.is_some (Map.find current_scope name)

let push_func_frame env func_decl =
  let env = push_scope env in
  let env = match func_decl with
    | Func { params; _ } ->
      List.fold params ~init:env ~f:(fun env (p : Type_system.entry) ->
        declare_local env p.entry_name (Var { type_ = p.entry_type }))
    | _ -> env
  in
  {env with current_func_decl = Some func_decl}

let pop_func_frame env = 
  let _, env = pop_scope env in
  {env with current_func_decl = None }

let current_func_decl env = env.current_func_decl

let enter_loop env = { env with loop_depth = env.loop_depth + 1 }
let exit_loop env = { env with loop_depth = env.loop_depth - 1 }
let in_loop env = env.loop_depth > 0