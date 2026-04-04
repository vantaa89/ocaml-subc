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
      ; params : (string * Type_system.t) list
      }
  | Struct_type of string * Type_system.struct_entry list

type scope = (string, decl, String.comparator_witness) Map.t

type t = {
  global : scope;
  locals : scope list;
}

let empty = {
  global = Map.empty (module String);
  locals = [];
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
    if Map.mem hd name then raise (Duplicate_declaration name);
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

let type_of_decl = function
  | Var { type_ } -> type_
  | Const { type_; _ } -> type_
  | Func { return_type; _ } -> return_type
  | Struct_type (name, _) -> Type_system.Struct (name, None)

let scope_to_struct_entries scope =
  Map.fold scope ~init:[] ~f:(fun ~key ~data acc ->
    match data with
    | Var { type_ } -> { Type_system.entry_name = key; entry_type = type_ } :: acc
    | _ -> acc)
  |> List.rev
