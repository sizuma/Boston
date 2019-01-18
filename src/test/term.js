const assert = require('assert');

const lang = require('../index');

assert.deepEqual(lang('[]'), []);
assert.deepEqual(lang('[1]'), [1]);
assert.deepEqual(lang('[1, 2]'), [1, 2]);
assert.deepEqual(lang('[1, [2, 3]]'), [1, [2, 3]]);
