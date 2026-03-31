let emit_ast = ref false

let () =
  Arg.parse
    [ "--emit-ast", Arg.Set emit_ast, "Print the parsed AST and exit" ]
    (fun _ -> ())
    "subc [options] < input";
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Lexer.token lexbuf in
  if !emit_ast then begin
    ast
    |> Ast.sexp_of_program
    |> Sexplib.Sexp.to_string_hum
    |> print_endline;
    exit 0
  end
