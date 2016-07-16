module Webpack
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Create webpack frontend folder and config files."

      source_root File.expand_path("../templates", __FILE__)

      def create_initializer_file
        template "webpack-rails.rb", "config/initializers/webpack-rails.rb"
      end

      def create_package_json
        template "package.json", "package.json"
      end

      def create_js_directory
        empty_directory "frontend"
        empty_directory "frontend/js"
      end

      def create_js_files
        template "entries.json", "frontend/entries.json"
        template webpack_config("dev"), "frontend/#{webpack_config('dev')}"
        template webpack_config("prod"), "frontend/#{webpack_config('prod')}"
        template "webpackServer.js", "frontend/webpackServer.js"
      end

      private

      def webpack_config(env)
        "webpack.config.#{env}.babel.js"
      end
    end
  end
end
