import castArray from 'lodash/castArray';
import mapValues from 'lodash/mapValues';
import path from 'path';
import webpack from 'webpack';

import entries from './entries';

export const appHost = process.env.APP_HOST || 'lvh.me';
export const nodePort = process.env.NODE_PORT || '5050';
export const serverPath = `//${appHost}:${nodePort}`;
const webpackHmrEntry = `webpack-hot-middleware/client?path=${serverPath}/__webpack_hmr`;

// Prepend the webpack HMR entry point to all defined entry points.
const devEntries = mapValues(entries, entry =>
  [webpackHmrEntry, ...castArray(entry)]
);

const devConfig = {
  context: __dirname,
  debug: true,
  devtool: 'cheap-module-eval-source-map',
  entry: devEntries,
  module: {
    preLoaders: [{
      loader: 'eslint',
      test: /\.jsx?$/,
      exclude: /node_modules/,
    }],
    loaders: [{
      loader: 'babel',
      test: /\.jsx?$/,
      exclude: /node_modules/,
    }, {
      loaders: ['style', 'css?sourceMap', 'sass?sourceMap'],
      test: /\.scss$/,
    }],
  },
  output: {
    path: path.resolve(__dirname, '..', 'app', 'assets', 'javascripts'),
    filename: '[name].<%= Rails.application.config.webpack.suffix %>.js',
    publicPath: `${serverPath}/assets/javascripts/`,
  },
  plugins: [
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({
      'process.env': { NODE_ENV: JSON.stringify('development') },
    }),
  ],
  resolve: {
    extensions: ['', '.js', '.jsx'],
    modulesDirectories: ['node_modules'],
  },
};

export default devConfig;