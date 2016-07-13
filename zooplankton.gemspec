# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zooplankton/version'

Gem::Specification.new do |spec|
  spec.name          = "zooplankton"
  spec.version       = Zooplankton::VERSION
  spec.authors       = ["Ben Hamill"]
  spec.email         = ["git-commits@benhamill.com"]
  spec.description   = %q{A library for turning Rails routes into URI Templates, like maybe for HAL.}
  spec.summary       = %q{A library for turning Rails routes into URI Templates.}
  spec.homepage      = "https://github.com/benhamill/zooplankton#readme"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 2.14"

  spec.add_dependency "rails", ">= 4.0"
end
