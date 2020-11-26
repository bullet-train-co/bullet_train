# frozen_string_literal: true

require 'test_helper'

class Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  unless scaffolding_things_disabled? # 🚅 skip when scaffolding.
  def setup
    super
    @user = create(:onboarded_user)
    @another_user = create(:onboarded_user)
    @api_key = create(:api_key, user: @user)
    @another_api_key = create(:api_key, user: @another_user)
    @team = @user.current_team
    @creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
    @other_creative_concepts = create_list(:scaffolding_absolutely_abstract_creative_concept, 3)
  end

  def auth_header
    { 'authorization': "Basic #{Base64.encode64("#{@api_key.token}:#{@api_key.secret}")}" }
  end

  def another_auth_header
    { 'authorization': "Basic #{Base64.encode64("#{@another_api_key.token}:#{@another_api_key.secret}")}" }
  end

  # this assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(creative_concept_data)

    # fetch the creative_concept in question and prepare to compare it's attributes.
    creative_concept = Scaffolding::AbsolutelyAbstract::CreativeConcept.find(creative_concept_data['id'])
    creative_concept_attributes = creative_concept_data['attributes']

    # ensure the type is properly set.
    assert_equal(creative_concept_data['type'], 'scaffolding-absolutely-abstract-creative-concepts')

    # ⚠️ super scaffolding will insert attribute checks here based on the following template.
    # 👉 assert_equal creative_concept_attributes['some-attribute'], creative_concept.some_attribute
    assert_equal creative_concept_attributes['name'], creative_concept.name
    assert_equal creative_concept_attributes['team-id'], creative_concept.team_id

  end

  test '#index' do

    # fetch from the api and ensure nocreative_concept is seriously broken.
    get api_v1_team_scaffolding_absolutely_abstract_creative_concepts_path(@team), headers: auth_header
    assert_response :success

    # make sure it's returning our creative_concepts.
    creative_concept_ids_returned = response.parsed_body['data'].map { |creative_concept| creative_concept['id'] }
    assert_includes(creative_concept_ids_returned, @creative_concept.id.to_s)

    # but not returning other people's creative_concepts.
    assert_not_includes(creative_concept_ids_returned, @other_creative_concepts[0].id.to_s)

    # and that the object structure is correct.
    assert_proper_object_serialization(response.parsed_body['data'].first)

  end

  test '#show' do

    # fetch from the api and ensure nocreative_concept is seriously broken.
    get api_v1_scaffolding_absolutely_abstract_creative_concept_path(@creative_concept), headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization(response.parsed_body['data'])

    # also ensure we can't access the same data as another user.
    assert_raises CanCan::AccessDenied do
      get api_v1_scaffolding_absolutely_abstract_creative_concept_path(@creative_concept), headers: another_auth_header
    end

  end

  test '#create' do

    # use the serializer to generate a payload, but stripe some attributes out.
    creative_concept_data = Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptSerializer.new(build(:scaffolding_absolutely_abstract_creative_concept, team: nil)).attributes
    creative_concept_data.except!(:id, :team_id, :created_at, :updated_at)

    post api_v1_team_scaffolding_absolutely_abstract_creative_concepts_path(@team), params: { scaffolding_absolutely_abstract_creative_concept: creative_concept_data }, headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body['data']

    # also ensure we can't do the same creative_concept as another user.
    assert_raises CanCan::AccessDenied do
      post api_v1_team_scaffolding_absolutely_abstract_creative_concepts_path(@team), params: { scaffolding_absolutely_abstract_creative_concept: creative_concept_data }, headers: another_auth_header
    end

  end

  test '#update' do

    # post an attribute update to the api and ensure nocreative_concept is seriously broken.
    put api_v1_scaffolding_absolutely_abstract_creative_concept_path(@creative_concept), params: { scaffolding_absolutely_abstract_creative_concept: { name: 'Some Other Scaffolding CreativeConcept' } }, headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body['data']

    # but we have to manually assert the value was properly updated.
    assert_equal @creative_concept.reload.name, 'Some Other Scaffolding CreativeConcept'

    # also ensure we can't do the same creative_concept as another user.
    assert_raises CanCan::AccessDenied do
      put api_v1_scaffolding_absolutely_abstract_creative_concept_path(@creative_concept), params: { scaffolding_absolutely_abstract_creative_concept: { name: 'Some Other Scaffolding CreativeConcept' } }, headers: another_auth_header
    end

  end

  test '#destroy' do

    # delete a creative_concept and ensure the creative_concept actually went away.
    assert_difference('Scaffolding::AbsolutelyAbstract::CreativeConcept.count', -1) do
      delete api_v1_scaffolding_absolutely_abstract_creative_concept_path(@creative_concept), headers: auth_header
      assert_response :success
    end

    # also ensure we can't do the same creative_concept as another user.
    assert_raises ActiveRecord::RecordNotFound do
      delete api_v1_scaffolding_absolutely_abstract_creative_concept_path(@creative_concept), headers: another_auth_header
    end

  end
  end # 🚅 skip when scaffolding.
end
