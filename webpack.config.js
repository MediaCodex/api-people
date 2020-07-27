const path = require('path')

/**
 * Output directory
 */
const buildDir = path.join(__dirname, 'build')

/**
 * Lambda Functions
 */
const entryPoints = {
  'http-create': './src/controllers/create.js',
  'http-update': './src/controllers/update.js',
  'http-index': './src/controllers/index.js',
  'http-show': './src/controllers/show.js'
}

/**
 * Webpack config
 */
module.exports = {
  mode: 'production',
  target: 'node',
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        type: 'javascript/esm'
      }
    ]
  },
  entry: entryPoints,
  output: {
    libraryTarget: 'commonjs2',
    path: buildDir
  },
  optimization: {
    minimize: false
  }
}
