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

      # rubocop:disable Performance/RegexpMatch
      if Gem::Requirement.new(">= 5.2.0.rc1") =~ Rails.gem_version
        ActiveRecord::MigrationContext.new(path).migrate
      else
        ActiveRecord::Migrator.migrate(path)
      end
      # rubocop:enable Performance/RegexpMatch
    end
  end

  class MongoidBackend
    def load!
      require 'mongoid'
      require 'devise/orm/mongoid'
      require 'rails_app_mongoid/config/environment'
      require 'database_cleaner'
    end

    def setup_database_cleaner
      DatabaseCleaner.allow_remote_database_url = true
      DatabaseCleaner[:mongoid].strategy = :truncation
    end

    def migrate!
      # Not necessary
    end
  end
end
