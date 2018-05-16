const presetKarma = require('poi-preset-karma');
const glob = require('glob').sync;
const {name} = require('./package.json');

module.exports = {
  entry: glob('./src/**/*.vue'),
  filename: {
    js: name + '.min.js',
    css: name + '.min.css',
  },
  sourceMap: true,
  html: true,
  presets: [
    presetKarma({
      files: ['./test/e2e/specs/**.spec.js'],
      browsers: ['PhantomJS'],
      frameworks: ['mocha', 'chai', 'phantomjs-shim'],
    })
  ],
  moduleName: 'Socomodule'
};
