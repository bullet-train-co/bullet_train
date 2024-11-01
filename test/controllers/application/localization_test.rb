require "test_helper"

class ApplicationControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @controller = Class.new(ApplicationController) do
      def locale
        render plain: I18n.locale
      end
    end.new

    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw do
      get "locale" => "anonymous#locale"
    end

    @actual_locales = I18n.available_locales
    I18n.available_locales = %w[en es de]

    @user = create(:onboarded_user)
  end

  teardown do
    I18n.available_locales = @actual_locales
  end

  test "team locale is nil, user locale is nil" do
    sign_in @user

    get :locale
    assert_equal I18n.default_locale.to_s, response.body
  end

  test "team locale is nil, user locale is nil, HTTP_ACCEPT_LANGUAGE equals es" do
    request.headers["HTTP_ACCEPT_LANGUAGE"] = "es"
    sign_in @user

    get :locale
    assert_equal "es", response.body
  end

  test "team locale is es, user locale is nil" do
    sign_in @user
    @user.current_team.update!(locale: "es")

    get :locale
    assert_equal "es", response.body
  end

  test "team locale is es, user locale is de" do
    sign_in @user
    @user.current_team.update!(locale: "es")
    @user.update!(locale: "de")

    get :locale
    assert_equal "de", response.body
  end

  test "team locale is nil, user locale is de" do
    sign_in @user
    @user.update!(locale: "de")

    get :locale
    assert_equal "de", response.body
  end

  test "team locale is es, user locale is empty string" do
    sign_in @user
    @user.update!(locale: "")
    @user.current_team.update!(locale: "es")

    get :locale
    assert_equal "es", response.body
  end

  test "user not signed in" do
    get :locale
    assert_equal I18n.default_locale.to_s, response.body
  end

  test "user not signed in and browser sends HTTP_ACCEPT_LANGUAGE" do
    request.headers["HTTP_ACCEPT_LANGUAGE"] = "de"

    get :locale
    assert_equal "de", response.body
  end

  test "user not signed in and browser sends HTTP_ACCEPT_LANGUAGE with unknown value" do
    request.headers["HTTP_ACCEPT_LANGUAGE"] = "this-language-does-not-really-exist"

    get :locale
    assert_equal I18n.default_locale.to_s, response.body
  end
end
