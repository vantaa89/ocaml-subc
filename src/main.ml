open Base
open Stdio
open Lexer

let with_input_channel path ~f =
  match path with
  | Some filename -> In_channel.with_file filename ~f
  | None -> f In_channel.stdin

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
      let lexbuf = Lexing.from_channel channel in
      let rec loop () =
        let tok = Lexer.token lexbuf in
        print_endline (Sexp.to_string_hum (sexp_of_token tok));
        match tok with
        | Eof -> ()
        | _ -> loop ()
      in
      loop ())
  
