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
			this.type = 'number';
		}

		asJValue() {
			return this.jValue;
		}

		equals(other) {
			return other.type === 'number' && other.jValue === this.jValue
		}
	}

	class MyTuple {
		constructor(baseArray) {
			this.jValue = [].concat(baseArray);
			this.type = 'tuple';
		}

		static empty() {
			return new MyTuple([]);
		}

		asJValue() {
			return this.jValue.map(each => each.asJValue());
		}

		equals(other) {
			return other.type === 'tuple' &&
				this.length === other.length &&
				this.jValue.reduce((acc, current, index) => {
					return acc && current.equals(other.jValue[index])
				}, true)
		}

		includes(elem) {
			return !!this.jValue.find(other => {
				return other.equals(elem);
			});
		}

		push(elem) {
			this.jValue.push(elem);
		}

		get length() {
			return this.jValue.length;
		}
	}
	class ExtensionSet {
		constructor(array) {
			const tuple = new MyTuple([]);
			array.forEach(each => {
				if(!tuple.includes(each)) tuple.push(each);
			});
			this.jValue = new global.Set(tuple.jValue);
			this.type = 'set';
			this.isFinite = true;
		}

		asJValue() {
			const result = [];
			this.jValue.forEach(each => {
				result.push(each.asJValue());
			});
			return new global.Set(result);
		}

		get size() {
			return this.jValue.size;
		}

		equals(other) {
			if (this.type === other.type && this.size === other.size) {
				let result = true;
				this.jValue.forEach(each => {
					let contains = false
					other.jValue.forEach(eachOther => {
						contains = contains || each.equals(eachOther);
					});
					result = result && contains;
				})
				return result;
			} else return false;
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