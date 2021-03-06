%{
  open LMJ
  let swap = List.map (fun (x, y) -> (y, x))
%}

%token <int32> INT_CONST
%token <bool> BOOL_CONST
%token INTEGER BOOLEAN
%token <string Location.t> IDENT
%token CLASS PUBLIC STATIC VOID MAIN STRING EXTENDS RETURN
%token PP PLUS MINUS TIMES NOT LT AND GT EGAL
%token COMMA SEMICOLON
%token ASSIGN
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token THIS NEW DOT LENGTH
%token SYSO
%token IF ELSE WHILE FOR
%token EOF

%left AND
%nonassoc LT GT EGAL
%left PLUS MINUS
%left TIMES
%nonassoc NOT
%nonassoc PP
%nonassoc DOT LBRACKET

%start program

%type <LMJ.program> program

%%

program:
| m = main_class d = defs EOF
   {
     let c, a, clas = m in
     let e1 = EObjectAlloc (Location.make $startpos $endpos "Main0") in
     let e2 = EMethodCall ( (Location.make $startpos $endpos e1) , Location.make $startpos $endpos "main0" , []) in
     let e3 = Location.make $startpos $endpos e2 in
     let j = IExp (e3) in

     let d2 = clas :: d in

     let defMain = [] in
     {
       name = c;
       defs = d2;
       main_args = a;
       main = j
     }
   }

main_class:
| CLASS c = IDENT
   LBRACE
   PUBLIC STATIC VOID MAIN LPAREN STRING LBRACKET RBRACKET a = IDENT RPAREN
   LBRACE
   ds = declarations_and_statements
   RBRACE
   RBRACE
   {
        let d, s = fst ds, snd ds in
        let name = Location.make $startpos $endpos "main0" in
        let nameClass = Location.make $startpos $endpos "Main0" in
        let t = TypInt in
        let e = (Location.make $startpos $endpos (EConst (ConstInt (Int32.of_int 0)))) in
        let m = [ name,
                     {
                       formals = swap [];
                       result  = t;
                       locals  = d;
                       body    = s;
                       return  = e;
                     }
                ] in

        c, a,
        (
            nameClass,
            {
              extends = None;
              attributes = swap [];
              methods = m;
            }
        )
   }

new_main:
    NEW
    classIdentifier = IDENT
    LPAREN RPAREN DOT
    methodIdentifier = IDENT
    LPAREN RPAREN SEMICOLON
    { (classIdentifier, methodIdentifier) }

/*main_class:*/
/*| CLASS c = IDENT*/
/*   LBRACE*/
/*   PUBLIC STATIC VOID MAIN LPAREN STRING LBRACKET RBRACKET a = IDENT RPAREN*/
/*   LBRACE*/
/*   i = instruction*/
/*   RBRACE*/
/*   RBRACE*/
/*   { (c, a, i) }*/

defs:
| c = list(clas)
   { c }

clas:
| CLASS name = IDENT e = option(preceded(EXTENDS, IDENT))
   LBRACE
   a = list(pair(typ, terminated(IDENT, SEMICOLON)))
   m = list(metho)
   RBRACE
   {
     name,
     {
       extends = e;
       attributes = swap a;
       methods = m;
     }
   }

metho:
| PUBLIC t = typ name = IDENT
   LPAREN
   f = separated_list(COMMA, pair(typ, IDENT))
   RPAREN
   LBRACE
   ds = declarations_and_statements
   RETURN e = expression SEMICOLON
   RBRACE
   {
     let d, s = fst ds, snd ds in
     name,
     {
       formals = swap f;
       result  = t;
       locals  = d;
       body    = s;
       return  = e;
     }
   }

list_var_declaration:
| l = list(var_declaration)
    { l }

var_declaration:
| t = typ id = IDENT SEMICOLON
    {id,t}

declarations_and_statements:
| t = typ id = IDENT ASSIGN e=expression SEMICOLON r = declarations_and_statements
   {
     let d, s = r in
     ((id, t) :: d, ISetVar (id, e)::s)
   }
| t = typ id = IDENT SEMICOLON r = declarations_and_statements
   {
     let d, s = r in
     ((id, t) :: d, s)
   }
| s = list(instruction)
   { ([], s) }

expression:
|  e = raw_expression
   { Location.make $startpos $endpos e }
| LPAREN e = expression RPAREN
   { e }

raw_expression:
| i = INT_CONST
   { EConst (ConstInt i) }

| b = BOOL_CONST
   { EConst (ConstBool b) }

| id = IDENT
   { EGetVar id }

| e1 = expression op = binop e2 = expression
   { EBinOp (op, e1, e2) }

| o = expression DOT c = IDENT LPAREN actuals = separated_list(COMMA, expression) RPAREN
   { EMethodCall (o, c, actuals) }

| a = expression LBRACKET i = expression RBRACKET
   { EArrayGet (a, i) }

| NEW INTEGER LBRACKET e = expression RBRACKET
   { EArrayAlloc e }

| a = expression DOT LENGTH
   { EArrayLength a }

| THIS
   { EThis }

| NEW id = IDENT LPAREN RPAREN
   { EObjectAlloc id }

| NOT e = expression
   { EUnOp (UOpNot, e) }

| e = expression PP
   { EUnOp (UOpPP, e) }

| PP e = expression
   { EUnOp (UOpPPPre, e) }

%inline binop:
| PLUS  { OpAdd }
| MINUS { OpSub }
| TIMES { OpMul }
| LT    { OpLt }
| AND   { OpAnd }
| GT  { OpGt }
| EGAL  { OpEgal }

instruction:
| b = block
   { b }

| id = IDENT ASSIGN e = expression SEMICOLON
   { ISetVar (id, e) }

| a = IDENT LBRACKET i = expression RBRACKET ASSIGN e = expression SEMICOLON
   { IArraySet (a, i, e) }

| SYSO LPAREN e = expression RPAREN SEMICOLON
   { ISyso e }

| IF LPAREN c = expression RPAREN i1 = instruction ELSE i2 = instruction
   { IIf (c, i1, i2) }

| IF LPAREN c = expression RPAREN i1 = instruction
   { If (c, i1) }

| WHILE LPAREN c = expression RPAREN i = instruction
   { IWhile (c, i) }

| FOR LPAREN ins1=instruction exp2 = expression SEMICOLON exp3=expression RPAREN i = instruction
   { IFor (ins1,exp2,exp3,i) }

| e = expression SEMICOLON
    {IExp (e)}

block:
| LBRACE is = list(instruction) RBRACE
   { IBlock is }

typ:
| INTEGER
   { TypInt }
| BOOLEAN
   { TypBool }
| INTEGER LBRACKET RBRACKET
   { TypIntArray }
| id = IDENT
   { Typ id }
