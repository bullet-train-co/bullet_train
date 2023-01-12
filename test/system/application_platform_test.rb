require "application_system_test_case"

class ApplicationPlatformSystemTest < ApplicationSystemTestCase
  # TODO: Duplicate code, add to application_system_test.rb
  def within_membership_row(membership)
    within "tr[data-id='#{membership.id}']" do
      yield
    end
  end

  def within_current_memberships_table
    within "tbody[data-model='Membership'][data-scope='current']" do
      yield
    end
  end

  @@test_devices.each do |device_name, display_details|
    test "visitors can sign-up and manage team members with subscriptions #{billing_enabled? ? "enabled" : "disabled"} on a #{device_name}" do
      resize_for(display_details)

      be_invited_to_sign_up

      visit root_path
      sign_up_from_homepage_for(display_details)

      # try non-matching passwords.
      fill_in "Your Email Address", with: "jane.smith@gmail.com"
      fill_in "Set Password", with: example_password
      fill_in "Confirm Password", with: example_password
      click_on "Sign Up"

      if billing_enabled?
        complete_pricing_page
      end

      # we should now be on an onboarding step.
      assert page.has_content?("Tell us about you")
      fill_in "First Name", with: "Jane"
      fill_in "Last Name", with: "Smith"
      fill_in "Your Team Name", with: "The Testing Team"
      click_on "Next"

      # Create a new Platform Application
      within_developers_menu_for(display_details) do
        click_on "API"
      end
      click_on "Provision New Platform Application"
      fill_in "Name", with: "Test Platform Application"
      click_on "Provision Platform Application"
      assert page.has_content?("Platform Application was successfully created.")

      # Ensure that Platform Application is present in the Memberships list.
      within_team_menu_for(display_details) do
        click_on "Team Members"
      end
      within_current_memberships_table do
        assert page.has_content?("Test Platform Application")
      end

      # Remove the Platform Application and ensure it's
      # not present in the tombstoned Memberships list.
      within_developers_menu_for(display_details) do
        click_on "API"
      end
      accept_alert { click_on("Delete") }

      within_team_menu_for(display_details) do
        click_on "Team Members"
      end
      within_current_memberships_table do
        refute page.has_content?("Test Platform Application")
      end
      # The tombstones partial won't be rendered if there aren't any tombstoned memberships.
      # TODO: This eats up a lot of time, look for a better way to check for this.
      refute page.has_css?("tbody[data-model='Membership'][data-scope='tombstones']")

      # The Membership was archived but not destroyed.
      test_app_membership = Membership.find_by(user_first_name: "Test Platform Application")
      assert test_app_membership.present?
      refute test_app_membership.tombstone?
    end
  end
end
