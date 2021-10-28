require "test_helper"

class Account::Platform::ApplicationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = create(:onboarded_user)
    sign_in @user
    @team = @user.current_team
    @application = create(:platform_application, team: @team)
  end

  test "should get index" do
    get url_for([:account, @team, :platform_applications])
    assert_response :success
  end

  test "should get new" do
    get url_for([:new, :account, @team, :platform_application])
    assert_response :success
  end

  test "should create application" do
    assert_difference("Platform::Application.count") do
      post url_for([:account, @team, :platform_applications]), params: {
        platform_application: {
          name: @application.name,
          scopes: @application.scopes,
          redirect_uri: @application.redirect_uri
          # 🚅 super scaffolding will insert new fields above this line.
        }
      }
    end

    assert_redirected_to url_for([:account, @team, :platform_applications])
  end

  test "should show application" do
    get url_for([:account, @application])
    assert_response :success
  end

  test "should get edit" do
    get url_for([:edit, :account, @application])
    assert_response :success
  end

  test "should update application" do
    patch url_for([:account, @application]), params: {
      platform_application: {
        name: @application.name,
        scopes: @application.scopes,
        redirect_uri: @application.redirect_uri
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }
    assert_redirected_to url_for([:account, @application])
  end

  test "should destroy application" do
    assert_difference("Platform::Application.count", -1) do
      delete url_for([:account, @application])
    end

    assert_redirected_to url_for([:account, @team, :platform_applications])
  end
end
