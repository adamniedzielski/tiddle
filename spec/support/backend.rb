module Backend
  def self.from_name(name)
    puts "Backend: #{name}"
    case name
    when 'active_record'
      ActiveRecordBackend.new
    when 'mongoid'
      MongoidBackend.new
    else
      raise "Unknown backend #{name}, don't know how to run specs for that backend"
    end
  end

  class ActiveRecordBackend
    def load!
      require 'devise/orm/active_record'
      require 'rails_app_active_record/config/environment'
    end

    def migrate!
      path = File.expand_path("../rails_app_active_record/db/migrate/", File.dirname(__FILE__))
      ActiveRecord::Migrator.migrate(path)
    end
  end

  class MongoidBackend
    def load!
      require 'mongoid'
      require 'devise/orm/mongoid'
      require 'rails_app_mongoid/config/environment'
    end

    def migrate!
      # Not necessary
    end
  end
end
