require File.expand_path('boot', __dir__)

require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

module RailsApp
  class Application < Rails::Application
    config.eager_load = true
    config.root = File.expand_path('..', __dir__)
    config.consider_all_requests_local = true
  end
end
