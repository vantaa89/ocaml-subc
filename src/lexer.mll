{
open Base
open Parser

exception Lexical_error of string
exception Eof

let keywords = Hashtbl.create (module String)

let () = 
  List.iter 
  [ ("break", BREAK)
  ; ("continue", CONTINUE)
  ; ("else", ELSE)
  ; ("for", FOR)
  ; ("if", IF)
  ; ("NULL", SYM_NULL)
  ; ("return", RETURN)
  ; ("int", TYPE) 
  ; ("char", TYPE) 
  ; ("type", TYPE) 
  ; ("struct", STRUCT) 
  ; ("while", WHILE)
  ]
  ~f:(fun (name, tok) -> Hashtbl.add_exn keywords ~key:name ~data:tok)

}

let letter = ['A'-'Z' 'a'-'z' '_']
let digit = ['0'-'9']
let identifier = letter (letter | digit)*
let whitespace = [' ' '\t']+
let float = digit+ '.' digit* (['e' 'E'] ['+' '-']? digit+)?
let integer = '0' | ['1'-'9'] digit*

rule token = parse
  | whitespace { token lexbuf }
  | '\n' { token lexbuf }
  | "/*" { comment 1 lexbuf }
  | identifier as text { 
    match Hashtbl.find keywords text with
    | Some keyword -> keyword
    | None -> ID text
   }
  | integer as text { INTEGER_CONST (Int.of_string text) }
  | "->" { STRUCTOP }
  | "++" { INCOP }
  | "--" { DECOP }
  | "<=" | ">=" | ">" | "<" { RELOP }
  | "==" { EQUOP }
  | "!=" { EQUOP }
  | "&&" { LOGICAL_AND }
  | "||" { LOGICAL_OR }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "[" { LBRACKET }
  | "]" { RBRACKET }
  | "{" { LBRACE }
  | "}" { RBRACE }
  | "." { DOT }
  | "," { COMMA }
  | "!" { BANG }
  | "*" { STAR }
  | "/" { SLASH }
  | "%" { PERCENT }
  | "+" { PLUS }
  | "-" { MINUS }
  | "&" { AMP }
  | ";" { SEMI }
  | "=" { ASSIGN }
  | eof { raise Eof }
  | _ { token lexbuf }

and comment depth = parse
  | "/*" { comment (depth + 1) lexbuf }
  | "*/" {
      if depth = 1 then token lexbuf else comment (depth - 1) lexbuf
    }
  | eof { raise (Lexical_error "unterminated comment") }
  | _ { comment depth lexbuf }
