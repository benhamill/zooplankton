require "zooplankton/version"
require "zooplankton/parser"

module Zooplankton
  class << self
    @@parser = Parser.new

    def path_template_for(helper_name, query_params = {}, supplied_params = nil)
      @@parser.path_template_for(helper_name, query_params, supplied_params)
    end

    def url_template_for(helper_name, query_params = {}, supplied_params = nil)
      @@parser.url_template_for(helper_name, query_params, supplied_params)
    end
  end
end
