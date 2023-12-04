# Simplecov config has to come before literally everything else
# Open coverage/index.html in your browser after
# running your tests for test coverage results.
require "simplecov"
SimpleCov.start "rails"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Set the default language we test in to English.
I18n.default_locale = :en

# We've started loading seeds by default to try to reduce any duplication of effort trying to get the test
# environment to look the same as the actual development and production environments. This means a consolidation
# of setup for things like the plans available for subscriptions and which outgoing webhooks are available to users.
require File.expand_path("../../db/seeds", __FILE__)

require "knapsack_pro"
knapsack_pro_adapter = KnapsackPro::Adapters::MinitestAdapter.bind
knapsack_pro_adapter.set_test_helper_path(__FILE__)

require "sidekiq/testing"
Sidekiq::Testing.inline!

require "minitest/reporters"

reporters = []

if ENV["BT_TEST_FORMAT"]&.downcase == "dots"
  # The classic "dot style" output:
  # ...S..E...F...
  reporters.push Minitest::Reporters::DefaultReporter.new
else
  # "Spec style" output that shows you which tests are executing as they run:
  # UserTest
  #   test_details_provided_should_be_true_when_details_are_provided  PASS (0.18s)
  reporters.push Minitest::Reporters::SpecReporter.new(print_failure_summary: true)
end

# This reporter generates XML documents into test/reports that are used by CI services to tally results.
# We add it last because doing so make the visible test output a little cleaner.
reporters.push Minitest::Reporters::JUnitReporter.new if ENV["CI"]

Minitest::Reporters.use! reporters

begin
  require "bullet_train/billing/test_support"
  FactoryBot.definition_file_paths << BulletTrain::Billing::TestSupport::FACTORY_PATH
  FactoryBot.reload
rescue LoadError
end

begin
  require "bullet_train/billing/stripe/test_support"
  FactoryBot.definition_file_paths << BulletTrain::Billing::Stripe::TestSupport::FACTORY_PATH
  FactoryBot.reload
rescue LoadError
end

ActiveSupport::TestCase.class_eval do
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end
