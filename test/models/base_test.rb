require "test_helper"

class BaseTest < ActiveSupport::TestCase
  # The model we use is arbitrary, so User can be replaced with Team, etc.
  test "`seeding?` returns true when running db:seed" do
    seeding_result = `rake db:seed seed_stub=true`
    assert seeding_result.match?("User is seeding: true")
  end
end
