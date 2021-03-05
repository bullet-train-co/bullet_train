require "test_helper"

class Account::TeamsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = FactoryBot.create(:onboarded_user)
    sign_in @user
    @team = @user.current_team
  end

  test "should get redirect to team homepage" do
    get account_teams_url
    assert_redirected_to account_team_path(@team)
  end

  test "should get index" do
    @user.teams << create(:team)
    get account_teams_url
    assert_response :success
  end

  test "should get new" do
    get new_account_team_url
    assert_response :success
  end

  test "should create team" do
    skip if invitation_only?
    assert_difference("Team.count") do
      post account_teams_url, params: {team: {name: @team.name}}
    end
    assert_redirected_to account_team_url(Team.last)
  end

  test "should show team" do
    get account_team_url(@team)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_team_url(@team)
    assert_response :success
  end

  test "should update team" do
    patch account_team_url(@team), params: {team: {name: @team.name}}
    assert_redirected_to account_team_url(@team)
  end
end
