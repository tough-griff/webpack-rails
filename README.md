# Webpack::Rails

Easily implement webpack into your Rails (4.0+) project!

Based on the working implementation
[here](https://github.com/tough-griff/rails-webpack-demo).

## Installation
Simply add `webpack-rails` to your `Gemfile`:
```ruby
gem "webpack-rails"
```

install:
```sh
bundle install
```

and run the rails installation generator:
```sh
rails generate webpack:install
```
> The installation script will generate a `webpack-rails` initializer, a
> *frontend* directory for your JS/CSS/SCSS assets, and webpack configuration
> files.

Finally, be sure to install node dependencies:
```sh
npm install
```

## Usage
### Hot Loading
> By default, `webpack-rails` is configured to run with webpack hot-loading
> enabled.

Run the webpack dev server alongside your rails app, as normal.
```sh
bundle exec rails s # ...or your prefered method
npm start           # or `npm run webpack-server`
```

A *Procfile.dev* file is recommended if you use `foreman` to run your
application:
```
web: bundle exec rails s
webpack-server: npm start
```

### Without a Webpack Dev Server
If you choose not to use the webpack dev server to serve assets in development:
```rb
Rails.application.config.webpack.hot_loading_enabled = false
```
then you can run `npm run build:dev` alongside your rails application to build
assets into *app/assets/javascripts*.

### Compiling assets
To precompile your assets, run the included `rake` task as follows:
```sh
RAILS_ENV=production bundle exec rake webpack:build
```

### View Helpers
`webpack_js_tag` and `webpack_style_tag` helpers are available in views to
easily include webpack assets.
