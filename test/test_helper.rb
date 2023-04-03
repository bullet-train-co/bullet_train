ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "simplecov"

# Open coverage/index.html in your browser after
# running your tests for test coverage results.
SimpleCov.start "rails"

# We've started loading seeds by default to try to reduce any duplication of effort trying to get the test
# environment to look the same as the actual development and production environments. This means a consolidation
# of setup for things like the plans available for subscriptions and which outgoing webhooks are available to users.
require File.expand_path("../../db/seeds", __FILE__)

require "knapsack_pro"
knapsack_pro_adapter = KnapsackPro::Adapters::MinitestAdapter.bind
knapsack_pro_adapter.set_test_helper_path(__FILE__)

require "sidekiq/testing"
Sidekiq::Testing.inline!

ActiveSupport::TestCase.class_eval do
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  fixtures :all

  # Add more helper methods to be used by all tests here...
end
