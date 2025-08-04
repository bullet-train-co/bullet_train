require "application_system_test_case"

class InvitationDetailsTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    @john = create :onboarded_user, first_name: "John", last_name: "Smith", email: "john@bullettrain.co"

    login_as(@jane, scope: :user)
    visit root_path
    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
        sleep 2
      end
    end
  end

  device_test "admin can create new non admin invitation" do
    visit new_account_team_invitation_path(@jane.current_team)
    fill_in "Email", with: "someone@bullettrain.co"
    click_on "Create Invitation"
    assert page.has_no_css?('div[data-title="Admin"]')
    assert_text("Invitation was successfully created.")
    assert_text("someone@bullettrain.co")
  end

  device_test "admin can create new admin invitation" do
    visit new_account_team_invitation_path(@jane.current_team)
    fill_in "Email", with: "someone@bullettrain.co"
    check "Invite as Team Administrator"
    click_on "Create Invitation"
    assert_text("Team Administrator")
    assert_text("Invitation was successfully created.")
    assert_text("someone@bullettrain.co")
  end

  device_test "admin can't create invalid invitation" do
    visit new_account_team_invitation_path(@jane.current_team)
    fill_in "Email", with: ""
    click_on "Create Invitation"
    assert_text("Please correct the errors below.")
    assert_text("Email Address can't be blank.")
  end

  device_test "admin can cancel invitation" do
    membership = Membership.new(team: @jane.current_team, user_email: @john.email)
    create :invitation, team: @jane.current_team, from_membership: @jane.memberships.first, email: @john.email, membership: membership

    # Cannot create a duplicate invitation
    assert_raises(ActiveRecord::RecordInvalid, "Email Address has already been taken") do
      create :invitation, team: @jane.current_team, from_membership: @jane.memberships.first, email: @john.email, membership: membership
    end

    visit account_team_invitations_path(@jane.current_team)
    assert_text("john@bullettrain.co")
    within "tbody[data-model='Membership'] tr[data-id='#{membership.id}']" do
      click_link "Details"
    end
    accept_alert do
      click_on "Remove from Team"
    end
    assert_text("That user has been successfully removed from the team.")
    within "tbody[data-model='Membership'][data-scope='current']" do
      assert page.has_no_content?("john@bullettrain.co")
    end
    within "tbody[data-model='Membership'][data-scope='tombstones']" do
      assert_text("john@bullettrain.co")
    end
  end
end
