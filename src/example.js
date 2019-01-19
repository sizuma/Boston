const lang = require('./index');

console.log(lang('1').toString());
console.log(lang('[]').toString());
console.log(lang('[1]').toString());
console.log(lang('[1, 2]').toString());
console.log(lang('[1, 2, [], [1], [2, 4]]').toString());
console.log(lang('{}').toString());
console.log(lang('{1}').toString());
console.log(lang('{1, 1, 2}').toString());
console.log(lang('{1, [1], {1}, [1], {1}}').toString());

console.log(lang(`
    var a = 1
    
    a
`).toString());

console.log(lang(`
    defun f() {
        var a = 2
        a
    }
    
    f
`).toString());

console.log(lang(`
    defun f() {
        var a = 2
        a
    }
    
    f()
`).toString());