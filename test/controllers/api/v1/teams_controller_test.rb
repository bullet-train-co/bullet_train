# frozen_string_literal: true

require 'test_helper'

class Api::TeamsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = FactoryBot.create(:onboarded_user)
    @another_user = FactoryBot.create(:onboarded_user)
    @api_key = FactoryBot.create(:api_key, user: @user)
    @another_api_key = FactoryBot.create(:api_key, user: @another_user)
    @team = @user.current_team
    FactoryBot.create_list(:team, 3)
  end

  def auth_header
    { 'authorization': "Basic #{Base64.encode64("#{@api_key.token}:#{@api_key.secret}")}" }
  end

  def another_auth_header
    { 'authorization': "Basic #{Base64.encode64("#{@another_api_key.token}:#{@another_api_key.secret}")}" }
  end

  def strip_timestamps(parsed_body)
    parsed_body['data']['attributes'] = parsed_body.dig('data', 'attributes').except('created-at', 'updated-at')
    parsed_body
  end

  def strip_timestamps_from_index_item(data)
    data['attributes'] = data['attributes'].except('created-at', 'updated-at')
    data
  end

  def strip_timestamps_from_index(parsed_body)
    parsed_body['data'] = parsed_body['data'].map { |data| strip_timestamps_from_index_item(data) }
    parsed_body
  end

  test '#index' do
    get api_v1_teams_path, headers: auth_header
    assert_response :success
    assert_equal(
      {
        'data' => [
          {
            'id' => @team.id.to_s,
            'type' => 'teams',
            'attributes' => { 'name' => 'Your Team' }
          }
        ]
      }, strip_timestamps_from_index(response.parsed_body)
    )
  end

  test '#show' do
    get api_v1_team_path(@team), headers: auth_header
    assert_response :success
    assert_equal(
      {
        'data' => {
          'id' => @team.id.to_s,
          'type' => 'teams',
          'attributes' => { 'name' => 'Your Team' }
        }
      }, strip_timestamps(response.parsed_body)
    )

    assert_raises CanCan::AccessDenied do
      get api_v1_team_path(@team), headers: another_auth_header
    end
  end

  test '#create' do
    post api_v1_teams_path, params: { team: { name: 'Chicago Bulls' } }, headers: auth_header
    assert_response :success
    assert_equal(
      {
        'data' => {
          'id' => Team.find_by_name('Chicago Bulls').id.to_s,
          'type' => 'teams',
          'attributes' => { 'name' => 'Chicago Bulls' }
        }
      }, strip_timestamps(response.parsed_body)
    )
  end

  test '#update' do
    put api_v1_team_path(@team), params: { team: { name: 'Boston Celtics' } }, headers: auth_header
    assert_response :success
    assert_equal(
      {
        'data' => {
          'id' => @team.id.to_s,
          'type' => 'teams',
          'attributes' => { 'name' => 'Boston Celtics' }

        }
      }, strip_timestamps(response.parsed_body)
    )

    assert_raises CanCan::AccessDenied do
      put api_v1_team_path(@team), params: { team: { name: 'Boston Celtics' } }, headers: another_auth_header
    end
  end

  # test '#destroy' do
  #   assert_raises CanCan::AccessDenied do
  #     delete api_v1_team_path(@team), headers: another_auth_header
  #   end
  #
  #   assert_difference('Team.count', -1) do
  #     delete api_v1_team_path(@team), headers: auth_header
  #   end
  # end

end
