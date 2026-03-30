let _ = 
  (* ignore (Parsing.set_trace true); *)    (* debug *)
  try 
    let lexbuf = Lexing.from_channel stdin in
    while true do
      Parser.program Lexer.token lexbuf;
    done
  with Lexer.Eof ->
    exit 0
