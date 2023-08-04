require "application_system_test_case"

class MembershipSystemTest < ApplicationSystemTestCase
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

      # we should now be on an onboarding step.
      assert page.has_content?("Tell us about you")
      fill_in "First Name", with: "Jane"
      fill_in "Last Name", with: "Smith"
      fill_in "Your Team Name", with: "The Testing Team"
      click_on "Next"

      if billing_enabled?
        unless freemium_enabled?
          complete_pricing_page
        end
      end

      within_team_menu_for(display_details) do
        click_on "Team Members"
      end

      assert page.has_content?("The Testing Team Team Members")
      click_on "Invite a New Team Member"

      fill_in "Email Address", with: "takashi.yamaguchi@gmail.com"
      fill_in "First Name", with: "Takashi"
      fill_in "Last Name", with: "Yamaguchi"
      find("label", text: "Invite as Team Administrator").click
      click_on "Create Invitation"

      assert page.has_content?("Invitation was successfully created.")

      invited_membership = Membership.find_by(user_email: "takashi.yamaguchi@gmail.com")

      within_current_memberships_table do
        assert page.has_content?("Takashi Yamaguchi")
        within_membership_row(invited_membership) do
          assert page.has_content?("Invited")
          assert page.has_content?("Team Administrator")
          click_on "Details"
        end
      end

      assert page.has_content?("SPECIAL PRIVILEGES")
      assert page.has_content?("Team Administrator")

      accept_alert do
        click_on "Demote from Admin"
      end

      within_current_memberships_table do
        within_membership_row(invited_membership) do
          assert page.has_no_content?("Team Administrator")
          assert page.has_content?("Viewer")
          click_on "Details"
        end
      end

      assert page.has_content?("SPECIAL PRIVILEGES")
      assert page.has_no_content?("Team Administrator")
      assert page.has_content?("Viewer")

      accept_alert { click_on "Promote to Admin" }

      within_current_memberships_table do
        within_membership_row(invited_membership) do
          assert page.has_content?("Team Administrator")
          click_on "Details"
        end
      end

      assert page.has_content? "Invitation Details"
      click_on "Settings"

      assert page.has_content? "Update Membership Settings"
      fill_in "First Name", with: "Yuto"
      fill_in "Last Name", with: "Nishiyama"
      # this is removing their admin privileges.
      find("label", text: "Grant Privileges of Team Administrator").click
      click_on "Update Membership"

      assert page.has_no_content?("Takashi Yamaguchi")
      assert page.has_no_content?("Team Administrator")

      assert page.has_content?("Yuto Nishiyama")
      assert page.has_content?("Viewer")

      accept_alert { click_on "Remove from Team" }

      within_current_memberships_table do
        assert page.has_no_content?("Yuto Nishiyama")
      end

      # We assume all of the membership information is still there, even if the user never registered.
      unregistered_membership = Membership.find_by(user_first_name: "Yuto", user_last_name: "Nishiyama")
      assert unregistered_membership.user_id.nil?
      assert unregistered_membership.invitation.nil?
      assert unregistered_membership.tombstone?
      assert unregistered_membership.user_email.present?

      within_former_memberships_table do
        assert page.has_content?("Yuto Nishiyama")
        assert page.has_content?("Viewer")
        accept_alert { click_on "Re-Invite to Team" }
      end

      assert page.has_content?("The user has been successfully re-invited. They will receive an email to rejoin the team.")

      within_current_memberships_table do
        assert page.has_content?("Yuto Nishiyama")
        within_membership_row(invited_membership) do
          assert page.has_content?("Viewer")
          click_on "Details"
        end
      end

      assert page.has_content?("Yuto Nishiyama’s Membership on The Testing Team")
      assert page.has_content?("Invitation Details")
      click_on "Back"

      assert page.has_content?("The Testing Team Team Members")
    end
  end
end
