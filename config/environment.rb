if ENV["CAPTURE_SIMPLECOV_AT_RUNTIME"]
  require "simplecov"
  # We use a random component here so that when we call `rails g super_scaffold` multiple times
  # we merge that coverage info instead of clobbering it.
  SimpleCov.command_name "runtime-simplecov-#{SecureRandom.hex}"
  SimpleCov.start "rails"
end

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!
