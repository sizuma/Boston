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

	class MyNumber {
		constructor(value) {
			this.jValue = value;
		}

		asJValue() {
			return this.jValue;
		}
	}

	class MyTuple {
		constructor(baseArray) {
			this.jValue = [].concat(baseArray);
		}

		static empty() {
			return new MyTuple([]);
		}

		asJValue() {
			return this.jValue.map(each => each.asJValue());
		}
	}
	class ExtensionSet {
		constructor(array) {
			this.jValue = new global.Set(array);
		}

		asJValue() {
			const result = [];
			this.jValue.forEach(each => {
				result.push(each.asJValue());
			});
			return new global.Set(result);
		}
	}
%}

%start Program

%%

Program
    : Statements EOF
    		{ return $1[0]; }
    ;
Statements
    : Statement
			{ $$ = [$1]; }
    | Statements Statement
    		{ $$ = [].concat($1, [$2]); }
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
			{ $$ = new MyTuple($1); }
	| Set
	;
Factor
	: Number
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
Set
	: L_BRA R_BRA
			{ $$ = new ExtensionSet([]); }
	| L_BRA ExtensionSet R_BRA
			{ $$ = new ExtensionSet($2); }
	| L_BRA IntensionSet R_BRA
			{ $$ = $2; }
	;
ExtensionSet
	: Expression
			{ $$ = [$1]; }
	| ExtensionSet COMMA Expression
			{ $$ = [].concat($1, [$3]); }
	;
Number
    : NUMBER
        { $$ = new MyNumber(Number(yytext)); }
    ;