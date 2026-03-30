open Base

exception No_local_scope
exception Duplicate_declaration of string
exception Unbound_symbol of string

module StringMap = Map.M(String)

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

type scope = decl StringMap.t

type t = {
  global: scope;
  locals: scope list    (* Head is the current (deepest) scope *)
}

let empty = { global=Map.empty (module String); locals=[] }

let declare_global t name decl = 
  { t with global = Map.set t.global ~key:name ~data:decl }

let declare_local t name decl =     (* TODO: change return type to Result.t? *)
  match t.locals with 
  | [] -> raise No_local_scope
  | hd::tl ->
    if Map.mem hd name then raise (Duplicate_declaration name)
    else
    let new_hd = Map.set hd ~key:name ~data:decl in
    {t with locals = new_hd::tl }

let fetch_decl t name = 
  let rec fetch_from_scopes = function
  | [] -> None
  | hd :: tl ->
    (match Map.find hd name with
     | Some decl -> Some decl
     | None -> fetch_from_scopes tl)
  in
  match fetch_from_scopes t.locals with
  | Some decl -> decl
  | None ->
    match Map.find t.global name with
    | Some decl -> decl
    | None -> raise (Unbound_symbol ("The symbol " ^ name ^ " is unbound"))

let push_scope t =
  { t with locals = 
    (Map.empty (module String)) :: t.locals }

let pop_scope t = 
  match t.locals with
  | [] -> raise No_local_scope
  | hd :: tl ->
    {t with locals = tl}, hd

let alist_of_scope (scope: scope) = 
  Map.to_alist scope
