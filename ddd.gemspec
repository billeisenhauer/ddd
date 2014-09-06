# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ddd/version'

Gem::Specification.new do |spec|
  spec.name          = "ddd"
  spec.version       = DDD::VERSION
  spec.authors       = ["Bill Eisenhauer"]
  spec.email         = ["bill@billeisenhauer.com"]
  spec.summary       = %q{Core domain-driven design components.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-debugger'
end
