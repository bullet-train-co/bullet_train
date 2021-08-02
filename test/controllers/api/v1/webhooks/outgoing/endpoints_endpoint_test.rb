require "test_helper"
require "controllers/api/test"

class Api::V1::Webhooks::Outgoing::EndpointsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @endpoint = create(:webhooks_outgoing_endpoint, team: @team)
    @other_endpoints = create_list(:webhooks_outgoing_endpoint, 3)
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(endpoint_data)
    # Fetch the endpoint in question and prepare to compare it's attributes.
    endpoint = Webhooks::Outgoing::Endpoint.find(endpoint_data["id"])

    assert_equal endpoint_data["name"], endpoint.name
    assert_equal endpoint_data["url"], endpoint.url
    assert_equal endpoint_data["event_type_ids"], endpoint.event_type_ids
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal endpoint_data["team_id"], endpoint.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/webhooks/outgoing/endpoints", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    endpoint_ids_returned = response.parsed_body.dig("data").map { |endpoint| endpoint.dig("attributes", "id") }
    assert_includes(endpoint_ids_returned, @endpoint.id)

    # But not returning other people's resources.
    assert_not_includes(endpoint_ids_returned, @other_endpoints[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/webhooks/outgoing/endpoints/#{@endpoint.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/webhooks/outgoing/endpoints/#{@endpoint.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    endpoint_data = Api::V1::Webhooks::Outgoing::EndpointSerializer.new(build(:webhooks_outgoing_endpoint, team: nil)).serializable_hash.dig(:data, :attributes)
    endpoint_data.except!(:id, :team_id, :created_at, :updated_at)

    post "/api/v1/teams/#{@team.id}/webhooks/outgoing/endpoints",
      params: endpoint_data.merge({access_token: access_token})

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/webhooks/outgoing/endpoints",
      params: endpoint_data.merge({access_token: another_access_token})
    # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
    assert_response :forbidden
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/webhooks/outgoing/endpoints/#{@endpoint.id}", params: {
      access_token: access_token,
      name: "Alternative String Value",
      url: "Alternative String Value",
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # But we have to manually assert the value was properly updated.
    @endpoint.reload
    assert_equal @endpoint.name, "Alternative String Value"
    assert_equal @endpoint.url, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/webhooks/outgoing/endpoints/#{@endpoint.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Webhooks::Outgoing::Endpoint.count", -1) do
      delete "/api/v1/webhooks/outgoing/endpoints/#{@endpoint.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/webhooks/outgoing/endpoints/#{@endpoint.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end
end
