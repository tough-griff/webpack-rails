require "non-stupid-digest-assets"
require "rails"

module Webpack
  module Rails
    class Railtie < ::Rails::Railtie
      config.webpack = ActiveSupport::OrderedOptions.new
      # Sensible defaults
      config.webpack.host_name = "localhost"
      config.webpack.node_port = 5050
      config.webpack.suffix = "bundle"
      config.webpack.hot_loading_enabled = true

      # Configure (pre)compilation
      initializer "webpack_rails.configure_precompilation", group: :all do |app|
        app.config.assets.precompile += [
          /.*\.#{app.config.webpack.suffix}\.(css|js)$/,
        ]

        NonStupidDigestAssets.whitelist += [
          /.*\.map$/,
        ]
      end

      # Configure Hot Loader
      initializer "webpack_rails.configure_hot_loader", group: :all do |app|
        if app.config.webpack.hot_loading_enabled && ::Rails.env.development?
          app.config.action_controller.asset_host = proc do |source|
            "//#{app.config.webpack.host_name}:#{app.config.webpack.node_port}/assets" if source.ends_with?("#{app.config.webpack.suffix}.js")
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
