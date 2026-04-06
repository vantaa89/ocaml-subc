let emit_log = ref false
let emit_ast = ref false
let () =
  Arg.parse
    [ "--emit-log", Arg.Set emit_log, "Print the reduction log" ;
      "--emit-ast", Arg.Set emit_ast, "Print the parsed AST" ]
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
  let (_env, errors) = Semantics.check_program ~on_exn:`Abort ast in
  let errors = List.rev errors in
  List.iter (fun e -> print_endline (Semantics.string_of_error e)) errors