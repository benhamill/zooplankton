require "rails"

require "zooplankton/version"

module Zooplankton
  class << self
    def path_template_for(helper_name, query_params_or_required_params={}, required_params=nil)
      return unless named_routes.names.include?(helper_name)

      if query_params_or_required_params.respond_to?(:to_h)
        query_params = []
        required_params = query_params_or_required_params.to_h
      else
        query_params = Array(query_params_or_required_params)
        required_params ||= {}
      end

      escaped_template_without_query_params = expand_helper(helper_name, :path, required_params)
      escaped_template = append_query_params(escaped_template_without_query_params, query_params)

      unescape_template(escaped_template)
    end

    def url_template_for(helper_name, params={})
      return unless named_routes.names.include?(helper_name)

      unescape_template(expand_helper(helper_name, :url, params))
    end

    private

    def append_query_params(template, query_params)
      return template unless query_params.any?

      "#{template}{?#{query_params.join(',')}}"
    end

    def expand_helper(helper_name, path_or_url, params)
      helper_method = "#{helper_name}_#{path_or_url}"

      url_helpers.send(helper_method, *templated_required_params_for(helper_name, params))
    end

    def named_routes
      Rails.application.routes.named_routes
    end

    def route_object_for(helper_name)
      named_routes.routes[helper_name]
    end

    def templated_required_params_for(helper_name, params)
      route_object_for(helper_name).required_parts.map do |required_part|
        params.fetch(required_part) { "{#{required_part}}" }
      end
    end

    def unescape_template(template)
      CGI.unescape(template)
    end

    def url_helpers
      Rails.application.routes.url_helpers
    end
  end
end
