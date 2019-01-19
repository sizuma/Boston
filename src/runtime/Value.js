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

    or(other) {
        throw 'or operator cannot apply to '+this.toString();
    }

    and(other) {
        throw 'and operator cannot apply to '+this.toString();
    }
}

module.exports = Value;