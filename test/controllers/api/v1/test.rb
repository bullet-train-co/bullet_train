require "test_helper"
require "controllers/api/test"
require "support/custom_assertions"

class Api::V1::Test < Api::Test
  include Devise::Test::IntegrationHelpers
end
