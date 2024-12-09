if ENV["CAPTURE_SIMPLECOV_AT_RUNTIME"]
  require "simplecov"
  SimpleCov.command_name ENV["SIMPLECOV_RUNTIME_COMMAND_NAME"] || "fake-command-for-simplecov"
  SimpleCov.start "rails"
end

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!
