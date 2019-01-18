/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex

%%
\s+						/* skip whitespace */
[0-9]+("."[0-9]+)?\b	return 'NUMBER';
[a-zA-Z_][a-zA-Z0-9]*	return 'ID';
"["						return 'L_S_BRA';
"]"						return 'R_S_BRA';
"{"						return 'L_BRA';
"}"						return 'R_BRA';
","						return 'COMMA';
<<EOF>>					return 'EOF';

/lex

%{
	const stack = [];

	const push = value => {
		stack.push(value);
	}
	const pop = () => {
		return stack.pop();
	}
%}

%start Program

%%

Program
    : Statements EOF
        { return pop(); }
    ;
Statements
    : Statement
    | Statements Statement
    ;
Statement
    : Expression
    | Command
    ;
Expression
	: Term
	;
Term
	: Factor
	| Tuple
			{ push($1); }
	;
Factor
	: Number
    		{ push($1) }
    ;
Tuple
	: L_S_BRA R_S_BRA
			{ $$ = []; }
	| L_S_BRA TupleBody R_S_BRA
			{ $$ = $2; }
	;
TupleBody
	: Expression
			{ $$ = [$1]; }
	| TupleBody COMMA Expression
			{ $$ = [].concat($1, [$3]); }
	;
Number
    : NUMBER
        { $$ = Number(yytext); }
    ;