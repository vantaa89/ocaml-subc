let emit_log = ref false
let emit_ast = ref false
let emit_check = ref false
let () =
  Arg.parse
    [ "--emit-log", Arg.Set emit_log, "Print the reduction log" ;
      "--emit-ast", Arg.Set emit_ast, "Print the parsed AST" ;
      "--check", Arg.Set emit_check, "Run semantic analysis" ]
    (fun _ -> ())
    "subc [options] < input";
  (* Logger.emit_log := true; *)
  if !emit_log then
    Logger.emit_log := true;
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Lexer.token lexbuf in
  if !emit_ast then begin
    ast
    |> Ast.sexp_of_program
    |> Sexplib.Sexp.to_string_hum
    |> print_endline;
    exit 0
  end;
  if !emit_check then begin
    let (_env, errors) = Semantics.check_program ast in
    List.iter (fun exn ->
      match exn with
      | Semantics.Type_error (line, msg) -> Printf.printf "%d: error: %s\n" line msg
      | exn -> Printf.printf "error: %s\n" (Printexc.to_string exn)
    ) errors;
    (match errors with [] -> () | _ -> exit 1)
  end