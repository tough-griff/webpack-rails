require "rails"

module Webpack
  module Rails
    module ViewHelpers
      # Returns the appropriate style or script tag for a given asset. Javascript
      # style bundles like `app.style.bundle.js` give us hot module replacement for
      # CSS.
      def style_tag(asset)
        return stylesheet_link_tag asset, media: "all" if production?

        javascript_include_tag asset
      end

      private

      # Determine whether we are in production or simulating a production-like
      # environment.
      # TODO: configure simulation environment
      def production?
        ::Rails.env.production? || ::Rails.application.config.webpack.simulate_production
      end
    end
  end
end
