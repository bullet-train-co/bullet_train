require "test_helper"

class Account::ApiKeysControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = create(:onboarded_user)
    sign_in @user
    @api_key = create(:api_key, user: @user)
    @api_key_nil_revoke = create(:api_key, user: @user, revoked_at: nil)
  end

  test "should get index" do
    get account_user_api_keys_url(@user)
    assert_response :success
  end

  test "should update user.last_seen_at" do
    time = "2018-09-03 11:10:20 UTC"
    time1 = "2018-09-03 11:10:30 UTC"
    time2 = "2018-09-03 11:11:40 UTC"

    assert @user.last_seen_at.nil? == true

    freeze_time do
      travel_to Time.zone.parse(time)
      get account_user_api_keys_url(@user)
      assert @user.last_seen_at == Time.zone.parse(time)

      travel_to Time.zone.parse(time1)
      get account_user_api_keys_url(@user)
      assert @user.last_seen_at == Time.zone.parse(time)

      travel_to Time.zone.parse(time2)
      get account_user_api_keys_url(@user)
      assert @user.reload.last_seen_at == Time.zone.parse(time2)
    end
  end

  test "should create api_key" do
    assert_difference("ApiKey.count", 1) do
      post account_user_api_keys_url(@user), params: {api_key: {name: @api_key.name}}
    end

    assert_redirected_to account_user_api_keys_path(@user)
  end

  test "should show api_key" do
    skip "ApiKeysController doesn't have show action"
    get account_api_key_url(@api_key)
    assert_response :success
  end

  test "should update api_key" do
    skip "ApiKeysController doesn't have update action"
    patch account_api_key_url(@api_key), params: {api_key: {name: @api_key.name}}
    assert_redirected_to account_api_key_url(@api_key)
  end

  test "should revoke api_key" do
    delete account_api_key_url(@api_key_nil_revoke)
    assert !@api_key_nil_revoke.reload.revoked_at.nil?
    assert_redirected_to account_user_api_keys_url(@user)
  end
end
