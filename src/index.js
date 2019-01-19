const Jison = require('jison');
const Parser = Jison.Parser;
const fs = require('fs');
const path = require('path');
const runtime = require('./runtime');
global.bostonRuntime = runtime;

const jisonlex = fs.readFileSync(path.resolve(__dirname, '..', 'ml.jisonlex'), 'utf-8');
Jison.print = (log) => {
    if (process.env.NODE_CONFLICT_LOG === 'show')
        console.error(log)
};
const parser = new Parser(jisonlex);
module.exports = (src) => {
    return parser.parse(src);
};
