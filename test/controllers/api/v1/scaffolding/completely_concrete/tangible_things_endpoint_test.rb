require "test_helper"
require "controllers/api/test"

class Api::V1::Scaffolding::CompletelyConcrete::TangibleThingsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

  unless scaffolding_things_disabled? # 🚅 skip when scaffolding.
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      # 🚅 skip this section when scaffolding.
      @absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
      @tangible_thing = create(:scaffolding_completely_concrete_tangible_thing, absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept)
      # 🚅 stop any skipping we're doing now.
      # 🚅 super scaffolding will insert factory setup in place of this line.
      @other_tangible_things = create_list(:scaffolding_completely_concrete_tangible_thing, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(tangible_thing_data)
      # Fetch the tangible_thing in question and prepare to compare it's attributes.
      tangible_thing = Scaffolding::CompletelyConcrete::TangibleThing.find(tangible_thing_data["id"])

      # 🚅 skip this section when scaffolding.
      assert_equal tangible_thing_data["text_field_value"], tangible_thing.text_field_value
      assert_equal tangible_thing_data["button_value"], tangible_thing.button_value
      assert_equal tangible_thing_data["cloudinary_image_value"], tangible_thing.cloudinary_image_value
      assert_equal Date.parse(tangible_thing_data["date_field_value"]), tangible_thing.date_field_value
      assert_equal DateTime.parse(tangible_thing_data["date_and_time_field_value"]), tangible_thing.date_and_time_field_value
      assert_equal tangible_thing_data["email_field_value"], tangible_thing.email_field_value
      assert_equal tangible_thing_data["password_field_value"], tangible_thing.password_field_value
      assert_equal tangible_thing_data["phone_field_value"], tangible_thing.phone_field_value

      if tangible_thing.option_value.nil?
        assert_nil tangible_thing_data["option_value"]
      else
        assert_equal tangible_thing_data["option_value"], tangible_thing.option_value
      end

      assert_equal tangible_thing_data["super_select_value"], tangible_thing.super_select_value
      # assert_equal tangible_thing_data["text_area_value"], tangible_thing.text_area_value
      # 🚅 stop any skipping we're doing now.
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal tangible_thing_data["absolutely_abstract_creative_concept_id"], tangible_thing.absolutely_abstract_creative_concept_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      tangible_thing_ids_returned = response.parsed_body.dig("data").map { |tangible_thing| tangible_thing.dig("attributes", "id") }
      assert_includes(tangible_thing_ids_returned, @tangible_thing.id)

      # But not returning other people's resources.
      assert_not_includes(tangible_thing_ids_returned, @other_tangible_things[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      tangible_thing_data = Api::V1::Scaffolding::CompletelyConcrete::TangibleThingSerializer.new(build(:scaffolding_completely_concrete_tangible_thing, absolutely_abstract_creative_concept: nil)).serializable_hash.dig(:data, :attributes)
      tangible_thing_data.except!(:id, :absolutely_abstract_creative_concept_id, :created_at, :updated_at)

      post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things",
        params: tangible_thing_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/tangible_things",
        params: tangible_thing_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}", params: {
        access_token: access_token,
        # 🚅 skip this section when scaffolding.
        text_field_value: "Alternative String Value",
        button_value: @tangible_thing.button_value,
        cloudinary_image_value: @tangible_thing.cloudinary_image_value,
        date_field_value: @tangible_thing.date_field_value,
        email_field_value: "another.email@test.com",
        password_field_value: "Alternative String Value",
        phone_field_value: "+19053871234",
        super_select_value: @tangible_thing.super_select_value,
        text_area_value: "Alternative String Value",
        # 🚅 stop any skipping we're doing now.
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @tangible_thing.reload
      # 🚅 skip this section when scaffolding.
      assert_equal @tangible_thing.text_field_value, "Alternative String Value"
      assert_equal @tangible_thing.email_field_value, "another.email@test.com"
      assert_equal @tangible_thing.password_field_value, "Alternative String Value"
      assert_equal @tangible_thing.phone_field_value, "+19053871234"
      assert_equal @tangible_thing.text_area_value, "Alternative String Value"
      # 🚅 stop any skipping we're doing now.
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Scaffolding::CompletelyConcrete::TangibleThing.count", -1) do
        delete "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/scaffolding/completely_concrete/tangible_things/#{@tangible_thing.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
  end # 🚅 skip when scaffolding.
end
