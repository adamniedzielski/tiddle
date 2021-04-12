require File.expand_path('boot', __dir__)

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

module RailsApp
  class Application < Rails::Application
    config.eager_load = true
    config.root = File.expand_path('..', __dir__)
    config.consider_all_requests_local = true
    config.active_record.sqlite3.represent_boolean_as_integer = true if config.active_record.sqlite3
  end
end
