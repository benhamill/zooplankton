require "rails"
require "zooplankton/resolver"

module Zooplankton
  class Parser
    AMPERSAND = '&'.freeze
    QUESTION_MARK = '?'.freeze

    def path_template_for(helper_name, query_params={}, supplied_params=nil)
      build_template(:path, helper_name, *parse_params(query_params, supplied_params))
    end

    def url_template_for(helper_name, query_params={}, supplied_params=nil)
      build_template(:url, helper_name, *parse_params(query_params, supplied_params))
    end

    private

    def parse_params(*args)
      if args.first.respond_to?(:to_h) && !args.first.is_a?(Array)
        query_params = []
        supplied_params = args.first.to_h
      else
        query_params = Array(args.shift)
        supplied_params = args.first || {}
      end

      [query_params, supplied_params]
    end

    def build_template(type, helper_name, query_params, supplied_params)
      return unless resolver.has_route?(helper_name)

      escaped_template_without_query_params = expand_helper(helper_name, type, supplied_params)
      escaped_template = append_query_params(escaped_template_without_query_params, query_params, supplied_params)

      unescape_template(escaped_template)
    end

    def append_query_params(template, defined_keys, supplied_params)
      return template unless defined_keys.any?

      supplied_keys = defined_keys & supplied_params.keys
      not_supplied_keys = defined_keys - supplied_params.keys

      segments = []
      init_symbol = QUESTION_MARK

      if supplied_keys.any?
        segments << supplied_keys.map{|k| escaped_pair(k, supplied_params[k]) }.join(AMPERSAND)
      end

      if not_supplied_keys.any?
        init_symbol, sep = if segments.size > 0
          [QUESTION_MARK, AMPERSAND]
        else
          ['', QUESTION_MARK]
        end
        segments << "{#{sep}#{not_supplied_keys.join(",")}}"
      end

      "#{template}#{init_symbol}#{segments.join}"
    end

    def expand_helper(helper_name, path_or_url, params)
      helper_method = "#{helper_name}_#{path_or_url}"

      resolver.generate(helper_method, helper_name, params)
    end

    def resolver
      @resolver ||= Resolver.instance
    end

    def escaped_pair(key, value)
      [key, URI.encode(value.to_s)].join('=')
    end

    def unescape_template(template)
      CGI.unescape(template)
    end
  end
end
