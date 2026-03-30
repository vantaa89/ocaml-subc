open Base
open Stdio

let increment counts key =
  let count = Option.value_map (Hashtbl.find counts key) ~default:1 ~f:(( + ) 1) in
  Hashtbl.set counts ~key ~data:count;
  count

let print_token keyword_counts ident_counts = function
  | Lexer.Keyword name ->
      printf "KEY %s %d\n" name (increment keyword_counts name)
  | Lexer.Ident name ->
      printf "ID %s %d\n" name (increment ident_counts name)
  | Lexer.Integer value ->
      printf "INT %s\n" value
  | Lexer.Float value ->
      printf "F %s\n" value
  | Lexer.Operator value ->
      printf "OP %s\n" value
  | Lexer.Eof -> ()

let with_input_channel path ~f =
  match path with
  | Some filename -> In_channel.with_file filename ~f
  | None -> f In_channel.stdin

let run lexbuf =
  let keyword_counts = Hashtbl.create (module String) in
  let ident_counts = Hashtbl.create (module String) in
  let rec loop () =
    let token = Lexer.token lexbuf in
    match token with
    | Lexer.Eof -> ()
    | _ ->
        print_token keyword_counts ident_counts token;
        loop ()
  in
  loop ()

let parse_input_file () =
  match Array.to_list (Sys.get_argv ()) with
  | [_] -> None
  | [_; filename] -> Some filename
  | _ ->
      eprintf "Usage: lex_main [input.c]\n";
      Stdlib.exit 2

let () =
  let input_file = parse_input_file () in
  with_input_channel input_file ~f:(fun channel ->
      channel |> Lexing.from_channel |> run)
