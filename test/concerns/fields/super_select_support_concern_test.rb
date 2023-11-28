require "test_helper"

class Fields::SuperSelectSupportConcernTest < ActiveSupport::TestCase
  class FakeController < Account::ApplicationController
    include Fields::SuperSelectSupport
  end

  setup do
    @controller = FakeController.new
    @user = FactoryBot.create :onboarded_user
    @team = @user.current_team

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  teardown do
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  test "should not create new model for authorized singular id" do
    creative_concept = FactoryBot.create :creative_concept, team: @team
    strong_params = {id: creative_concept.id.to_s}

    strong_params[:id] = @controller.ensure_backing_models_on(@team.scaffolding_absolutely_abstract_creative_concepts, id: strong_params[:id]) do |scope, id|
      scope.find_or_create_by(name: id)
    end

    assert_equal strong_params[:id], creative_concept.id.to_s
  end

  test "should create new model for unauthorized singular numerical id" do
    @other_user = FactoryBot.create :onboarded_user
    @other_team = @other_user.current_team
    unauthorized_creative_concept = FactoryBot.create :creative_concept, team: @other_team
    strong_params = {id: unauthorized_creative_concept.id.to_s}

    strong_params[:id] = @controller.ensure_backing_models_on(@team.scaffolding_absolutely_abstract_creative_concepts, id: strong_params[:id]) do |scope, id|
      scope.find_or_create_by(name: id)
    end

    assert_not_equal strong_params[:id], unauthorized_creative_concept.id.to_s
  end

  test "should create new model for unauthorized singular new_text as id" do
    creative_concept = nil
    strong_params = {id: "creative concept one"}

    strong_params[:id] = @controller.ensure_backing_models_on(@team.scaffolding_absolutely_abstract_creative_concepts, id: strong_params[:id]) do |scope, id|
      creative_concept = scope.find_or_create_by(name: id)
      creative_concept
    end

    assert_equal strong_params[:id], creative_concept.id.to_s
    assert_equal @team.scaffolding_absolutely_abstract_creative_concepts.find(strong_params[:id])&.name, "creative concept one"
  end

  test "should handle a list with authorized id and new text string" do
    known_creative_concept = FactoryBot.create :creative_concept, team: @team
    new_creative_concept = nil
    strong_params = {ids: [known_creative_concept.id.to_s, "creative concept one"]}

    strong_params[:ids] = @controller.ensure_backing_models_on(@team.scaffolding_absolutely_abstract_creative_concepts, ids: strong_params[:ids]) do |scope, id|
      new_creative_concept = scope.find_or_create_by(name: id)
      new_creative_concept
    end

    assert strong_params[:ids].include?(known_creative_concept.id.to_s)
    assert strong_params[:ids].include?(new_creative_concept.id.to_s)
    assert_equal @team.scaffolding_absolutely_abstract_creative_concepts.find(new_creative_concept.id)&.name, "creative concept one"
  end
end
