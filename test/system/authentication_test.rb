require "application_system_test_case"

class AuthenticationSystemTest < ApplicationSystemTestCase
  device_test "visitors can sign-up, sign-out, sign-in, reset passwords, etc. with subscriptions #{billing_enabled? ? "enabled" : "disabled"}" do
    be_invited_to_sign_up

    visit root_path
    new_registration_page_for(display_details)

    # try to sign-up without providing any information.
    click_on "Sign Up"
    assert_text("Email Address can't be blank.")
    assert_text("Password can't be blank.")

    # try non-matching passwords.
    fill_in "Your Email Address", with: "andrew.culver@gmail.com"
    fill_in "Set Password", with: example_password
    fill_in "Confirm Password", with: another_example_password
    click_on "Sign Up"
    assert_text("Password Confirmation doesn't match Password.")

    # assume the fields have been properly re-populated and try again.
    fill_in "Set Password", with: example_password
    fill_in "Confirm Password", with: example_password
    click_on "Sign Up"

    # we should now be on an onboarding step.
    assert_text("Tell us about you")
    fill_in "First Name", with: "Testy"
    fill_in "Last Name", with: "McTesterson"
    fill_in "Your Team Name", with: "The Testing Team"
    click_on "Next"
    click_on "Skip" if bulk_invitations_enabled?

    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
      end
    end

    # sign out.
    sign_out_for(display_details)

    # we have to do this again because the session has been reset.
    be_invited_to_sign_up
    visit root_path

    # click the now-visible sign-up link.
    new_registration_page_for(display_details)

    # try to register as that same user again.
    fill_in "Your Email Address", with: "andrew.culver@gmail.com"
    fill_in "Set Password", with: example_password
    fill_in "Confirm Password", with: example_password
    click_on "Sign Up"
    assert_text("Email Address has already been taken.")

    # try signing in now.
    click_on "Already have an account?"
    assert_text("Sign In")

    # but we also want to make sure you can sign in from the homepage.
    visit root_path

    # if the marketing site is hosted elsewhere, this just skips straight to the sign-up page.
    new_session_page_for(display_details)

    # try to sign in with an invalid password.
    fill_in "Your Email Address", with: "andrew.culver@gmail.com"
    click_on "Next" if two_factor_authentication_enabled?
    fill_in "Your Password", with: "notpassword1234"
    check "Remember me"
    click_on "Sign In"
    # TODO: At some point when devise is updated their translations should capitalize password.
    # That will make this next line fail. At that point we should capitalize 'password' below and remove these comments.
    # See: https://github.com/heartcombo/devise/pull/5454
    assert_text("Invalid Email Address or password.")

    # try signing in with the valid credentials.
    fill_in "Your Email Address", with: "andrew.culver@gmail.com"
    click_on "Next" if two_factor_authentication_enabled?
    fill_in "Your Password", with: example_password
    click_on "Sign In"

    # we should be on the team's dashboard.
    assert_text("The Testing Team’s Dashboard")

    # sign out.
    sign_out_for(display_details)

    # click the now-visible sign-up link.
    new_session_page_for(display_details)

    fill_in "Your Email Address", with: "andrew.culver@gmail.com"
    click_on "Next" if two_factor_authentication_enabled?
    click_on "Forgot your password?"
    assert_text("Reset Your Password")

    click_on "Reset Password by Email"
    assert_text("Email Address can't be blank.")

    # try resetting the email for a bogus account.
    fill_in "Your Email Address", with: "not.andrew.culver@gmail.com"
    click_on "Reset Password by Email"

    # that shouldn't work.
    assert_text("Email Address not found.")

    perform_enqueued_jobs do
      # try resetting the email for our actual account.
      clear_emails
      fill_in "Your Email Address", with: "andrew.culver@gmail.com"
      click_on "Reset Password by Email"

      # that should work.
      assert_text("You will receive an email with instructions on how to reset your password in a few minutes.")

      # click the link in the email.
      open_email "andrew.culver@gmail.com"
      current_email.click_link "Change my password"
    end

    # generate a reset password token that we have access to the public version of.
    user = User.find_by_email("andrew.culver@gmail.com")
    user.send_reset_password_instructions

    # try to update with an invalid token.
    visit edit_user_password_path(reset_password_token: "invalid-token")
    assert_text("Change Your Password")

    fill_in "New Password", with: example_password
    fill_in "Confirm Password", with: another_example_password
    click_on "Change My Password"

    # it should recognize that the token is invalid.
    assert_text("Reset password token is invalid.")

    user = User.find_by_email("andrew.culver@gmail.com")
    token = user.send_reset_password_instructions

    # this token should be outdated.
    visit edit_user_password_path(reset_password_token: token)

    fill_in "New Password", with: example_password
    fill_in "Confirm Password", with: another_example_password
    click_on "Change My Password"

    assert_text("Password Confirmation doesn't match Password.")

    # ok, finally try to actually update the password properly and it should work.
    fill_in "New Password", with: example_password
    fill_in "Confirm Password", with: example_password
    click_on "Change My Password"

    # we should be on the dashboard.
    assert_text("The Testing Team’s Dashboard")

    # sign out.
    sign_out_for(display_details)
  end
end
