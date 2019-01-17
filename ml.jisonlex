/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex

%%
\s+						/* skip whitespace */
[0-9]+("."[0-9]+)?\b	return 'NUMBER';
[a-zA-Z_][a-zA-Z0-9]*	return 'ID';
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
        { return stack.pop(); }
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
	: Number
		{ push($1) }
	;
Number
    : NUMBER
        { $$ = Number(yytext); }
    ;