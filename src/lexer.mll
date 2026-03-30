{
type token =
  | Keyword of string
  | Ident of string
  | Integer of string
  | Float of string
  | Operator of string
  | Eof

exception Lexical_error of string

let pending = Queue.create ()
}

let letter = ['A'-'Z' 'a'-'z' '_']
let digit = ['0'-'9']
let identifier = letter (letter | digit)*
let whitespace = [' ' '\t']+
let float = digit+ '.' digit* (['e' 'E'] ['+' '-']? digit+)?
let integer = '0' | ['1'-'9'] digit*

rule token = parse
  | "" {
      match Queue.take_opt pending with
      | Some token -> token
      | None -> read_token lexbuf
    }

and read_token = parse
  | whitespace { token lexbuf }
  | '\n' { token lexbuf }
  | "/*" { comment 1 lexbuf }
  | "break" { Keyword "break" }
  | "char" { Keyword "char" }
  | "continue" { Keyword "continue" }
  | "else" { Keyword "else" }
  | "float" { Keyword "float" }
  | "for" { Keyword "for" }
  | "if" { Keyword "if" }
  | "int" { Keyword "int" }
  | "return" { Keyword "return" }
  | "struct" { Keyword "struct" }
  | "while" { Keyword "while" }
  | "NULL" { Keyword "NULL" }
  | identifier as text { Ident text }
  | integer as value ".." {
      Queue.add (Operator "..") pending;
      Integer value
    }
  | float as text { Float text }
  | integer as text { Integer text }
  | "->" as text { Operator text }
  | ".." as text { Operator text }
  | "++" as text { Operator text }
  | "--" as text { Operator text }
  | "<=" as text { Operator text }
  | ">=" as text { Operator text }
  | "==" as text { Operator text }
  | "!=" as text { Operator text }
  | "&&" as text { Operator text }
  | "||" as text { Operator text }
  | ['(' ')' '[' ']' '{' '}' '.' ',' '!' '*' '/' '%' '+' '-' '<' '>' '&' ';' '='] as ch {
      Operator (String.make 1 ch)
    }
  | eof { Eof }
  | _ { token lexbuf }

and comment depth = parse
  | "/*" { comment (depth + 1) lexbuf }
  | "*/" {
      if depth = 1 then token lexbuf else comment (depth - 1) lexbuf
    }
  | eof { raise (Lexical_error "unterminated comment") }
  | _ { comment depth lexbuf }
