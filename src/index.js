const Parser = require("jison").Parser;
const fs = require('fs');
const path = require('path');

const jisonlex = fs.readFileSync(path.resolve(__dirname, '..', 'ml.jisonlex'), 'utf-8');
const parser = new Parser(jisonlex);

module.exports = (src) => {
    return parser.parse(src);
};
