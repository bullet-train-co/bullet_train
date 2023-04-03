require "controllers/api/v1/test"

class Api::V1::TeamsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @teams = create_list(:team, 3)
    # 🚅 super scaffolding will insert file-related logic above this line.
    @team.save

    @another_team = create(:team)
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(team_data)
    # Fetch the team in question and prepare to compare it's attributes.
    team = Team.find(team_data["id"])

    assert_equal_or_nil team_data["name"], team.name
    assert_equal_or_nil team_data["time_zone"], team.time_zone
    assert_equal_or_nil team_data["locale"], team.locale
    # 🚅 super scaffolding will insert new fields above this line.
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    team_ids_returned = response.parsed_body.map { |team| team["id"] }
    assert_includes(team_ids_returned, @team.id)

    # But not returning other people's resources.
    assert_not_includes(team_ids_returned, @another_team.id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/teams/#{@team.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/teams/#{@team.id}", params: {
      access_token: access_token,
      team: {
        name: "Alternative String Value",
        time_zone: "Pacific Time (US & Canada)",
        locale: "Alternative String Value",
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @team.reload
    assert_equal @team.name, "Alternative String Value"
    assert_equal @team.time_zone, "Pacific Time (US & Canada)"
    assert_equal @team.locale, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/teams/#{@team.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
