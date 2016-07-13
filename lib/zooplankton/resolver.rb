module Zooplankton
  class Resolver
    def self.instance
      @instance ||= (
        version = Rails.version.to_f
        resolver_file = if version >= 5
          'rails5_resolver'
        else
          'rails4_resolver'
        end

        require File.join('zooplankton', resolver_file)
        klass = Zooplankton.const_get(resolver_file.classify)
        klass.new(Rails.application.routes)
      )
    end

    def initialize(routes)
      @routes = routes
    end

    private
    attr_reader :routes
  end
end
