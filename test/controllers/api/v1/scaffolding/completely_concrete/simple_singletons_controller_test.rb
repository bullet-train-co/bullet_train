require "controllers/api/v1/test"

class Api::V1::Scaffolding::CompletelyConcrete::SimpleSingletonsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
@simple_singleton = build(:scaffolding_completely_concrete_simple_singleton, absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept)
      @other_simple_singletons = create_list(:scaffolding_completely_concrete_simple_singleton, 3)

      @another_simple_singleton = create(:scaffolding_completely_concrete_simple_singleton, absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @simple_singleton.save
      @another_simple_singleton.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(simple_singleton_data)
      # Fetch the simple_singleton in question and prepare to compare it's attributes.
      simple_singleton = Scaffolding::CompletelyConcrete::SimpleSingleton.find(simple_singleton_data["id"])

      assert_equal_or_nil simple_singleton_data['name'], simple_singleton.name
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal simple_singleton_data["absolutely_abstract_creative_concept_id"], simple_singleton.absolutely_abstract_creative_concept_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/simple_singletons", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      simple_singleton_ids_returned = response.parsed_body.map { |simple_singleton| simple_singleton["id"] }
      assert_includes(simple_singleton_ids_returned, @simple_singleton.id)

      # But not returning other people's resources.
      assert_not_includes(simple_singleton_ids_returned, @other_simple_singletons[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/scaffolding/completely_concrete/simple_singletons/#{@simple_singleton.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/scaffolding/completely_concrete/simple_singletons/#{@simple_singleton.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      simple_singleton_data = JSON.parse(build(:scaffolding_completely_concrete_simple_singleton, absolutely_abstract_creative_concept: nil).to_api_json)
      simple_singleton_data.except!("id", "absolutely_abstract_creative_concept_id", "created_at", "updated_at")
      params[:scaffolding_completely_concrete_simple_singleton] = simple_singleton_data

      post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/simple_singletons", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/scaffolding/absolutely_abstract/creative_concepts/#{@absolutely_abstract_creative_concept.id}/completely_concrete/simple_singletons",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/scaffolding/completely_concrete/simple_singletons/#{@simple_singleton.id}", params: {
        access_token: access_token,
        scaffolding_completely_concrete_simple_singleton: {
          name: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @simple_singleton.reload
      assert_equal @simple_singleton.name, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/scaffolding/completely_concrete/simple_singletons/#{@simple_singleton.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Scaffolding::CompletelyConcrete::SimpleSingleton.count", -1) do
        delete "/api/v1/scaffolding/completely_concrete/simple_singletons/#{@simple_singleton.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/scaffolding/completely_concrete/simple_singletons/#{@another_simple_singleton.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
