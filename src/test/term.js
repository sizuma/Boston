const assert = require('assert');

const lang = require('../index');

assert.deepEqual(lang('[]').asJValue(), []);
assert.deepEqual(lang('[1]').asJValue(), [1]);
assert.deepEqual(lang('[1, 2]').asJValue(), [1, 2]);
assert.deepEqual(lang('[1, [2, 3]]').asJValue(), [1, [2, 3]]);

assert.deepEqual(lang('{}').asJValue(), new Set());
assert.deepEqual(lang('{1}').asJValue(), new Set([1]));
assert.deepEqual(lang('{1, 1}').asJValue(), new Set([1]));
assert.deepEqual(lang('{1, 2}').asJValue(), new Set([1, 2]));
assert.deepEqual(lang('{1, 2}').asJValue(), new Set([2, 1]));
