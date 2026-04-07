let emit_log = ref false
let emit_ast = ref false
let emit_source = ref false
let check_only = ref false
let () =
  Arg.parse
    [ "--emit-reduction-log", Arg.Set emit_log, "Print the reduction log" ;
      "--emit-ast", Arg.Set emit_ast, "Print the parsed AST" ;
      "--emit-source", Arg.Set emit_source, "Print the program as source code" ;
      "--check", Arg.Set check_only, "Run semantic analysis only" ]
    (fun _ -> ())
    "subc [options] < input";
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
  if !emit_source then begin
    print_string (Ast.string_of_program ast);
    exit 0
  end;
  if !check_only then begin
    let (_env, errors) = Semantics.check_program ast in
    ignore (List.fold_left (fun last_line_no (line, e) ->
      if line <> last_line_no then
        Printf.printf "%d: %s\n" line (Semantics.string_of_error e);
      line)
      (-1)
      errors);
    if errors <> [] then exit 1
  end