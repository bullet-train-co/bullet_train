require "test_helper"

class ApplicationControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    ApplicationController.class_eval do
      def any_action
        render plain: I18n.locale
      end
    end

    # If disable_clear_and_finalize is set to true, Rails will not clear other
    # routes when calling again the draw method. Look at the source code at:
    # https://www.rubydoc.info/gems/actionpack/ActionDispatch/Routing/RouteSet#draw-instance_method
    Rails.application.routes.disable_clear_and_finalize = true

    Rails.application.routes.draw do
      get "any_action" => "application#any_action"
    end

    @actual_locales = I18n.available_locales
    I18n.available_locales = %w[en es de]

    @user = create(:onboarded_user)
  end

  def teardown
    I18n.available_locales = @actual_locales
  end

  test "team locale is nil, user locale is nil" do
    sign_in @user

    get :any_action
    assert_equal I18n.default_locale.to_s, response.body
  end

  test "team locale is nil, user locale is nil, HTTP_ACCEPT_LANGUAGE equals es" do
    @request.headers["HTTP_ACCEPT_LANGUAGE"] = "es"
    sign_in @user

    get :any_action
    assert_equal "es", response.body
  end

  test "team locale is es, user locale is nil" do
    sign_in @user
    @user.current_team.update!(locale: "es")

    get :any_action
    assert_equal "es", response.body
  end

  test "team locale is es, user locale is de" do
    sign_in @user
    @user.current_team.update!(locale: "es")
    @user.update!(locale: "de")

    get :any_action
    assert_equal "de", response.body
  end

  test "team locale is nil, user locale is de" do
    sign_in @user
    @user.update!(locale: "de")

    get :any_action
    assert_equal "de", response.body
  end

  test "team locale is es, user locale is empty string" do
    sign_in @user
    @user.update!(locale: "")
    @user.current_team.update!(locale: "es")

    get :any_action
    assert_equal "es", response.body
  end

  test "user not signed in" do
    get :any_action
    assert_equal I18n.default_locale.to_s, response.body
  end

  test "user not signed in and browser sends HTTP_ACCEPT_LANGUAGE" do
    @request.headers["HTTP_ACCEPT_LANGUAGE"] = "de"

    get :any_action
    assert_equal "de", response.body
  end

  test "user not signed in and browser sends HTTP_ACCEPT_LANGUAGE with unknown value" do
    @request.headers["HTTP_ACCEPT_LANGUAGE"] = "this-language-does-not-really-exist"

    get :any_action
    assert_equal I18n.default_locale.to_s, response.body
  end
end
