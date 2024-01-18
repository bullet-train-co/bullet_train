require "application_system_test_case"

class TeamsTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    @john = create :onboarded_user, first_name: "John", last_name: "Smith"
    @jack = create :user, first_name: "Jack", last_name: "Smith"
  end

  device_test "admin can create new team" do
    be_invited_to_sign_up
    login_as(@jane, scope: :user)
    visit new_account_team_path
    fill_in "Name", with: "Team Jane"
    click_on "Create Team"

    # we only see the plans page if payments are enabled.
    if billing_enabled? && !freemium_enabled?
      assert_text("The Pricing Page")
    else
      assert_text("Team Jane")
    end
  end

  device_test "admin can't create empty team" do
    be_invited_to_sign_up
    login_as(@jane, scope: :user)
    visit new_account_team_path
    fill_in "Name", with: ""
    click_on "Create Team"
    assert_text("Name can't be blank.")
  end

  device_test "user can see list of teams" do
    login_as(@jane, scope: :user)
    @teams = create_list :team, 3
    @foreign_team = create :team, name: "Foreign Team"
    @teams.each { |team| team.users << @jane }
    visit account_teams_path
    @teams.each do |team|
      assert_text(team.name.upcase)
    end
    assert page.has_no_content?(@foreign_team.name)
  end

  device_test "user can edit team" do
    login_as(@jane, scope: :user)
    visit account_team_path(@jane.current_team)

    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
      end
    end

    within_team_menu_for(display_details) do
      click_link "Team Settings"
    end
    fill_in "Name", with: "Changed Team"
    click_on "Update Team"

    assert_text("Team was successfully updated.")
    assert_text("Changed Team")
  end

  device_test "user can't save invalid team" do
    login_as(@jane, scope: :user)
    visit account_team_path(@jane.current_team)

    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
      end
    end

    within_team_menu_for(display_details) do
      click_link "Team Settings"
    end
    fill_in "Name", with: ""
    click_on "Update Team"

    assert_text("Please correct the errors below.")
    assert_text("Name can't be blank.")
  end

  device_test "#admins shows current and invited admins only" do
    login_as(@jane, scope: :user)
    team = @jane.current_team

    assert team.admins.include?(@jane.memberships.first)

    # Ensure user has subscribed to billing plan.
    visit root_path
    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
        sleep 2
      end
    end

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
      assert_text("That user has been successfully removed from the team.")
      tombstoned_membership = Membership.find_by(user_email: "admin@user.com")
      assert tombstoned_membership.tombstone?
    end
    assert team.admins.exclude?(@jack.memberships.first)
  end

  device_test "user can delete a team" do
    be_invited_to_sign_up
    login_as(@jane, scope: :user)

    # Add another team besides the one they were onboarded with.
    visit new_account_team_path
    fill_in "Name", with: "Another Team"
    click_on "Create Team"
    assert_text "Team was successfully created."
    User.find_by(first_name: "Jane").teams.size

    edit_team_path = edit_account_team_path(Team.find_by(name: "Another Team"))
    visit edit_team_path
    assert_text "Edit Team Details"

    assert_difference "Team.count", -1 do
      accept_alert { click_on "Delete Team" }
      assert_text "Team was successfully destroyed."
    end
  end

  device_test "user cannot delete the last team they belong to" do
    be_invited_to_sign_up
    login_as(@jane, scope: :user)

    edit_team_path = edit_account_team_path(Team.find_by(name: "Your Team"))
    visit edit_team_path
    assert_text "Edit Team Details"

    assert_no_difference "Team.count" do
      accept_alert { click_on "Delete Team" }
      assert_text "You cannot delete the last team you belong to."
    end
  end

  device_test "user can delete a team after they have invited someone" do
    be_invited_to_sign_up
    login_as(@jane, scope: :user)

    # Create another team so we're not deleting the last team.
    visit new_account_team_path
    fill_in "Name", with: "Another Team"
    click_on "Create Team"
    assert_text "Team was successfully created."
    User.find_by(first_name: "Jane").teams.size

    # Create a new Membership on the original Team by sending an Invitation
    team_invitation_path = new_account_team_invitation_path(Team.find_by(name: "Your Team"))
    visit team_invitation_path
    fill_in "Email", with: "someone@bullettrain.co"
    click_on "Create Invitation"
    assert_text("Invitation was successfully created.")

    # Delete the Team.
    edit_team_path = edit_account_team_path(Team.find_by(name: "Your Team"))
    visit edit_team_path
    assert_text "Edit Team Details"
    assert_difference "Team.count", -1 do
      accept_alert { click_on "Delete Team" }
      assert_text "Team was successfully destroyed."
    end
  end
end
