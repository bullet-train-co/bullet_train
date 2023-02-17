require "application_system_test_case"

class AuthenticationSystemTest < ApplicationSystemTestCase
  @@test_devices.each do |device_name, display_details|
    test "visitors can sign-up, sign-out, sign-in, reset passwords, etc. with subscriptions #{billing_enabled? ? "enabled" : "disabled"} on a #{device_name}" do
      resize_for(display_details)

      be_invited_to_sign_up

      visit root_path
      sign_up_from_homepage_for(display_details)

      # try to sign-up without providing any information.
      click_on "Sign Up"
      assert page.has_content?("Email Address can't be blank.")
      assert page.has_content?("Password can't be blank.")

      # try non-matching passwords.
      fill_in "Your Email Address", with: "andrew.culver@gmail.com"
      fill_in "Set Password", with: example_password
      fill_in "Confirm Password", with: another_example_password
      click_on "Sign Up"
      assert page.has_content?("Password Confirmation doesn't match Password.")

      # assume the fields have been properly re-populated and try again.
      fill_in "Set Password", with: example_password
      fill_in "Confirm Password", with: example_password
      click_on "Sign Up"

      if billing_enabled?
        complete_pricing_page
      end

      # we should now be on an onboarding step.
      assert page.has_content?("Tell us about you")
      fill_in "First Name", with: "Testy"
      fill_in "Last Name", with: "McTesterson"
      fill_in "Your Team Name", with: "The Testing Team"
      click_on "Next"

      # sign out.
      sign_out_for(display_details)

      # we have to do this again because the session has been reset.
      be_invited_to_sign_up
      visit root_path

      # click the now-visible sign-up link.
      sign_up_from_homepage_for(display_details)

      # try to register as that same user again.
      fill_in "Your Email Address", with: "andrew.culver@gmail.com"
      fill_in "Set Password", with: example_password
      fill_in "Confirm Password", with: example_password
      click_on "Sign Up"
      assert page.has_content?("Email Address has already been taken.")

      # try signing in now.
      click_on "Already have an account?"
      assert page.has_content?("Sign In")

      # but we also want to make sure you can sign in from the homepage.
      visit root_path

      # if the marketing site is hosted elsewhere, this just skips straight to the sign-up page.
      sign_in_from_homepage_for(display_details)

      # try to sign in with an invalid password.
      fill_in "Your Email Address", with: "andrew.culver@gmail.com"
      click_on "Next" if two_factor_authentication_enabled?
      fill_in "Your Password", with: "notpassword1234"
      check "Remember me"
      click_on "Sign In"
      # TODO I feel like password should be capitalized here?
      assert page.has_content?("Invalid Email Address or password.")

      # try signing in with the valid credentials.
      fill_in "Your Email Address", with: "andrew.culver@gmail.com"
      click_on "Next" if two_factor_authentication_enabled?
      fill_in "Your Password", with: example_password
      click_on "Sign In"

      # we should be on the team's dashboard.
      assert page.has_content?("The Testing Team’s Dashboard")

      # sign out.
      sign_out_for(display_details)

      # click the now-visible sign-up link.
      sign_in_from_homepage_for(display_details)

      fill_in "Your Email Address", with: "andrew.culver@gmail.com"
      click_on "Next" if two_factor_authentication_enabled?
      click_on "Forgot your password?"
      assert page.has_content?("Reset Your Password")

      click_on "Reset Password by Email"
      assert page.has_content?("Email Address can't be blank.")

      # try resetting the email for a bogus account.
      fill_in "Your Email Address", with: "not.andrew.culver@gmail.com"
      click_on "Reset Password by Email"

      # that shouldn't work.
      assert page.has_content?("Email Address not found.")

      perform_enqueued_jobs do
        # try resetting the email for our actual account.
        clear_emails
        fill_in "Your Email Address", with: "andrew.culver@gmail.com"
        click_on "Reset Password by Email"

        # that should work.
        assert page.has_content?("You will receive an email with instructions on how to reset your password in a few minutes.")

        # click the link in the email.
        open_email "andrew.culver@gmail.com"
        current_email.click_link "Change my password"
      end

      # generate a reset password token that we have access to the public version of.
      user = User.find_by_email("andrew.culver@gmail.com")
      user.send_reset_password_instructions

      # try to update with an invalid token.
      visit edit_user_password_path(reset_password_token: "invalid-token")
      assert page.has_content?("Change Your Password")

      fill_in "New Password", with: example_password
      fill_in "Confirm Password", with: another_example_password
      click_on "Change My Password"

      # it should recognize that the token is invalid.
      assert page.has_content?("Reset password token is invalid.")

      user = User.find_by_email("andrew.culver@gmail.com")
      token = user.send_reset_password_instructions

      # this token should be outdated.
      visit edit_user_password_path(reset_password_token: token)

      fill_in "New Password", with: example_password
      fill_in "Confirm Password", with: another_example_password
      click_on "Change My Password"

      assert page.has_content?("Password Confirmation doesn't match Password.")

      # ok, finally try to actually update the password properly and it should work.
      fill_in "New Password", with: example_password
      fill_in "Confirm Password", with: example_password
      click_on "Change My Password"

      # we should be on the dashboard.
      assert page.has_content?("The Testing Team’s Dashboard")

      # sign out.
      sign_out_for(display_details)
    end
  end
end
