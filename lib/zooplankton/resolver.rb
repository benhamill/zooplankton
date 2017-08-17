require "rails"
require 'action_controller/metal/strong_parameters'

module Zooplankton
  # we need to preload routes and helpers
  # to avoid this threading issue https://github.com/puma/puma/issues/647
  # routes.url_helpers creates a module every time, which is slow
  # and should be done only once on app startup.
  module Routes
    module UrlHelpers
      include Rails.application.routes.url_helpers
    end
    extend UrlHelpers

    def self.default_url_options
      Rails.application.routes.default_url_options
    end
  end

  class Resolver
    def self.instance
      new(Rails.application.routes)
    end

    def initialize(routes)
      @routes = routes
    end

    def has_route?(name)
      names.include?(name)
    end

    def generate(helper_method, helper_name, params = {})
      route = named_routes[helper_name]
      Routes.public_send(helper_method, *tokenized_params_for(route, params))
    end

    private
    attr_reader :routes

    def tokenized_params_for(route, params)
      route.required_parts.map do |required_part|
        params.fetch(required_part) { "{#{required_part}}" }
      end
    end

    def names
      named_routes.names
    end

    def named_routes
      routes.named_routes
    end
  end
end
