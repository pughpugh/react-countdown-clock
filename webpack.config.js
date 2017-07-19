var path = require('path');

module.exports = {
  cache: true,
  context: __dirname + '/coffee',
  entry: './react-countdown-clock.coffee',
  output: {
    path: path.join(__dirname, 'build'),
    publicPath: path.join(__dirname, 'build'),
    filename: 'react-countdown-clock.js',
    library: 'ReactCountdownClock',
    libraryTarget: 'umd'
  },
  devtool: 'source-map',
  externals: {
    react: {
      root: 'React',
      commonjs: 'react',
      commonjs2: 'react',
      amd: 'react'
    }
  },
  module: {
    loaders: [
      { 
        test: /\.coffee$/, 
        loader: 'coffee-loader!cjsx-loader' 
      }
    ]
  }
};
