require "test_helper"

class Account::Scaffolding::CompletelyConcrete::TangibleThingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = create(:onboarded_user)
    sign_in @user
    @team = @user.current_team
    # 🚅 skip this section when scaffolding.
    @absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
    @tangible_thing = create(:scaffolding_completely_concrete_tangible_thing, absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept)
    # 🚅 stop any skipping we're doing now.
    # 🚅 super scaffolding will insert factory setup in place of this line.

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  def teardown
    super
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  test "should get index" do
    get url_for([:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things])
    assert_response :success
  end

  test "should get new" do
    get url_for([:new, :account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_thing])
    assert_response :success
  end

  test "should create tangible_thing" do
    assert_difference("Scaffolding::CompletelyConcrete::TangibleThing.count") do
      post url_for([:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things]), params: {
        scaffolding_completely_concrete_tangible_thing: {
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
          action_text_value: @tangible_thing.action_text_value,
          # 🚅 stop any skipping we're doing now.
          # 🚅 super scaffolding will insert new fields above this line.
        }
      }
    end

    assert_redirected_to url_for([:account, Scaffolding::CompletelyConcrete::TangibleThing.last])
  end

  test "should show tangible_thing" do
    get url_for([:account, @tangible_thing])
    assert_response :success
  end

  test "should get edit" do
    get url_for([:edit, :account, @tangible_thing])
    assert_response :success
  end

  test "should update tangible_thing" do
    patch url_for([:account, @tangible_thing]), params: {
      scaffolding_completely_concrete_tangible_thing: {
        # 🚅 skip this section when scaffolding.
        text_field_value: @tangible_thing.text_field_value,
        button_value: @tangible_thing.button_value,
        cloudinary_image_value: @tangible_thing.cloudinary_image_value,
        date_field_value: @tangible_thing.date_field_value,
        email_field_value: @tangible_thing.email_field_value,
        password_field_value: @tangible_thing.password_field_value,
        phone_field_value: @tangible_thing.phone_field_value,
        super_select_value: @tangible_thing.super_select_value,
        text_area_value: @tangible_thing.text_area_value,
        action_text_value: @tangible_thing.action_text_value,
        # 🚅 stop any skipping we're doing now.
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }
    assert_redirected_to url_for([:account, @tangible_thing])
  end

  test "should destroy tangible_thing" do
    assert_difference("Scaffolding::CompletelyConcrete::TangibleThing.count", -1) do
      delete url_for([:account, @tangible_thing])
    end

    assert_redirected_to url_for([:account, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things])
  end
end
