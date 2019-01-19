class Block {
    constructor(parentBlock) {
        this.parentBlock = parentBlock;
        this.table = new Map();
    }

    get isRoot() {
        return !this.parentBlock;
    }

    get(key) {
        if (this.table.has(key)) return this.table.get(key);
        else if (this.isRoot) return null;
        else return this.parentBlock.get(key);
    }

    set(key, value) {
        this.table.set(key, value);
    }
}

let scope = new Block(null);

const get = key => scope.get(key);
const set = (key, value) => scope.set(key, value);
const push = () => scope = new Block(scope);
const pop = () => scope = scope.parentBlock;

module.exports = {
    get,
    set,
    push,
    pop,
};
