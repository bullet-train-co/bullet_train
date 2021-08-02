require "test_helper"
require "controllers/api/test"

class Api::V1::Webhooks::Outgoing::DeliveryAttemptsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @endpoint = create(:webhooks_outgoing_endpoint, team: @team)
    @delivery = create(:webhooks_outgoing_delivery, endpoint: @endpoint)
    @delivery_attempt = create(:webhooks_outgoing_delivery_attempt, delivery: @delivery)
    @other_delivery_attempts = create_list(:webhooks_outgoing_delivery_attempt, 3)
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(delivery_attempt_data)
    # Fetch the delivery_attempt in question and prepare to compare it's attributes.
    delivery_attempt = Webhooks::Outgoing::DeliveryAttempt.find(delivery_attempt_data["id"])

    assert_equal delivery_attempt_data["response_code"], delivery_attempt.response_code
    assert_equal delivery_attempt_data["response_body"], delivery_attempt.response_body
    assert_equal delivery_attempt_data["response_message"], delivery_attempt.response_message
    assert_nil delivery_attempt_data["error_message"]
    assert_equal delivery_attempt_data["attempt_number"], delivery_attempt.attempt_number
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal delivery_attempt_data["delivery_id"], delivery_attempt.delivery_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/webhooks/outgoing/deliveries/#{@delivery.id}/delivery_attempts", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    delivery_attempt_ids_returned = response.parsed_body.dig("data").map { |delivery_attempt| delivery_attempt.dig("attributes", "id") }
    assert_includes(delivery_attempt_ids_returned, @delivery_attempt.id)

    # But not returning other people's resources.
    assert_not_includes(delivery_attempt_ids_returned, @other_delivery_attempts[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/webhooks/outgoing/delivery_attempts/#{@delivery_attempt.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

    # Also ensure we can't do that same action as another user.
    get "/api/v1/webhooks/outgoing/delivery_attempts/#{@delivery_attempt.id}", params: {access_token: another_access_token}
    assert_response_specific_not_found
  end

  test "create" do
    # We shouldn't be able to create these records.
    delivery_attempt_data = Api::V1::Webhooks::Outgoing::DeliveryAttemptSerializer.new(build(:webhooks_outgoing_delivery_attempt, delivery: nil)).serializable_hash.dig(:data, :attributes)
    delivery_attempt_data.except!(:id, :delivery_id, :created_at, :updated_at)

    post "/api/v1/webhooks/outgoing/deliveries/#{@delivery.id}/delivery_attempts",
      params: delivery_attempt_data.merge({access_token: access_token})

    assert_response :not_found
  end

  test "update" do
    # We shouldn't be able to update these records.
    put "/api/v1/webhooks/outgoing/delivery_attempts/#{@delivery_attempt.id}", params: {
      access_token: access_token,
      response_code: "Alternative String Value",
      response_body: "Alternative String Value",
      response_message: "Alternative String Value",
      error_message: "Alternative String Value",
      attempt_number: "Alternative String Value",
      # 🚅 super scaffolding will also insert new fields above this line.
    }

    assert_response :not_found
  end

  test "destroy" do
    # We shouldn't be able to destroy these records.
    delete "/api/v1/webhooks/outgoing/delivery_attempts/#{@delivery_attempt.id}", params: {access_token: access_token}
    assert_response :not_found
  end
end
