require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'appraisal'

RSpec::Core::RakeTask.new(spec: :rubocop)
RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = false
end

if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
  task default: :appraisal
else
  task default: :spec
end
