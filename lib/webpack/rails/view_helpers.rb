require "rails"

module Webpack
  module Rails
    module ViewHelpers
      # Returns the appropriate style or script tag for a given asset.
      # Javascript style bundles like `app.style.bundle.js` give us hot module
      # replacement for CSS.
      def style_tag(asset)
        return stylesheet_link_tag asset, media: "all" if production?

        javascript_include_tag asset
      end

      # Include a javascript tag with the appropriate webpack suffix.
      def webpack_js_tag(asset)
        javascript_include_tag("#{asset}.#{suffix}")
      end

      # Include a style tag with the appropriate webpack suffix.
      def webpack_style_tag(asset)
        style_tag("#{asset}.style.#{suffix}")
      end

      private

      # Determine whether we are in production or simulating a production-like
      # environment.
      def production?
        ::Rails.env.production? || ::Rails.application.config.webpack.simulate_production
      end

      # Fetch the appropriate suffix from the application configuration.
      def suffix
        ::Rails.application.config.webpack.suffix
      end
    end
  end
end
