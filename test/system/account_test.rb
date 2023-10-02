require "application_system_test_case"

class AccountTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    login_as(@jane, scope: :user)
    visit root_path
    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
        sleep 2
      end
    end
  end

  device_test "user can edit their account" do
    visit edit_account_user_path(@jane)
    fill_in "First Name", with: "Another"
    fill_in "Last Name", with: "Person"
    click_on "Update Profile"
    assert_text("User was successfully updated.")
    assert page.has_selector?('input[value="Another"]')
    assert page.has_selector?('input[value="Person"]')
  end

  device_test "user can edit their email with valid current password" do
    visit edit_account_user_path(@jane)
    fill_in "Email", with: "someone@bullettrain.co"
    fill_in "Current Password", with: @jane.password
    click_on "Update Email & Password"
    assert_text("User was successfully updated.")
    assert page.has_selector?('input[value="someone@bullettrain.co"]')
  end

  device_test "user can edit password with valid current password" do
    visit edit_account_user_path(@jane)
    fill_in "Current Password", with: @jane.password
    fill_in "New Password", with: another_example_password
    fill_in "Confirm New Password", with: another_example_password
    click_on "Update Email & Password"
    @jane.reload
    assert_text("User was successfully updated.")
    sign_out_for(display_details)
    visit new_user_session_path
    fill_in "Email", with: @jane.email
    click_on "Next" if two_factor_authentication_enabled?
    fill_in "Your Password", with: another_example_password
    click_on "Sign In"
    assert_text("Signed in successfully.")
  end

  device_test "user cannot edit password with invalid current password" do
    visit edit_account_user_path(@jane)
    fill_in "Current Password", with: "invalid"
    fill_in "New Password", with: another_example_password
    fill_in "Confirm New Password", with: another_example_password
    click_on "Update Email & Password"
    @jane.reload
    assert_text("Current password is invalid.")
    sign_out_for(display_details)
    visit new_user_session_path
    fill_in "Email", with: @jane.email
    click_on "Next" if two_factor_authentication_enabled?
    fill_in "Your Password", with: another_example_password
    click_on "Sign In"
    # TODO: At some point when devise is updated their translations should capitalize password.
    # That will make this next line fail. At that point we should capitalize 'password' below and remove these comments.
    # See: https://github.com/heartcombo/devise/pull/5454
    assert_text("Invalid Email Address or password.")
  end
end
