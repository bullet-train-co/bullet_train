require "application_system_test_case"

class MembershipSystemTest < ApplicationSystemTestCase
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

    within_team_menu_for(display_details) do
      click_on "Team Members"
    end

    assert_text("The Testing Team Team Members")
    click_on "Invite a New Team Member"

    fill_in "Email Address", with: "takashi.yamaguchi@gmail.com"
    fill_in "First Name", with: "Takashi"
    fill_in "Last Name", with: "Yamaguchi"
    find("label", text: "Invite as Team Administrator").click
    click_on "Create Invitation"

    assert_text("Invitation was successfully created.")

    invited_membership = Membership.find_by(user_email: "takashi.yamaguchi@gmail.com")

    within_current_memberships_table do
      assert_text("Takashi Yamaguchi")
      within_membership_row(invited_membership) do
        assert_text("Invited")
        assert_text("Team Administrator")
        click_on "Details"
      end
    end

    assert_text("SPECIAL PRIVILEGES")
    assert_text("Team Administrator")

    accept_alert do
      click_on "Demote from Admin"
    end

    within_current_memberships_table do
      within_membership_row(invited_membership) do
        assert page.has_no_content?("Team Administrator")
        assert_text("Viewer")
        click_on "Details"
      end
    end

    assert_text("SPECIAL PRIVILEGES")
    assert page.has_no_content?("Team Administrator")
    assert_text("Viewer")

    accept_alert { click_on "Promote to Admin" }

    within_current_memberships_table do
      within_membership_row(invited_membership) do
        assert_text("Team Administrator")
        click_on "Details"
      end
    end

    assert_text "Invitation Details"
    click_on "Settings"

    assert_text "Update Membership Settings"
    fill_in "First Name", with: "Yuto"
    fill_in "Last Name", with: "Nishiyama"
    # this is removing their admin privileges.
    find("label", text: "Grant Privileges of Team Administrator").click
    click_on "Update Membership"

    assert page.has_no_content?("Takashi Yamaguchi")
    assert page.has_no_content?("Team Administrator")

    assert_text("Yuto Nishiyama")
    assert_text("Viewer")

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
      assert_text("Yuto Nishiyama")
      assert_text("Viewer")
      accept_alert { click_on "Re-Invite to Team" }
    end

    assert_text("The user has been successfully re-invited. They will receive an email to rejoin the team.")

    within_current_memberships_table do
      assert_text("Yuto Nishiyama")
      within_membership_row(invited_membership) do
        assert_text("Viewer")
        click_on "Details"
      end
    end

    assert_text("Yuto Nishiyama’s Membership on The Testing Team")
    assert_text("Invitation Details")
    click_on "Back"

    assert_text("The Testing Team Team Members")
  end
end
