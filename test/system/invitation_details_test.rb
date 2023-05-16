require "application_system_test_case"

class InvitationsTest < ApplicationSystemTestCase
  def setup
    super
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

  @@test_devices.each do |device_name, display_details|
    test "admin can create new non admin invitation on a #{device_name}" do
      resize_for(display_details)
      visit new_account_team_invitation_path(@jane.current_team)
      fill_in "Email", with: "someone@bullettrain.co"
      click_on "Create Invitation"
      assert page.has_no_css?('div[data-title="Admin"]')
      assert page.has_content?("Invitation was successfully created.")
      assert page.has_content?("someone@bullettrain.co")
    end

    test "admin can create new admin invitation on a #{device_name}" do
      resize_for(display_details)
      visit new_account_team_invitation_path(@jane.current_team)
      fill_in "Email", with: "someone@bullettrain.co"
      check "Invite as Team Administrator"
      click_on "Create Invitation"
      assert page.has_content?("Team Administrator")
      assert page.has_content?("Invitation was successfully created.")
      assert page.has_content?("someone@bullettrain.co")
    end

    test "admin can't create invalid invitation on a #{device_name}" do
      resize_for(display_details)
      visit new_account_team_invitation_path(@jane.current_team)
      fill_in "Email", with: ""
      click_on "Create Invitation"
      assert page.has_content?("Please correct the errors below.")
      assert page.has_content?("Email Address can't be blank.")
    end

    test "admin can cancel invitation on a #{device_name}" do
      resize_for(display_details)
      membership = Membership.new(team: @jane.current_team, user_email: @john.email)
      create :invitation, team: @jane.current_team, from_membership: @jane.memberships.first, email: @john.email, membership: membership
      visit account_team_invitations_path(@jane.current_team)
      assert page.has_content?("john@bullettrain.co")
      within "tbody[data-model='Membership'] tr[data-id='#{membership.id}']" do
        click_link "Details"
      end
      accept_alert do
        click_on "Remove from Team"
      end
      assert page.has_content?("That user has been successfully removed from the team.")
      within "tbody[data-model='Membership'][data-scope='current']" do
        assert page.has_no_content?("john@bullettrain.co")
      end
      within "tbody[data-model='Membership'][data-scope='tombstones']" do
        assert page.has_content?("john@bullettrain.co")
      end
    end
  end
end
