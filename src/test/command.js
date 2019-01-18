const assert = require('assert');

const lang = require('../index');

lang('defun some() { 1 }');
lang('var a = 3');
console.log(lang('var a = 3\na'));