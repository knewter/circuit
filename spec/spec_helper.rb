require 'rubygems'
require 'simplecov'
SimpleCov.start do
  add_filter "/lib/circuit/version.rb"
  add_filter "/spec/"
end

require 'bundler'

require 'simplecov'
SimpleCov.start

Bundler.require :default, :development

require 'combustion'
require 'capybara/rspec'

# require 'simple_form'
require 'machinist'
require 'machinist/mongoid'

Circuit.load_hosts! "spec/internal/config/circuit_hosts.yml"
Mongoid.load!       "spec/internal/config/mongoid.yml"

Combustion.initialize! :action_controller, :action_view, :sprockets

require 'rails/mongoid'
require 'rspec/rails'
require 'capybara/rails'
require 'rspec/rails/mocha'
require 'support/blueprints'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f|  require f}

RSpec.configure do |config|
  config.mock_with :mocha

  config.after(:each) do
    Mongoid.master.collections.select do |collection|
      collection.name !~ /system/
    end.each(&:drop)
  end

  # Clean up the database
  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
    stub_time!
  end
end

# freeze time, so time tests appear to run without time passing.
def stub_time!
  @time = Time.zone.now
  Time.zone.stubs(:now).returns(@time)
end
