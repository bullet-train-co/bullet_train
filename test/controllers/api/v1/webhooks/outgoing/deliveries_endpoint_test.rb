require "test_helper"
require "controllers/api/test"

class Api::V1::Webhooks::Outgoing::DeliveriesEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @endpoint = create(:webhooks_outgoing_endpoint, team: @team)
    @delivery = create(:webhooks_outgoing_delivery, endpoint: @endpoint)
    @other_deliveries = create_list(:webhooks_outgoing_delivery, 3)
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(delivery_data)
    # Fetch the delivery in question and prepare to compare it's attributes.
    delivery = Webhooks::Outgoing::Delivery.find(delivery_data["id"])

    assert_equal delivery_data["event_id"], delivery.event_id
    assert_nil delivery_data["endpoint_url"]
    assert_equal DateTime.parse(delivery_data["delivered_at"]), delivery.delivered_at
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal delivery_data["endpoint_id"], delivery.endpoint_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/webhooks/outgoing/endpoints/#{@endpoint.id}/deliveries", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    delivery_ids_returned = response.parsed_body.dig("data").map { |delivery| delivery.dig("attributes", "id") }
    assert_includes(delivery_ids_returned, @delivery.id)

    # But not returning other people's resources.
    assert_not_includes(delivery_ids_returned, @other_deliveries[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/webhooks/outgoing/deliveries/#{@delivery.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/webhooks/outgoing/deliveries/#{@delivery.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # We shouldn't be able to create these records.
    delivery_data = Api::V1::Webhooks::Outgoing::DeliverySerializer.new(build(:webhooks_outgoing_delivery, endpoint: nil)).serializable_hash.dig(:data, :attributes)
    delivery_data.except!(:id, :endpoint_id, :created_at, :updated_at)

    post "/api/v1/webhooks/outgoing/endpoints/#{@endpoint.id}/deliveries",
      params: delivery_data.merge({access_token: access_token})

    assert_response :not_found
  end

  test "update" do
    # We shouldn't be able to update these records.
    put "/api/v1/webhooks/outgoing/deliveries/#{@delivery.id}", params: {
      access_token: access_token,
      endpoint_url: "Alternative String Value",
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :not_found
  end

  test "destroy" do
    # We shouldn't be able to destroy these records.
    delete "/api/v1/webhooks/outgoing/deliveries/#{@delivery.id}", params: {access_token: access_token}
    assert_response :not_found
  end
end
