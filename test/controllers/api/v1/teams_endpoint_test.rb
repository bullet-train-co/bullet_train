require "test_helper"
require "controllers/api/test"

class Api::V1::TeamsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @other_teams = create_list(:team, 3)
  end

  def assert_proper_object_serialization(team_data)
    # Fetch the team in question and prepare to compare it's attributes.
    team = Team.find(team_data["id"])
    assert_equal team_data["name"], team.name
    # 🚅 super scaffolding will insert new fields above this line.
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    team_ids_returned = response.parsed_body.dig("data").map { |team| team.dig("attributes", "id") }
    assert_includes(team_ids_returned, @team.id)

    # But not returning other people's resources.
    assert_not_includes(team_ids_returned, @other_teams[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/teams/#{@team.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    team_data = Api::V1::TeamSerializer.new(build(:team)).serializable_hash.dig(:data, :attributes)
    team_data.except!(:id, :created_at, :updated_at)

    post "/api/v1/teams",
      params: team_data.merge({access_token: access_token})

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/teams/#{@team.id}", params: {
      access_token: access_token,
      name: "Alternative String Value",
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # But we have to manually assert the value was properly updated.
    @team.reload
    assert_equal @team.name, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/teams/#{@team.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    delete "/api/v1/teams/#{@team.id}", params: {access_token: access_token}
    assert_response :not_found
  end
end
