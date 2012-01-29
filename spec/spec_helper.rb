require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'database_cleaner'

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :rr
    config.include FactoryGirl::Syntax::Methods
    config.include FixtureBuilder
    config.include LoginHelpers
    config.include TimeHelpers

    config.before(:suite) do
        DatabaseCleaner.strategy = :truncation
        DatabaseCleaner.clean_with(:truncation)
      end

      config.before(:each) do
        DatabaseCleaner.start
      end

      config.after(:each) do
        DatabaseCleaner.clean
      end
  end

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  Capybara.register_driver :webkit do |app|
    Capybara::Driver::Webkit.new(app)
  end
end

Spork.each_run do
  $rspec_start_time = Time.now

  FactoryGirl.reload

  # reload files to capture changes
  Dir[
    Rails.root.join("app/**/*.rb"),
    Rails.root.join("spec/support/**/*.rb"),
    Rails.root.join("config/initializers/*.rb"),
    Rails.root.join("config/routes.rb")
  ].each { |f| load f }
end


