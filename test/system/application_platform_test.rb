require "application_system_test_case"

class ApplicationPlatformSystemTest < ApplicationSystemTestCase
  device_test "visitors can sign-up and manage team members with subscriptions #{billing_enabled? ? "enabled" : "disabled"}" do
    be_invited_to_sign_up

    visit root_path
    new_registration_page_for(display_details)

    # try non-matching passwords.
    fill_in "Your Email Address", with: "jane.smith@gmail.com"
    fill_in "Set Password", with: example_password
    fill_in "Confirm Password", with: example_password
    click_on "Sign Up"

    # we should now be on an onboarding step.
    assert_text("Tell us about you")
    fill_in "First Name", with: "Jane"
    fill_in "Last Name", with: "Smith"
    fill_in "Your Team Name", with: "The Testing Team"
    click_on "Next"
    click_on "Skip" if bulk_invitations_enabled?

    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
      end
    end

    # Create a new Platform Application
    if disable_developer_menu?
      visit account_team_platform_applications_path(User.find_by(email: "jane.smith@gmail.com").current_team)
    else
      within_developers_menu_for(display_details) do
        click_on "API"
      end
    end
    click_on "Provision New Platform Application"
    fill_in "Name", with: "Test Platform Application"
    click_on "Provision Platform Application"
    assert_text("Platform Application was successfully created.")

    @team = Team.find_by(name: "The Testing Team")

    # Ensure that Platform Application is present in the Memberships list.
    visit account_team_memberships_path(@team)
    within_current_memberships_table do
      assert_text("Test Platform Application")
    end

    # Remove the Platform Application and ensure it's
    # not present in the tombstoned Memberships list.
    if disable_developer_menu?
      visit account_team_platform_applications_path(User.find_by(email: "jane.smith@gmail.com").current_team)
    else
      within_developers_menu_for(display_details) do
        click_on "API"
      end
    end
    accept_alert { click_on("Delete") }

    visit account_team_memberships_path(@team)
    within_current_memberships_table do
      refute_text("Test Platform Application")
    end
    # The tombstones partial won't be rendered if there aren't any tombstoned memberships.
    assert_no_selector "h2", text: "Former Team Members"

    # The Membership was archived but not destroyed.
    device_test_app_membership = Membership.find_by(user_first_name: "Test Platform Application")
    assert device_test_app_membership.present?
    refute device_test_app_membership.tombstone?
  end
end
