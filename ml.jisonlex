/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex

%%
\s+						/* skip whitespace */
"defun"					return 'DEFUN';
"var"                   return 'VAR';
"&"                     return 'AND';
"|"                     return 'OR';
[0-9]+("."[0-9]+)?\b	return 'NUMBER';
[a-zA-Z][a-zA-Z0-9]*	return 'ID';
"["						return 'L_S_BRA';
"]"						return 'R_S_BRA';
"{"						return 'L_BRA';
"}"						return 'R_BRA';
"("						return 'L_PRA';
")"						return 'R_PRA';
","						return 'COMMA';
"="                     return 'EQUAL';
<<EOF>>					return 'EOF';

/lex

%{
    const runtime = global.bostonRuntime;
    const Values = runtime.Values;
%}

%left AND OR

%start Program

%%

Program
    : Statements EOF
        {
            let result = null;
            $1.forEach(each => {
                result = each();
            });
            return result;
        }
    ;
Statements
    : Statement
        { $$ = [$1]; }
    | Statements Statement
        { $$ = [].concat($1, $2);}
    ;
Statement
    : Expression
    | Command
    ;
Command
	: Defun
	| Var
	;
Defun
	: DEFUN Id L_PRA R_PRA L_BRA DefunBody R_BRA
	    { $$ = () => runtime.scope.set($2, $6); }
	;
DefunBody
	: Statements
	;
Var
    : VAR Id EQUAL Expression
        { $$ = () => runtime.scope.set($2, $4()); }
    ;
Expression
	: Term
	| Call
	| Or
	;
Term
	: Factor
	| Tuple
	| Set
	| And
	;
Factor
	: Number
	| Ref
    ;
Call
    : Id L_PRA R_PRA
        { $$ = () => runtime.call($1, null); }
    | Id L_PRA Expression R_PRA
        { $$ = () => runtime.call($1, $3()); }
    ;
Tuple
	: L_S_BRA R_S_BRA
	    { $$ = () => Values.Tuple.empty(); }
	| L_S_BRA TupleBody R_S_BRA
	    { $$ = $2; }
	;
TupleBody
	: Expression
	    { $$ = () => Values.Tuple.empty().add($1()); }
	| TupleBody COMMA Expression
	    { $$ = () => $1().add($3()); }
	;
Set
	: L_BRA R_BRA
	    { $$ = () => Values.ExtensionSet.empty(); }
	| L_BRA ExtensionSet R_BRA
	    { $$ = $2; }
	| L_BRA IntensionSet R_BRA
	    { $$ = $2; }
	;
ExtensionSet
	: Expression
	    { $$ = () => Values.ExtensionSet.empty().add($1()); }
	| ExtensionSet COMMA Expression
	    { $$ = () => $1().add($3()); }
	;
Or
    : Expression OR Expression
        { $$ = () => $1().or($3()); }
    ;
And
    : Expression AND Expression
        { $$ = () => $1().and($3()); }
    ;
Number
    : NUMBER
        { $$ = () => new Values.Number(Number(yytext)); }
    ;
Id
	: ID
		{ $$ = yytext; }
	;
Ref
    : Id
        { $$ = () => runtime.scope.get($1);}
    ;