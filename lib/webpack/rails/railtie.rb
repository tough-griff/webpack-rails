require "non-stupid-digest-assets"
require "rails"

module Webpack
  module Rails
    class Railtie < ::Rails::Railtie
      config.webpack = ActiveSupport::OrderedOptions.new
      # Sensible defaults
      config.webpack.host_name           = host_name           = "localhost"
      config.webpack.hot_loading_enabled = hot_loading_enabled = true
      config.webpack.node_port           = node_port           = 5050
      config.webpack.simulate_production = simulate_production = false
      config.webpack.suffix              = suffix              = "bundle"

      rake_tasks do
        load File.expand_path("../../../tasks/build.rake", __FILE__)
      end

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
        if hot_loading_enabled && ::Rails.env.development?
          if simulate_production
            app.config.action_controller.asset_host = proc do |source|
              "//#{host_name}:#{node_port}/assets" if source.ends_with?("#{suffix}.js")
            end
          else
            # In a production-like environment, pull assets straight from public/assets.
            config.assets.compile     = false
            config.assets.debug       = false
            config.serve_static_files = true
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
