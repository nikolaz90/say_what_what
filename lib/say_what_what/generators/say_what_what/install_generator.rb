# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module SayWhatWhat
  #
  # Run it with bin/rails g say_what_what:install+ .
  #
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    TEMPLATES = File.join(File.dirname(__FILE__), "templates/install")
    source_paths << TEMPLATES

    def create_migration_file
      migration_template "migrations/create_say_what_what_errors.rb.erb",
                         File.join(db_migrate_path, "create_say_what_what_errors.rb")
    end

    private

    def migration_version
      "[#{ActiveRecord::VERSION::STRING.to_f}]"
    end
  end
end
