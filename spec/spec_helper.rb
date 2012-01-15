
Spork.prefork do
  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'factory_girl_rails'
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

end

Spork.each_run do
  $rspec_start_time = Time.now
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/config/initializers/*.rb"].each { |f| load f }
  FactoryGirl.reload
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| load f }
end


