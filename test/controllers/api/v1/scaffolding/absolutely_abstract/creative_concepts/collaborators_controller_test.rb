# frozen_string_literal: true

require 'test_helper'

class Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConcepts::CollaboratorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = create(:onboarded_user)
    @another_user = create(:onboarded_user)
    @api_key = create(:api_key, user: @user)
    @another_api_key = create(:api_key, user: @another_user)
    @team = @user.current_team
    @creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
@collaborator = create(:scaffolding_absolutely_abstract_creative_concepts_collaborator, creative_concept: @creative_concept)
    @other_collaborators = create_list(:scaffolding_absolutely_abstract_creative_concepts_collaborator, 3)
  end

  def auth_header
    { 'authorization': "Basic #{Base64.encode64("#{@api_key.token}:#{@api_key.secret}")}" }
  end

  def another_auth_header
    { 'authorization': "Basic #{Base64.encode64("#{@another_api_key.token}:#{@another_api_key.secret}")}" }
  end

  # this assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(collaborator_data)

    # fetch the collaborator in question and prepare to compare it's attributes.
    collaborator = Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator.find(collaborator_data['id'])
    collaborator_attributes = collaborator_data['attributes']

    # ensure the type is properly set.
    assert_equal(collaborator_data['type'], 'scaffolding-absolutely-abstract-creative-concepts-collaborators')

    assert_equal collaborator_attributes['membership-id'], collaborator.membership_id
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal collaborator_attributes['scaffolding-absolutely-abstract-creative-concept-id'], collaborator.creative_concept_id

  end

  test '#index' do

    # fetch from the api and ensure nothing is seriously broken.
    get url_for([:api, :v1, @creative_concept, :collaborators]), headers: auth_header
    assert_response :success

    # make sure it's returning our collaborators.
    collaborator_ids_returned = response.parsed_body['data'].map { |collaborator| collaborator['id'] }
    assert_includes(collaborator_ids_returned, @collaborator.id.to_s)

    # but not returning other people's collaborators.
    assert_not_includes(collaborator_ids_returned, @other_collaborators[0].id.to_s)

    # and that the object structure is correct.
    assert_proper_object_serialization(response.parsed_body['data'].first)

  end

  test '#show' do

    # fetch from the api and ensure nothing is seriously broken.
    get url_for([:api, :v1, @collaborator]), headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization(response.parsed_body['data'])

    # also ensure we can't access the same data as another user.
    assert_raises CanCan::AccessDenied do
      get url_for([:api, :v1, @collaborator]), headers: another_auth_header
    end

  end

  test '#create' do

    # use the serializer to generate a payload, but stripe some attributes out.
    collaborator_data = Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConcepts::CollaboratorSerializer.new(build(:scaffolding_absolutely_abstract_creative_concepts_collaborator, creative_concept: nil)).attributes
    collaborator_data.except!(:id, :creative_concept_id, :created_at, :updated_at)

    post url_for([:api, :v1, @creative_concept, :collaborators]), params: { scaffolding_absolutely_abstract_creative_concepts_collaborator: collaborator_data }, headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body['data']

    # also ensure we can't do the same collaborator as another user.
    assert_raises CanCan::AccessDenied do
      post url_for([:api, :v1, @creative_concept, :collaborators]), params: { scaffolding_absolutely_abstract_creative_concepts_collaborator: collaborator_data }, headers: another_auth_header
    end

  end

  test '#update' do

    # post an attribute update to the api and ensure nothing is seriously broken.
    put url_for([:api, :v1, @collaborator]), params: {
      scaffolding_absolutely_abstract_creative_concepts_collaborator: {
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }, headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body['data']

    # but we have to manually assert the value was properly updated.
    @collaborator.reload
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # also ensure we can't do the same collaborator as another user.
    assert_raises CanCan::AccessDenied do
      put url_for([:api, :v1, @collaborator]), params: {
        scaffolding_absolutely_abstract_creative_concepts_collaborator: {}
      }, headers: another_auth_header
    end

  end

  test '#destroy' do

    # delete a collaborator and ensure the collaborator actually went away.
    assert_difference('Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator.count', -1) do
      delete url_for([:api, :v1, @collaborator]), headers: auth_header
      assert_response :success
    end

    # also ensure we can't do the same collaborator as another user.
    assert_raises ActiveRecord::RecordNotFound do
      delete url_for([:api, :v1, @collaborator]), headers: another_auth_header
    end

  end
end
