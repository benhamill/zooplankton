require 'action_controller/metal/strong_parameters'

module Zooplankton
  class Rails5Resolver
    def initialize(routes)
      @routes = routes
    end

    def has_route?(name)
      names.include?(name)
    end

    def generate(helper_method, helper_name, params = {})
      route = named_routes[helper_name]
      templated_params = route.required_parts.map do |required_part|
        params.fetch(required_part) { "{#{required_part}}" }
      end
      routes.url_helpers.public_send(helper_method, *templated_params)
    end

    private
    attr_reader :routes

    def names
      named_routes.names
    end

    def named_routes
      routes.named_routes
    end
  end

end
