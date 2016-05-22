# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiddle/version'

Gem::Specification.new do |spec|
  spec.name          = "tiddle"
  spec.version       = Tiddle::VERSION
  spec.authors       = ["Adam Niedzielski"]
  spec.email         = ["adamsunday@gmail.com"]
  spec.summary       = %q{Token authentication for Devise which supports multiple tokens per model}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency "devise", ">= 4.0.0.rc1", "< 4.2"
  spec.add_dependency "activerecord", ">= 4.2.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rubocop"
end
