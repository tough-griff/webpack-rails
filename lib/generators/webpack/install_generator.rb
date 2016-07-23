module Webpack
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Create webpack frontend folder and config files."

      source_root File.expand_path("../templates", __FILE__)

      def create_initializer_file
        template "webpack.rb", "config/initializers/webpack.rb"
      end

      def create_package_json
        template "package.json", "package.json"
      end

      def create_frontend_directory
        empty_directory "frontend"
        empty_directory "frontend/css"
        empty_directory "frontend/js"
      end

      def create_frontend_config_files
        template ".babelrc", "frontend/.babelrc"
        template "entries.json", "frontend/entries.json"
        template webpack_config("dev"), "frontend/#{webpack_config('dev')}"
        template webpack_config("prod"), "frontend/#{webpack_config('prod')}"
        template "webpackServer.js", "frontend/webpackServer.js"
      end

      def create_index_js
        template "index.js", "frontend/js/index.js"
      end

      def create_index_scss
        template "index.scss", "frontend/css/index.scss"
      end

      private

      def webpack_config(env)
        "webpack.config.#{env}.babel.js"
      end
    end
  end
end
