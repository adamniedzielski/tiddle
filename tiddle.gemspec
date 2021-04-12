lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiddle/version'

Gem::Specification.new do |spec|
  spec.name          = "tiddle"
  spec.version       = Tiddle::VERSION
  spec.authors       = ["Adam Niedzielski"]
  spec.email         = ["adamsunday@gmail.com"]
  spec.summary       = "Token authentication for Devise which supports multiple tokens per model"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency "devise", ">= 4.0.0.rc1", "< 5"
  spec.add_dependency "activerecord", ">= 5.2.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "database_cleaner-active_record"
  spec.add_development_dependency "database_cleaner-mongoid"
end
