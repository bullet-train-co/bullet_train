ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require File.expand_path("../../lib/bullet_train", __FILE__)

# We've started loading seeds by default to try to reduce any duplication of effort trying to get the test
# environment to look the same as the actual development and production environments. This means a consolidation
# of setup for things like the plans available for subscriptions and which outgoing webhooks are available to users.
require File.expand_path("../../db/seeds", __FILE__)

require "knapsack_pro"
knapsack_pro_adapter = KnapsackPro::Adapters::MinitestAdapter.bind
knapsack_pro_adapter.set_test_helper_path(__FILE__)

ActiveSupport::TestCase.class_eval do
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# TODO: The test adapter gets overwritten when a test class inherits SystemTestCase,
# so this is hack to get inline sidekiq jobs running.
# https://github.com/rails/rails/issues/37270
# https://edgeapi.rubyonrails.org/classes/ActionDispatch/SystemTestCase.html
def switch_adapter_to_sidekiq
  (ActiveJob::Base.descendants << ActiveJob::Base).each { |a| a.disable_test_adapter }
  ActiveJob::Base.queue_adapter = :sidekiq
end
