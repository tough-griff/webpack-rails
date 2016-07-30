require "non-stupid-digest-assets"
require "rails"

module Webpack
  module Rails
    class Railtie < ::Rails::Railtie
      config.webpack = ActiveSupport::OrderedOptions.new
      # Sensible defaults
      config.webpack.host_name           = "localhost"
      config.webpack.hot_loading_enabled = true
      config.webpack.node_port           = 4000
      config.webpack.simulate_production = false
      config.webpack.suffix              = "bundle"

      rake_tasks do
        load "tasks/build.rake"
      end

      # Configure (pre)compilation
      initializer "webpack_rails.configure_precompilation", after: :load_config_initializers, group: :all do |app|
        app.config.assets.precompile += [
          /.*\.#{app.config.webpack.suffix}\.(css|js)$/,
        ]

        NonStupidDigestAssets.whitelist += [
          /.*\.map$/,
        ]
      end

      # Configure Hot Loader
      initializer "webpack_rails.configure_hot_loader", after: :load_config_initializers, group: :all do |app|
        if app.config.webpack.hot_loading_enabled && ::Rails.env.development?
          if app.config.webpack.simulate_production
            # In a production-like environment, pull assets straight from public/assets.
            app.config.assets.compile     = false
            app.config.assets.debug       = false
            app.config.serve_static_files = true
          else
            app.config.action_controller.asset_host = proc do |source|
              "//#{app.config.webpack.host_name}:#{app.config.webpack.node_port}/assets" if source.ends_with?("#{app.config.webpack.suffix}.js")
            end
          end
        end
      end

      # Include the webpack-rails view helpers lazily
      initializer "webpack_rails.setup_view_helpers", after: :load_config_initializers, group: :all do
        ActiveSupport.on_load(:action_view) do
          include Webpack::Rails::ViewHelpers
        end
      end
    end
  end
end
