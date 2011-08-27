require 'spork'
require 'pp'

Spork.prefork do

  ENV["RAILS_ENV"] = 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'machinist/active_record'
  require 'blueprints'

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :rr
    config.use_transactional_fixtures = true
    config.after(:each) do
       ApplicationController.session_data = { }
    end
  end

  Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  class ActiveRecord::Base
    mattr_accessor :shared_connection
    @@shared_connection = nil

    def self.connection
      @@shared_connection || retrieve_connection
    end
  end

  # Forces all threads to share the same connection. This works on
  # Capybara because it starts the web server in a thread.
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

  ## for selenium tests to be on the same database transaction as specs
  #ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  #  def current_connection_id
  #    # Thread.current.object_id
  #    Thread.main.object_id
  #  end
  #end

  class ApplicationController < ActionController::Base
    @@session_data = nil

    def self.session_data=(hash)
      @@session_data = hash
    end

    def self.add_session_data(hash)
      @@session_data ||= {}
      @@session_data.merge!(hash)
    end

    def self.get_session_data
      @@current_session_data
    end

    prepend_before_filter :set_session_data

    def set_session_data
      @@current_session_data = session.dup

      if @@session_data then
        @@session_data.each do |k, v|
          session[k] = v
        end
        @@session_data = nil
      end

    end

  end
end


Spork.each_run do
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
  load "#{Rails.root}/config/routes.rb"
  load "#{Rails.root}/spec/blueprints.rb"
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| load f }
end


