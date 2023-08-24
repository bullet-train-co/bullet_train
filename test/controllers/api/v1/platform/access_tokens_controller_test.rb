require "controllers/api/v1/test"

class Api::V1::Platform::AccessTokensControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @application = create(:platform_application, team: @team)
    @access_token = build(:platform_access_token, application: @application)
    @other_access_tokens = create_list(:platform_access_token, 3)
    # 🚅 super scaffolding will insert file-related logic above this line.
    @access_token.save

    @another_access_token = create(:platform_access_token, application: @application)
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(access_token_data)
    # Fetch the access_token in question and prepare to compare it's attributes.
    access_token = Platform::AccessToken.find(access_token_data["id"])

    assert_equal_or_nil access_token_data["token"], access_token.token
    # assert_equal_or_nil DateTime.parse(access_token_data['last_used_at']), access_token.last_used_at
    assert_equal_or_nil access_token_data["description"], access_token.description
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal access_token_data["application_id"], access_token.application_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/platform/applications/#{@application.id}/access_tokens", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    access_token_ids_returned = response.parsed_body.map { |access_token| access_token["id"] }
    assert_includes(access_token_ids_returned, @access_token.id)

    # But not returning other people's resources.
    assert_not_includes(access_token_ids_returned, @other_access_tokens[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/platform/access_tokens/#{@access_token.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/platform/access_tokens/#{@access_token.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    access_token_data = JSON.parse(build(:platform_access_token, application: nil).api_attributes.to_json)
    access_token_data.except!("id", "application_id", "created_at", "updated_at")
    params[:platform_access_token] = access_token_data

    post "/api/v1/platform/applications/#{@application.id}/access_tokens", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/platform/applications/#{@application.id}/access_tokens",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/platform/access_tokens/#{@access_token.id}", params: {
      access_token: access_token,
      platform_access_token: {
        description: "Alternative String Value",
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @access_token.reload
    assert_equal @access_token.description, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/platform/access_tokens/#{@access_token.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    # We use `0` here because an access token is actually created in the process of making this request.
    assert_difference("Platform::AccessToken.count", 0) do
      delete "/api/v1/platform/access_tokens/#{@access_token.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/platform/access_tokens/#{@another_access_token.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
