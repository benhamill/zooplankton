require 'action_controller/metal/strong_parameters'

module Zooplankton
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
      routes.url_helpers.public_send(helper_method, *tokenized_params_for(route, params))
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
