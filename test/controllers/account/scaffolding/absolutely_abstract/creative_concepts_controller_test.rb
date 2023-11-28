require "test_helper"

class Account::Scaffolding::AbsolutelyAbstract::CreativeConceptsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    super
    @user = create(:onboarded_user)
    sign_in @user
    @team = @user.current_team
    @creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)

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
    skip("Controller uses uses temporary redirect")
    get account_team_scaffolding_absolutely_abstract_creative_concepts_url(@team)
    assert_response :success
  end

  test "should get new" do
    get new_account_team_scaffolding_absolutely_abstract_creative_concept_url(@team)
    assert_response :success
  end

  test "should create creative_concept" do
    assert_difference("Scaffolding::AbsolutelyAbstract::CreativeConcept.count") do
      post account_team_scaffolding_absolutely_abstract_creative_concepts_url(@team), params: {scaffolding_absolutely_abstract_creative_concept: {name: @creative_concept.name}}
    end

    assert_redirected_to account_scaffolding_absolutely_abstract_creative_concept_path(Scaffolding::AbsolutelyAbstract::CreativeConcept.last)
  end

  test "should show creative_concept" do
    get account_scaffolding_absolutely_abstract_creative_concept_url(@creative_concept)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_scaffolding_absolutely_abstract_creative_concept_url(@creative_concept)
    assert_response :success
  end

  test "should update creative_concept" do
    patch account_scaffolding_absolutely_abstract_creative_concept_url(@creative_concept), params: {scaffolding_absolutely_abstract_creative_concept: {name: @creative_concept.name}}
    assert_redirected_to account_scaffolding_absolutely_abstract_creative_concept_url(@creative_concept)
  end

  test "should destroy creative_concept" do
    assert_difference("Scaffolding::AbsolutelyAbstract::CreativeConcept.count", -1) do
      delete account_scaffolding_absolutely_abstract_creative_concept_url(@creative_concept)
    end

    assert_redirected_to account_team_scaffolding_absolutely_abstract_creative_concepts_url(@team)
  end
end
