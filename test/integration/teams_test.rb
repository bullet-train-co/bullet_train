require 'test_helper'

class TeamsTest < ActionDispatch::IntegrationTest

  def setup
    super
    @jane = create :onboarded_user, first_name: 'Jane', last_name: 'Smith'
    @john = create :onboarded_user, first_name: 'John', last_name: 'Smith'
  end

  @@test_devices.each do |device_name, display_details|

  test "admin can create new team on a #{device_name}" do
    resize_for(display_details)
    be_invited_to_sign_up
    login_as(@jane, :scope => :user)
    visit new_account_team_path
    fill_in 'Name', with: 'Team Jane'
    click_on 'Create Team'

    # we only see the plans page if payments are enabled.
    if subscriptions_enabled?
      assert page.has_content?("Select Your Plan")
    else
      assert page.has_content?('Team Jane')
    end
  end

  test "admin can't create empty team on a #{device_name}" do
    resize_for(display_details)
    be_invited_to_sign_up
    login_as(@jane, :scope => :user)
    visit new_account_team_path
    fill_in 'Name', with: ''
    click_on 'Create Team'
    assert page.has_content?("Name can't be blank.")
  end

  test "user can see list of teams on a #{device_name}" do
    resize_for(display_details)
    login_as(@jane, :scope => :user)
    @teams = create_list :team, 3
    @foreign_team = create :team, name: 'Foreign Team'
    @teams.each { |team| team.users << @jane }
    visit account_teams_path
    @teams.each do |team|
      assert page.has_content?(team.name.upcase)
    end
    assert page.has_no_content?(@foreign_team.name)
  end

  test "user can edit team on a #{device_name}" do
    resize_for(display_details)
    login_as(@jane, :scope => :user)
    visit account_team_path(@jane.current_team)
    click_on 'Edit Team'
    fill_in 'Name', with: 'Changed Team'
    click_on 'Update Team'

    assert page.has_content?('Team was successfully updated.')
    assert page.has_content?('Changed Team')
  end

  test "user can't save invalid team on a #{device_name}" do
    resize_for(display_details)
    login_as(@jane, :scope => :user)
    visit account_team_path(@jane.current_team)
    click_link 'Edit Team'
    fill_in 'Name', with: ''
    click_on 'Update Team'

    assert page.has_content?('Please correct the errors below.')
    assert page.has_content?("Name can't be blank.")
  end

  end

end
