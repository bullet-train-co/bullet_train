require "test_helper"

class ApiKeyTest < ActiveSupport::TestCase
  def setup
    @api_key = create(:api_key)
  end

  test "#active" do
    assert_respond_to(ApiKey, :active)
    assert_includes ApiKey.active, @api_key
    refute_includes ApiKey.active, create(:inactive_api_key)
  end

  test "must be valid" do
    assert @api_key.valid?
  end
end
