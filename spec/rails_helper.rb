# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'capybara/poltergeist'
require 'capybara/email/rspec'
require "sidekiq/testing"

Sidekiq::Testing.fake!
Capybara.javascript_driver = :poltergeist
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  config.include(OmniauthMacros)

  config.before :each do |example|
    # Configure and start Sphinx for request specs
    if example.metadata[:type] == :request
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start index: false
    end

    # Disable real-time callbacks if Sphinx isn't running
    ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] =
        (example.metadata[:type] == :request)
  end

  config.after(:each) do |example|
    # Stop Sphinx and clear out data after request specs
    if example.metadata[:type] == :request
      ThinkingSphinx::Test.stop
      ThinkingSphinx::Test.clear
    end
  end
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end

OmniAuth.config.test_mode = true
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end