require "controllers/api/v1/test"

class Api::V1::SitesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @site = build(:site, team: @team)
    @other_sites = create_list(:site, 3)

    @another_site = create(:site, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @site.save
    @another_site.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(site_data)
    # Fetch the site in question and prepare to compare it's attributes.
    site = Site.find(site_data["id"])

    assert_equal_or_nil site_data["name"], site.name
    assert_equal_or_nil site_data["url"], site.url
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal site_data["team_id"], site.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/sites", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    site_ids_returned = response.parsed_body.map { |site| site["id"] }
    assert_includes(site_ids_returned, @site.id)

    # But not returning other people's resources.
    assert_not_includes(site_ids_returned, @other_sites[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/sites/#{@site.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/sites/#{@site.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    site_data = JSON.parse(build(:site, team: nil).api_attributes.to_json)
    site_data.except!("id", "team_id", "created_at", "updated_at")
    params[:site] = site_data

    post "/api/v1/teams/#{@team.id}/sites", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/sites",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/sites/#{@site.id}", params: {
      access_token: access_token,
      site: {
        name: "Alternative String Value",
        url: "Alternative String Value",
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @site.reload
    assert_equal @site.name, "Alternative String Value"
    assert_equal @site.url, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/sites/#{@site.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Site.count", -1) do
      delete "/api/v1/sites/#{@site.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/sites/#{@another_site.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
