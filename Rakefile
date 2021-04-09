require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'appraisal'

RSpec::Core::RakeTask.new(spec: :rubocop)
RuboCop::RakeTask.new(:rubocop)

if !ENV["APPRAISAL_INITIALIZED"]
  task default: :appraisal
else
  task default: :spec
end
