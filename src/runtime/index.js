const Values = require('./Values');
const scope = require('./block');

const call = (key, arg) => {
    const f = scope.get(key);
    scope.push();
    scope.set('arg', arg);
    let result = null;
    f.forEach(each => {
        result = each();
    });
    scope.pop();
    return result;
};

module.exports = {
    Values,
    scope,
    call,
};
