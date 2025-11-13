require "application_system_test_case"

class TwoFactorAuthentication < ApplicationSystemTestCase
  if two_factor_authentication_enabled?
    setup do
      @jane = FactoryBot.create :two_factor_user, first_name: "Jane", last_name: "Smith"
      @john = FactoryBot.create :user, first_name: "John", last_name: "Smith"
    end

    device_test "a user can log in with a valid OTP" do
      visit new_user_session_path
      assert_text("Sign In")

      fill_in "Your Email Address", with: @jane.email
      click_on "Next"
      fill_in "Your Password", with: @jane.password
      fill_in "Two-Factor Authentication Code", with: @jane.otp.now

      click_on "Sign In"

      assert_text("Dashboard")
    end

    device_test "a user cannot log in with an invalid OTP" do
      visit new_user_session_path
      assert_text("Sign In")

      fill_in "Your Email Address", with: @jane.email
      click_on "Next"
      fill_in "Your Password", with: @jane.password
      fill_in "Two-Factor Authentication Code", with: "000000"

      click_on "Sign In"

      refute_text("Dashboard")
    end

    device_test "OTP input is invisible to a user with OTP authentication disabled" do
      visit new_user_session_path
      assert_text("Sign In")

      fill_in "Your Email Address", with: @john.email
      click_on "Next"
      fill_in "Your Password", with: @john.password

      refute_text("Two-Factor Authentication Code")
    end
  end
end
