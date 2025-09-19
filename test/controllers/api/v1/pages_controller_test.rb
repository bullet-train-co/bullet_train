require "controllers/api/v1/test"

class Api::V1::PagesControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @page = build(:page, team: @team)
    @other_pages = create_list(:page, 3)

    @another_page = create(:page, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @page.save
    @another_page.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  teardown do
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(page_data)
    # Fetch the page in question and prepare to compare it's attributes.
    page = Page.find(page_data["id"])

    assert_equal_or_nil page_data['name'], page.name
    assert_equal_or_nil page_data['path'], page.path
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal page_data["team_id"], page.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/pages", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    page_ids_returned = response.parsed_body.map { |page| page["id"] }
    assert_includes(page_ids_returned, @page.id)

    # But not returning other people's resources.
    assert_not_includes(page_ids_returned, @other_pages[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/pages/#{@page.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/pages/#{@page.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    page_data = JSON.parse(build(:page, team: nil).api_attributes.to_json)
    page_data.except!("id", "team_id", "created_at", "updated_at")
    params[:page] = page_data

    post "/api/v1/teams/#{@team.id}/pages", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/pages",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/pages/#{@page.id}", params: {
      access_token: access_token,
      page: {
        name: 'Alternative String Value',
        path: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @page.reload
    assert_equal @page.name, 'Alternative String Value'
    assert_equal @page.path, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/pages/#{@page.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Page.count", -1) do
      delete "/api/v1/pages/#{@page.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/pages/#{@another_page.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
