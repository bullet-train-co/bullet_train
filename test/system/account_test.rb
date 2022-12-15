require "application_system_test_case"

class AccountTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  @@test_devices.each do |device_name, display_details|
    test "user can edit their account on a #{device_name}" do
      resize_for(display_details)
      login_as(@jane, scope: :user)
      visit edit_account_user_path(@jane)
      fill_in "First Name", with: "Another"
      fill_in "Last Name", with: "Person"
      fill_in "Email", with: "someone@bullettrain.co"
      click_on "Update Profile"
      assert page.has_content?("User was successfully updated.")
      assert page.has_selector?('input[value="Another"]')
      assert page.has_selector?('input[value="Person"]')
      assert page.has_selector?('input[value="someone@bullettrain.co"]')
    end

    test "user can edit password on a #{device_name} with valid current password" do
      resize_for(display_details)
      login_as(@jane, scope: :user)
      visit edit_account_user_path(@jane)
      fill_in "Current Password", with: @jane.password
      fill_in "New Password", with: another_example_password
      fill_in "Confirm Password", with: another_example_password
      click_on "Update Password"
      @jane.reload
      assert page.has_content?("User was successfully updated.")
      sign_out_for(display_details)
      visit new_user_session_path
      fill_in "Email", with: @jane.email
      click_on "Next" if two_factor_authentication_enabled?
      fill_in "Your Password", with: another_example_password
      click_on "Sign In"
      assert page.has_content?("Signed in successfully.")
    end

    test "user cannot edit password on a #{device_name} with invalid current password" do
      resize_for(display_details)
      login_as(@jane, scope: :user)
      visit edit_account_user_path(@jane)
      fill_in "Current Password", with: "invalid"
      fill_in "New Password", with: another_example_password
      fill_in "Confirm Password", with: another_example_password
      click_on "Update Password"
      @jane.reload
      assert page.has_content?("Current password is invalid.")
      sign_out_for(display_details)
      visit new_user_session_path
      fill_in "Email", with: @jane.email
      click_on "Next" if two_factor_authentication_enabled?
      fill_in "Your Password", with: another_example_password
      click_on "Sign In"
      # TODO I feel like password should be capitalized here?
      assert page.has_content?("Invalid Email Address or password.")
    end
  end
end
