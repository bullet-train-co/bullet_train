require "application_system_test_case"

class AccountManagementSystemTest < ApplicationSystemTestCase
  device_test "user can edit their account and change account settings during registration" do
    be_invited_to_sign_up

    visit root_path
    new_registration_page_for(display_details)

    fill_in "Email", with: "andrew.culver@gmail.com"
    fill_in "Set Password", with: example_password
    fill_in "Confirm Password", with: example_password
    click_on "Sign Up"

    # we should now be on an onboarding step.
    assert_text("Tell us about you")
    fill_in "First Name", with: "Testy"
    fill_in "Last Name", with: "McTesterson"
    fill_in "Your Team Name", with: "The Testing Team"
    page.select "Brisbane", from: "Your Time Zone"
    click_on "Next"
    click_on "Skip" if bulk_invitations_enabled?

    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
      end
    end

    assert_text("The Testing Team’s Dashboard")

    user = User.find_by(email: "andrew.culver@gmail.com")

    visit edit_account_user_path(user)

    fill_in "First Name", with: "Testy.new"
    fill_in "Last Name", with: "McTesterson.new"
    page.select "Tokyo", from: "Your Time Zone"

    click_on "Update Profile"

    assert_text "User was successfully updated."

    visit edit_account_user_path(user)

    assert page.find("#user_first_name").value == "Testy.new"
    assert page.find("#user_last_name").value == "McTesterson.new"
    assert page.find("#user_time_zone").value == "Tokyo"

    visit edit_account_user_path(user)

    fill_in "Your Email Address", with: "andrew.culver.new@gmail.com"
    fill_in "Current Password", with: example_password

    click_on "Update Email & Password"

    assert_text "User was successfully updated."

    visit edit_account_user_path(user)
    assert page.find("#user_email").value == "andrew.culver.new@gmail.com"
  end
end
