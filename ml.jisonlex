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
%}

%start Program

%%

Program
    : Statements EOF
        { return $1 }
    ;
Statements
    : Statement
    | Statements Statement
        { $$ = [].concat($1, $2); }
    ;
Statement
    : Number
    ;
Number
    : NUMBER
        { $$ = Number(yytext); }
    ;