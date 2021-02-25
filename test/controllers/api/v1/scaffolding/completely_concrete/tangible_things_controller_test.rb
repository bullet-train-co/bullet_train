# frozen_string_literal: true

require 'test_helper'

class Api::V1::Scaffolding::CompletelyConcrete::TangibleThingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  unless scaffolding_things_disabled? # 🚅 skip when scaffolding.
  def setup
    super
    @user = create(:onboarded_user)
    @another_user = create(:onboarded_user)
    @api_key = create(:api_key, user: @user)
    @another_api_key = create(:api_key, user: @another_user)
    @team = @user.current_team
    # 🚅 skip this section when scaffolding.
    @absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
    @tangible_thing = create(:scaffolding_completely_concrete_tangible_thing, absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept)
    # 🚅 stop any skipping we're doing now.
    # 🚅 super scaffolding will insert factory setup in place of this line.
    @other_tangible_things = create_list(:scaffolding_completely_concrete_tangible_thing, 3)
  end

  def auth_header
    { 'authorization': "Basic #{Base64.encode64("#{@api_key.token}:#{@api_key.secret}")}" }
  end

  def another_auth_header
    { 'authorization': "Basic #{Base64.encode64("#{@another_api_key.token}:#{@another_api_key.secret}")}" }
  end

  # this assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(tangible_thing_data)

    # fetch the tangible_thing in question and prepare to compare it's attributes.
    tangible_thing = Scaffolding::CompletelyConcrete::TangibleThing.find(tangible_thing_data['id'])
    tangible_thing_attributes = tangible_thing_data['attributes']

    # ensure the type is properly set.
    assert_equal(tangible_thing_data['type'], 'scaffolding-completely-concrete-tangible-things')

    # 🚅 skip this section when scaffolding.
    assert_equal tangible_thing_attributes['text-field-value'], tangible_thing.text_field_value
    assert_equal tangible_thing_attributes['button-value'], tangible_thing.button_value
    assert_equal tangible_thing_attributes['cloudinary-image-value'], tangible_thing.cloudinary_image_value
    # assert_equal tangible_thing_attributes['date-field-value'], tangible_thing.date_field_value
    assert_equal tangible_thing_attributes['email-field-value'], tangible_thing.email_field_value
    assert_equal tangible_thing_attributes['password-field-value'], tangible_thing.password_field_value
    assert_equal tangible_thing_attributes['phone-field-value'], tangible_thing.phone_field_value
    assert_equal tangible_thing_attributes['super-select-value'], tangible_thing.super_select_value
    assert_equal tangible_thing_attributes['text-area-value'], tangible_thing.text_area_value
    # remove the HTML tags below
    assert_equal tangible_thing_attributes['action-text-value']["body"].gsub(/<\/?[^>]+>/, '').strip, tangible_thing.action_text_value.to_plain_text.strip
    assert_equal tangible_thing_attributes['ckeditor-value'], tangible_thing.ckeditor_value
    # 🚅 stop any skipping we're doing now.
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal tangible_thing_attributes['absolutely-abstract-creative-concept-id'], tangible_thing.absolutely_abstract_creative_concept_id

  end

  test '#index' do

    # fetch from the api and ensure nothing is seriously broken.
    get url_for([:api, :v1, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things]), headers: auth_header
    assert_response :success

    # make sure it's returning our tangible_things.
    tangible_thing_ids_returned = response.parsed_body['data'].map { |tangible_thing| tangible_thing['id'] }
    assert_includes(tangible_thing_ids_returned, @tangible_thing.id.to_s)

    # but not returning other people's tangible_things.
    assert_not_includes(tangible_thing_ids_returned, @other_tangible_things[0].id.to_s)

    # and that the object structure is correct.
    assert_proper_object_serialization(response.parsed_body['data'].first)

  end

  test '#show' do

    # fetch from the api and ensure nothing is seriously broken.
    get url_for([:api, :v1, @tangible_thing]), headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization(response.parsed_body['data'])

    # also ensure we can't access the same data as another user.
    assert_raises CanCan::AccessDenied do
      get url_for([:api, :v1, @tangible_thing]), headers: another_auth_header
    end

  end

  test '#create' do

    # use the serializer to generate a payload, but stripe some attributes out.
    tangible_thing_data = Api::V1::Scaffolding::CompletelyConcrete::TangibleThingSerializer.new(build(:scaffolding_completely_concrete_tangible_thing, absolutely_abstract_creative_concept: nil)).attributes
    tangible_thing_data.except!(:id, :absolutely_abstract_creative_concept_id, :created_at, :updated_at)

    post url_for([:api, :v1, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things]), params: { scaffolding_completely_concrete_tangible_thing: tangible_thing_data }, headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body['data']

    # also ensure we can't do the same tangible_thing as another user.
    assert_raises CanCan::AccessDenied do
      post url_for([:api, :v1, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things]), params: { scaffolding_completely_concrete_tangible_thing: tangible_thing_data }, headers: another_auth_header
    end

  end

  test '#update' do

    # post an attribute update to the api and ensure nothing is seriously broken.
    put url_for([:api, :v1, @tangible_thing]), params: {
      scaffolding_completely_concrete_tangible_thing: {
        # 🚅 skip this section when scaffolding.
        text_field_value: 'Alternative String Value',
        button_value: @tangible_thing.button_value,
        cloudinary_image_value: @tangible_thing.cloudinary_image_value,
        date_field_value: @tangible_thing.date_field_value,
        email_field_value: 'another.email@test.com',
        password_field_value: 'Alternative String Value',
        phone_field_value: '+19053871234',
        super_select_value: @tangible_thing.super_select_value,
        text_area_value: 'Alternative String Value',
        action_text_value: @tangible_thing.action_text_value,
        ckeditor_value: @tangible_thing.ckeditor_value,
        # 🚅 stop any skipping we're doing now.
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }, headers: auth_header
    assert_response :success

    # ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body['data']

    # but we have to manually assert the value was properly updated.
    @tangible_thing.reload
    # 🚅 skip this section when scaffolding.
    assert_equal @tangible_thing.text_field_value, 'Alternative String Value'
    assert_equal @tangible_thing.email_field_value, 'another.email@test.com'
    assert_equal @tangible_thing.password_field_value, 'Alternative String Value'
    assert_equal @tangible_thing.phone_field_value, '+19053871234'
    assert_equal @tangible_thing.text_area_value, 'Alternative String Value'
    # 🚅 stop any skipping we're doing now.
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # also ensure we can't do the same tangible_thing as another user.
    assert_raises CanCan::AccessDenied do
      put url_for([:api, :v1, @tangible_thing]), params: {
        scaffolding_completely_concrete_tangible_thing: {}
      }, headers: another_auth_header
    end

  end

  test '#destroy' do

    # delete a tangible_thing and ensure the tangible_thing actually went away.
    assert_difference('Scaffolding::CompletelyConcrete::TangibleThing.count', -1) do
      delete url_for([:api, :v1, @tangible_thing]), headers: auth_header
      assert_response :success
    end

    # also ensure we can't do the same tangible_thing as another user.
    assert_raises ActiveRecord::RecordNotFound do
      delete url_for([:api, :v1, @tangible_thing]), headers: another_auth_header
    end

  end
  end # 🚅 skip when scaffolding.
end
