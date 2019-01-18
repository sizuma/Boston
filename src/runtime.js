class Value {
    constructor(type, value) {
        this._type = type;
        this._value = value;
    }

    equals(other) {
        return this.type === other.type;
    }

    get type() {
        return this._type;
    }

    get value() {
        return this._value;
    }
}

const Values = {
    Number: class extends Value {
        constructor(number) {
            super('number', number);
        }
        equals(other) {
            return super.equals(other) && this.value === other.value;
        }

        toString() {
            return this.value;
        }
    },
    Tuple: class extends Value {
        constructor(array) {
            super('tuple', array);
        }

        static empty() {
            return new Values.Tuple([]);
        }

        add(elem) {
            return new Values.Tuple([...this.value, elem])
        }

        get length() {
            return this.value.length;
        }

        get(index) {
            return this.value[index];
        }

        equals(other) {
            if (!super.equals(other) || this.length !== other.length) return false;
            let equals = true;
            this.value.forEach((each, index) => {
                equals = equals && each.equals(other.get(index))
            });
            return equals;
        }

        toString() {
            let reduced = this.value.reduce((acc, value) => `${acc}${value}, `, "[");
            if (reduced.endsWith(", ")) reduced = reduced.substring(0, reduced.length-2);
            return reduced+"]";
        }
    },
    ExtensionSet: class extends Value {
        constructor(set) {
            super('set', set);
        }

        static empty() {
            return new Values.ExtensionSet(new Set([]));
        }

        has(elem) {
            return !![...this.value].find(each => each.equals(elem));
        }

        add(elem) {
            if (this.has(elem)) return this;
            else {
                return new Values.ExtensionSet(new Set([...this.value, elem]));
            }
        }

        get size() {
            return this.value.size;
        }

        equals(other) {
            if(!super.equals(other) || this.size !== other.size) return false;
            let equals = true;
            this.value.forEach(each => {
                equals = equals && other.has(each);
            });
            return equals;
        }

        toString() {
            let reduced = [...this.value].reduce((acc, value) => `${acc}${value}, `, "{");
            if (reduced.endsWith(", ")) reduced = reduced.substring(0, reduced.length-2);
            return reduced+"}";
        }
    }
};

module.exports = {
    Values,
};