
(* The type of tokens. *)

type token = 
  | WHILE
  | VOID
  | TIMES
  | THIS
  | SYSO
  | STRING
  | STATIC
  | SEMICOLON
  | RPAREN
  | RETURN
  | RBRACKET
  | RBRACE
  | PUBLIC
  | PP
  | PLUS
  | NOT
  | NEW
  | MINUS
  | MAIN
  | LT
  | LPAREN
  | LENGTH
  | LBRACKET
  | LBRACE
  | INT_CONST of (int32)
  | INTEGER
  | IF
  | IDENT of (string Location.t)
  | GT
  | FOR
  | EXTENDS
  | EOF
  | ELSE
  | EGAL
  | DOT
  | COMMA
  | CLASS
  | BOOL_CONST of (bool)
  | BOOLEAN
  | ASSIGN
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (LMJ.program)
