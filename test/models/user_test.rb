require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "jane@bullettrain.co")
  end

  test "details_provided should be true when details are provided" do
    @user = FactoryBot.create :onboarded_user, first_name: "a", last_name: "b"
    assert @user.details_provided?
  end

  test "details_provided should be false when details aren't provided" do
    @user = FactoryBot.create :user, first_name: "a", last_name: nil
    assert_equal @user.details_provided?, false
  end
end
