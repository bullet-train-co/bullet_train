require "application_system_test_case"

class InvitationDetailsTest < ApplicationSystemTestCase
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

  def within_former_memberships_table
    within "tbody[data-model='Membership'][data-scope='tombstones']" do
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
      fill_in "Your Email Address", with: "hanako.tanaka@gmail.com"
      fill_in "Set Password", with: example_password
      fill_in "Confirm Password", with: example_password
      click_on "Sign Up"

      if billing_enabled?
        complete_pricing_page
      end

      # we should now be on an onboarding step.
      assert page.has_content?("Tell us about you")
      fill_in "First Name", with: "Hanako"
      fill_in "Last Name", with: "Tanaka"
      fill_in "Your Team Name", with: "The Testing Team"
      click_on "Next"

      assert page.has_content?("The Testing Team’s Dashboard")
      within_team_menu_for(display_details) do
        click_on "Team Members"
      end

      first_membership = Membership.order(:id).last

      assert page.has_content?("The Testing Team Team Members")

      # Paths that begin with "/account/" are whitelisted when accessing
      # invitation#new while passing a cancel_path to the params.
      hanakos_team = Team.first
      path_for_new_invitation = /invitations\/new/
      path_with_cancel_path_params = /invitations\/new\?cancel_path=/
      visit new_account_team_invitation_path(hanakos_team, cancel_path: account_team_memberships_path(hanakos_team))
      assert page.current_url.match?(path_with_cancel_path_params)

      # Make sure we cannot embed JavaScript when accessing the new invitation path.
      js_str = "javascript:alert('Testing')"
      visit new_account_team_invitation_path(hanakos_team, cancel_path: js_str)
      assert page.current_path.match?(path_for_new_invitation)
      assert !page.current_path.match?(js_str)
      assert !page.current_path.match?(path_with_cancel_path_params)

      # Paths that don't start with /account/ are not accepted either.
      faulty_link = "/memberships/"
      assert page.current_path.match?(path_for_new_invitation)
      visit new_account_team_invitation_path(hanakos_team, cancel_path: faulty_link)
      assert !page.current_path.match?(path_with_cancel_path_params)

      perform_enqueued_jobs do
        clear_emails

        fill_in "Email Address", with: "takashi.yamaguchi@gmail.com"
        fill_in "First Name", with: "Takashi"
        fill_in "Last Name", with: "Yamaguchi"
        find("label", text: "Invite as Team Administrator").click
        click_on "Create Invitation"
        assert page.has_content?("Invitation was successfully created.")
      end

      # we need the id of the membership that's created so we can address it's row in the table specifically.
      invited_membership = Membership.order(:id).last
      invited_membership.invitation

      within_current_memberships_table do
        assert page.has_content?("Takashi Yamaguchi")
        within_membership_row(invited_membership) do
          assert page.has_content?("Invited")
          assert page.has_content?("Team Administrator")
          click_on "Details"
        end
      end

      assert page.has_content?("Invitation Details")

      accept_alert { click_on "Remove from Team" }
      assert page.has_content?("That user has been successfully removed from the team.")

      # click the link in the email.
      # yes, this is a totally valid thing to do if you have access to the invitation email.
      # practically speaking this would almost never happen, but it's a legitimate way to test this functionality without
      # introducing more time-consuming steps.
      open_email "takashi.yamaguchi@gmail.com"
      current_email.click_link "Join The Testing Team"

      # if we're back on the team's dashboard, then we're *not* on the accept invitation page, which means the
      # invitation wasn't claimable.
      assert page.has_content?("The Testing Team’s Dashboard")
      assert page.has_content?("Sorry, but we couldn't find your invitation.")
      within_team_menu_for(display_details) do
        click_on "Team Members"
      end

      assert page.has_content?("The Testing Team Team Members")

      perform_enqueued_jobs do
        clear_emails

        within_former_memberships_table do
          assert page.has_content?("Takashi Yamaguchi")
          within_membership_row(invited_membership) do
            assert page.has_no_content?("Invited")
            assert page.has_content?("Team Administrator")
          end
        end

        accept_alert { click_on "Re-Invite to Team" }
        assert page.has_content?("The user has been successfully re-invited. They will receive an email to rejoin the team.")
      end

      # sign out.
      sign_out_for(display_details)

      # click the link in the email.
      open_email "takashi.yamaguchi@gmail.com"
      current_email.click_link "Join The Testing Team"

      assert page.has_content?("Create Your Account")
      # this email address is purposefully different than the one they were invited via.
      fill_in "Your Email Address", with: "takashi@yamaguchi.com"
      fill_in "Set Password", with: another_example_password
      fill_in "Confirm Password", with: another_example_password
      click_on "Sign Up"

      # The email was sent to takashi.yamaguchi@gmail.com,
      # but since the user signed up with the email takashi@yamaguchi.com,
      # we have to confirm that we actually want to join the team under this account.
      click_on "Join The Testing Team"

      # this first name is purposefully different than the name they were invited with.
      # assert page.has_content?('Create Your Account')
      assert page.has_content?("Tell us about you")
      fill_in "First Name", with: "Taka"
      fill_in "Last Name", with: "Yamaguchi"
      click_on "Next"

      assert page.has_content?("The Testing Team’s Dashboard")
      within_team_menu_for(display_details) do
        click_on "Team Members"
      end

      assert page.has_content?("Hanako Tanaka")

      last_membership = Membership.order(:id).last

      within_current_memberships_table do
        assert page.has_content?("Taka Yamaguchi")
        within_membership_row(last_membership) do
          assert page.has_no_content?("Invited")
          assert page.has_content?("Team Administrator")
          click_on "Details"
        end
      end

      assert page.has_content?("Taka Yamaguchi’s Membership on The Testing Team")

      # Users cannot create another team in invitation-only mode.
      unless invitation_only?
        within_user_menu_for(display_details) do
          click_on "Add New Team"
        end

        assert page.has_content?("Create a New Team")
        fill_in "Team Name", with: "Another Team"
        click_on "Create Team"

        assert page.has_content?("Another Team’s Dashboard")
        within_team_menu_for(display_details) do
          click_on "Team Members"
        end

        assert page.has_content?("Another Team Team Members")
        click_on "Invite a New Team Member"

        assert page.has_content?("New Invitation Details")

        perform_enqueued_jobs do
          clear_emails

          # this is specifically a different email address than the one they signed up with originally.
          fill_in "Email Address", with: "hanako@some-company.com"
          click_on "Create Invitation"
          assert page.has_content?("Invitation was successfully created.")
        end

        # sign out.
        sign_out_for(display_details)

        # we need the id of the membership that's created so we can address it's row in the table specifically.
        invited_membership = Membership.order(:id).last

        # # click the link in the email.
        open_email "hanako@some-company.com"
        current_email.click_link "Join Another Team"

        assert page.has_content?("Create Your Account")
        click_link "Already have an account?"

        assert page.has_content?("Sign In")
        fill_in "Your Email Address", with: "hanako.tanaka@gmail.com"
        click_on "Next" if two_factor_authentication_enabled?
        fill_in "Your Password", with: example_password
        click_on "Sign In"

        assert page.has_content?("Join Another Team")
        assert page.has_content?("Taka Yamaguchi has invited you to join Another Team")
        assert page.has_content?("This invitation was emailed to hanako@some-company.com")
        assert page.has_content?("but you're currently signed in as hanako.tanaka@gmail.com")
        click_on "Join Another Team"

        assert page.has_content?("Welcome to Another Team!")

        within_team_menu_for(display_details) do
          click_on "Team Members"
        end

        last_membership = Membership.order(:id).last

        within_current_memberships_table do
          assert page.has_content?("Hanako Tanaka")
          within_membership_row(last_membership) do
            assert page.has_no_content?("Invited")
            assert page.has_content?("Viewer")
            click_on "Details"
          end
        end

        accept_alert { click_on "Leave This Team" }

        assert page.has_content?("You've successfully removed yourself from Another Team.")

        assert page.has_content?("The Testing Team’s Dashboard")
      end

      # Make sure we're actually signed in as Hanako and on the Team Members page.
      sign_out_for(display_details)
      visit root_url
      fill_in "Your Email Address", with: "hanako.tanaka@gmail.com"
      click_on "Next" if two_factor_authentication_enabled?
      fill_in "Your Password", with: example_password
      click_on "Sign In"
      within_team_menu_for(display_details) do
        click_on "Team Members"
      end

      assert page.has_content?("The Testing Team Team Members")
      within_current_memberships_table do
        assert page.has_content?("Hanako Tanaka")
        within_membership_row(first_membership) do
          assert page.has_content?("Team Administrator")
          click_on "Details"
        end
      end

      assert page.has_content?("Hanako Tanaka’s Membership on The Testing Team")
      accept_alert { click_on "Demote from Admin" }

      assert page.has_content?("The Testing Team Team Members")
      within_current_memberships_table do
        assert page.has_content?("Hanako Tanaka")
        within_membership_row(first_membership) do
          assert page.has_no_content?("Team Administrator")
          click_on "Details"
        end
      end

      assert page.has_content?("Hanako Tanaka’s Membership on The Testing Team")

      # since the user is no longer an admin, they shouldn't see either of these options anymore.
      assert page.has_content?("Viewer")
      assert page.has_no_content?("Promote to Admin")
      assert page.has_no_content?("Demote from Admin")

      accept_alert { click_on "Leave This Team" }

      # if this is happening, it shouldn't be.
      assert page.has_no_content?("You are not authorized to access this page.")

      assert page.has_content?("You've successfully removed yourself from The Testing Team.")

      assert page.has_content?("Join a Team")
      assert page.has_content?("The account hanako.tanaka@gmail.com is not currently a member of any teams.")
      assert page.has_content?("Accept an invitation")
      assert page.has_content?("Log out of this account")
      assert page.has_content?("Create a new team")

      click_on "Logout"
    end
  end
end
