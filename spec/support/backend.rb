module Backend
  def self.from_name(name)
    puts "Backend: #{name}"
    case name
    when 'mongoid'
      MongoidBackend.new
    else
      ActiveRecordBackend.new
    end
  end

  class ActiveRecordBackend
    def load!
      require 'devise/orm/active_record'
      require 'rails_app_active_record/config/environment'
    end

    def setup_database_cleaner
      # Not necessary
    end

    def migrate!
      # Do initial migration
      path = File.expand_path("../rails_app_active_record/db/migrate/", File.dirname(__FILE__))

      if Gem::Requirement.new(">= 6.0.0") =~ Rails.gem_version
        ActiveRecord::MigrationContext.new(
          path,
          ActiveRecord::SchemaMigration
        ).migrate
      else
        ActiveRecord::MigrationContext.new(path).migrate
      end
    end
  end

  class MongoidBackend
    def load!
      require 'mongoid'
      require 'devise/orm/mongoid'
      require 'rails_app_mongoid/config/environment'
      require 'database_cleaner-mongoid'
    end

    def setup_database_cleaner
      DatabaseCleaner.allow_remote_database_url = true
    end

    def migrate!
      # Not necessary
    end
  end
end
