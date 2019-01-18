const lang = require('./index');

console.log(lang('{[], [], [1], [1], [1, 2], [1, 2]}').toString());
console.log(lang('{{}, {}, {[1, 2]}, {[1, 2]}, {[2, 1]}}').toString());