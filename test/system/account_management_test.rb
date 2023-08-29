require "application_system_test_case"

class AccountManagementSystemTest < ApplicationSystemTestCase
  @@test_devices.each do |device_name, display_details|
    test "user can edit their account and change account settings during registration on a #{device_name}" do
      resize_for(display_details)

      be_invited_to_sign_up

      visit root_path
      sign_up_from_homepage_for(display_details)

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

      if billing_enabled?
        unless freemium_enabled?
          complete_pricing_page
        end
      end

      assert_text("The Testing Team’s Dashboard")

      user = User.find_by(email: "andrew.culver@gmail.com")

      visit edit_account_user_path(user)

      fill_in "Email", with: "andrew.culver.new@gmail.com"
      fill_in "First Name", with: "Testy.new"
      fill_in "Last Name", with: "McTesterson.new"
      page.select "Tokyo", from: "Your Time Zone"

      click_on "Update Profile"

      assert_text "User was successfully updated."

      visit edit_account_user_path(user)

      assert page.find("#user_email").value == "andrew.culver.new@gmail.com"
      assert page.find("#user_first_name").value == "Testy.new"
      assert page.find("#user_last_name").value == "McTesterson.new"
      assert page.find("#user_time_zone").value == "Tokyo"
    end
  end
end
