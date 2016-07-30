import ExtractTextPlugin from 'extract-text-webpack-plugin';
import merge from 'lodash/merge';
import webpack from 'webpack';

import devConfig from './webpack.config.dev.babel';
import entries from './entries';

const prodConfig = merge(devConfig, {
  bail: true,
  debug: false,
  devtool: 'source-map',
  entry: entries,
  module: {
    preLoaders: null,
    loaders: [{
      loader: 'babel',
      test: /\.jsx?$/,
      exclude: /node_modules/,
    }, {
      loader: ExtractTextPlugin.extract('style', 'css?sourceMap!sass?sourceMap'),
      test: /\.scss$/,
    }],
  },
  output: {
    publicPath: '/assets',
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': { NODE_ENV: JSON.stringify('production') },
    }),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        screw_ie8: true,
        warnings: false,
      },
      mangle: {
        screw_ie8: true,
      },
      output: {
        comments: false,
        screw_ie8: true,
      },
    }),
    new ExtractTextPlugin('../stylesheets/[name].<%= Rails.application.config.webpack.suffix %>.css'),
  ],
});

export default prodConfig;
