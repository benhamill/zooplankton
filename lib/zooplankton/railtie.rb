module Zooplankton
  class Railtie < Rails::Railtie
    config.to_prepare do
      Zooplankton.setup!
    end
  end
end
