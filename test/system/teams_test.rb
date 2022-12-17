require "application_system_test_case"

class TeamsTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    @john = create :onboarded_user, first_name: "John", last_name: "Smith"
    @jack = create :user, first_name: "Jack", last_name: "Smith"
  end

  @@test_devices.each do |device_name, display_details|
    test "admin can create new team on a #{device_name}" do
      resize_for(display_details)
      be_invited_to_sign_up
      login_as(@jane, scope: :user)
      visit new_account_team_path
      fill_in "Name", with: "Team Jane"
      click_on "Create Team"

      # we only see the plans page if payments are enabled.
      if billing_enabled?
        assert page.has_content?("Select Your Plan")
      else
        assert page.has_content?("Team Jane")
      end
    end

    test "admin can't create empty team on a #{device_name}" do
      resize_for(display_details)
      be_invited_to_sign_up
      login_as(@jane, scope: :user)
      visit new_account_team_path
      fill_in "Name", with: ""
      click_on "Create Team"
      assert page.has_content?("Name can't be blank.")
    end

    test "user can see list of teams on a #{device_name}" do
      resize_for(display_details)
      login_as(@jane, scope: :user)
      @teams = create_list :team, 3
      @foreign_team = create :team, name: "Foreign Team"
      @teams.each { |team| team.users << @jane }
      visit account_teams_path
      @teams.each do |team|
        assert page.has_content?(team.name.upcase)
      end
      assert page.has_no_content?(@foreign_team.name)
    end

    test "user can edit team on a #{device_name}" do
      resize_for(display_details)
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)
      within_team_menu_for(display_details) do
        click_link "Team Settings"
      end
      fill_in "Name", with: "Changed Team"
      click_on "Update Team"

      assert page.has_content?("Team was successfully updated.")
      assert page.has_content?("Changed Team")
    end

    test "user can't save invalid team on a #{device_name}" do
      resize_for(display_details)
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)
      within_team_menu_for(display_details) do
        click_link "Team Settings"
      end
      fill_in "Name", with: ""
      click_on "Update Team"

      assert page.has_content?("Please correct the errors below.")
      assert page.has_content?("Name can't be blank.")
    end

    test "#admins shows current and invited admins only on a #{device_name}" do
      resize_for(display_details)
      login_as(@jane, scope: :user)
      team = @jane.current_team

      assert team.admins.include?(@jane.memberships.first)

      # Shows invited admins
      assert_difference "team.admins.size" do
        visit new_account_team_invitation_path(team)
        fill_in "Email Address", with: "admin@user.com"
        fill_in "First Name", with: "Admin"
        fill_in "Last Name", with: "User"
        check "Invite as Team Administrator"
        click_on "Create Invitation"
        visit root_path
      end
      assert team.admins.include?(Membership.find_by(user_email: "admin@user.com"))

      # Does not show invited non-admins
      assert_no_difference "team.admins.size" do
        visit new_account_team_invitation_path(team)
        fill_in "Email Address", with: "non-admin@user.com"
        fill_in "First Name", with: "Non"
        fill_in "Last Name", with: "Admin"
        click_on "Create Invitation"
        visit root_path
      end
      assert team.admins.exclude?(Membership.find_by(user_email: "non-admin@user.com"))

      # Shows admins after invitation is accepted
      assert_no_difference "team.admins.size" do
        team_admin_invite = Invitation.find_by(email: "admin@user.com")
        team_admin_invite.accept_for(@jack)
        assert team_admin_invite.destroyed?
      end
      assert team.admins.include?(@jack.memberships.first)

      # Does not show admins who left the team
      assert_difference "team.admins.size", -1 do
        visit account_membership_path(@jack.memberships.first)
        accept_confirm do
          click_on "Remove from Team"
        end
        assert page.has_content?("That user has been successfully removed from the team.")
        tombstoned_membership = Membership.find_by(user_email: "admin@user.com")
        assert tombstoned_membership.tombstone?
      end
      assert team.admins.exclude?(@jack.memberships.first)
    end
  end
end
