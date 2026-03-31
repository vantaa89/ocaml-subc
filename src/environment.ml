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
  | Struct of Type_system.struct_entry list

type scope = (string, decl, String.comparator_witness) Map.t

type t = {
  global : scope;
  locals : scope list;
}

let empty = {
  global = Map.empty (module String);
  locals = [];
}

let declare_global name decl env =
  { env with global = Map.set env.global ~key:name ~data:decl }

let declare_local name decl env =
  match env.locals with
  | [] -> raise No_local_scope
  | hd :: tl ->
    if Map.mem hd name then raise (Duplicate_declaration name);
    { env with locals = Map.set hd ~key:name ~data:decl :: tl }

let fetch_decl name env =
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
