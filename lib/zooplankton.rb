require "rails"
require "zooplankton/version"

module Zooplankton
  def self.setup!
    require "zooplankton/parser"

    module_eval do
      @@parser = Parser.new

      def self.path_template_for(helper_name, query_params = {}, supplied_params = nil)
        @@parser.path_template_for(helper_name, query_params, supplied_params)
      end

      def self.url_template_for(helper_name, query_params = {}, supplied_params = nil)
        @@parser.url_template_for(helper_name, query_params, supplied_params)
      end
    end
  end
end

require "zooplankton/railtie" if defined?(::Rails)
