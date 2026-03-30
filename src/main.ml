let _ = 
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Lexer.token lexbuf in
  ast
  |> Ast.sexp_of_program
  |> Sexplib.Sexp.to_string_hum
  |> print_endline
  
