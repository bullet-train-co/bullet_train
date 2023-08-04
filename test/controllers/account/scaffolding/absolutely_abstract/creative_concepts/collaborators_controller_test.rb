require "test_helper"

class Account::Scaffolding::AbsolutelyAbstract::CreativeConcepts::CollaboratorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  unless scaffolding_things_disabled? # 🚅 skip when scaffolding.
    def setup
      super
      @user = create(:onboarded_user)
      sign_in @user
      @team = @user.current_team
      @creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, team: @team)
      @collaborator = create(:scaffolding_absolutely_abstract_creative_concepts_collaborator, creative_concept: @creative_concept, roles: [Role.admin])
    end

    test "should get index" do
      get url_for([:account, @creative_concept, :collaborators])
      assert_redirected_to url_for([:account, @creative_concept])
    end

    test "should get new" do
      get url_for([:new, :account, @creative_concept, :collaborator])
      assert_response :success
    end

    test "should create collaborator" do
      assert_difference("Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator.count") do
        post url_for([:account, @creative_concept, :collaborators]), params: {
          scaffolding_absolutely_abstract_creative_concepts_collaborator: {
            membership_id: @collaborator.membership_id,
            roles: @collaborator.roles
            # 🚅 super scaffolding will insert new fields above this line.
          }
        }
      end

      assert_redirected_to url_for([:account, @creative_concept, :collaborators])
    end

    test "should show collaborator" do
      get url_for([:account, @collaborator])
      assert_redirected_to url_for([:account, @creative_concept])
    end

    test "should get edit" do
      get url_for([:edit, :account, @collaborator])
      assert_response :success
    end

    test "should update collaborator" do
      patch url_for([:account, @collaborator]), params: {
        scaffolding_absolutely_abstract_creative_concepts_collaborator: {
          membership_id: @collaborator.membership_id,
          roles: @collaborator.roles
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }
      assert_redirected_to url_for([:account, @collaborator])
    end

    test "should destroy collaborator" do
      assert_difference("Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator.count", -1) do
        delete url_for([:account, @collaborator])
      end

      assert_redirected_to url_for([:account, @creative_concept, :collaborators])
    end
  end
end
