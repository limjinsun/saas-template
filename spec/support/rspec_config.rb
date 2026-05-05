# spec/support/rspec_config.rb
require 'factory_bot_rails'
require 'active_support/testing/time_helpers'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers

  # Only available once rspec-rails is loaded
  if config.respond_to?(:use_transactional_fixtures=)
    config.use_transactional_fixtures = true
  end
end
