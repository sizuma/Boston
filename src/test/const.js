const assert = require('assert');

const lang = require('../index');

assert.deepEqual(lang('1').asJValue(), 1);
assert.deepEqual(lang('1 2').asJValue(), 2);