require "test_helper"

class RoleTest < ActiveSupport::TestCase
  class ClassMethodsTest < ActiveSupport::TestCase
    def setup
      @admin_user = FactoryBot.create :onboarded_user
      @another_user = FactoryBot.create :onboarded_user
      @membership = FactoryBot.create :membership, user: @admin_user, team: @admin_user.current_team, role_ids: [Role.admin.id]
      @admin_ability = Ability.new(@admin_user)
      @parent_ids = [2, 3]
    end

    test "Role.admin return the correct role" do
      assert_equal Role.admin, Role.find_by_key("admin")
    end

    test "Role.default returns the default role" do
      assert_equal Role.default, Role.find_by_key("default")
    end

    test "Role.includes(default) should return all other roles" do
      assert_equal Role.all.count - 1, Role.includes(Role.default).count
    end

    test "Role.includes works when given a string" do
      assert_equal Role.includes("editor"), [Role.admin]
    end

    test "Role.include works when given a role" do
      assert_equal Role.includes(Role.find_by_key("editor")), [Role.admin]
    end

    test "Role.assignable should not return the default role" do
      refute_includes Role.assignable, Role.default
    end

    test "Role.assignable should include the admin role" do
      assert_includes Role.assignable, Role.admin
    end
  end

  class InstanceMethodsTest < ActiveSupport::TestCase
    def setup
      @admin_user = FactoryBot.create :onboarded_user
      @another_user = FactoryBot.create :onboarded_user
      @membership = FactoryBot.create :membership, user: @admin_user, team: @admin_user.current_team, role_ids: [Role.admin.id]
      @admin_ability = Ability.new(@admin_user)
      @parent_ids = [2, 3]
    end

    test "default_role#included_by returns the admin role" do
      assert_includes Role.default.included_by, Role.admin
    end

    test "editor_role#included_by returns the admin role" do
      assert_includes Role.find_by_key("editor").included_by, Role.admin
    end

    test "editor_role#included_by does not include the default role" do
      refute_includes Role.find_by_key("editor").included_by, Role.default
    end

    test "admin_role#key_plus_included_by_keys returns only the admin role id" do
      expected_role_ids = [Role.admin.id]
      assert_equal Role.admin.key_plus_included_by_keys, expected_role_ids
    end

    test "default_role#key_plus_included_by_keys returns all role ids" do
      expected_role_ids = Role.all.map(&:id)
      assert_empty expected_role_ids - Role.default.key_plus_included_by_keys
    end

    test "default? returns true for the default role" do
      assert Role.default.default?
    end

    test "default? returns false for non default roles" do
      refute Role.admin.default?
    end

    test "admin? returns true for the admin role" do
      assert Role.admin.admin?
    end

    test "admin? returns false for a non admin role" do
      refute Role.default.admin?
    end

    test "admin_role.included_roles includes the default role" do
      assert_includes Role.admin.included_roles, Role.default
    end

    test "admin_role.included_roles includes the editor role" do
      assert_includes Role.admin.included_roles, Role.find_by_key("editor")
    end

    test "default.manageable_by?(admin_role) returns true" do
      assert Role.default.manageable_by?([Role.admin])
    end

    test "admin_role.manageable_by?(default_role) returns false" do
      refute Role.admin.manageable_by?([Role.default])
    end
  end

  class Role::AbilityGeneratorTest < ActiveSupport::TestCase
    def setup
      @admin_user = FactoryBot.create :onboarded_user
      @another_user = FactoryBot.create :onboarded_user
      @membership = FactoryBot.create :membership, user: @admin_user, team: @admin_user.current_team, role_ids: [Role.admin.id]
      @admin_ability = Ability.new(@admin_user)
      @admin_role = Role.admin
      @ability_generator = Role::AbilityGenerator.new(@admin_role, "Team", @admin_user, :memberships, :team)
    end

    test "The ability generator is valid?" do
      assert @ability_generator.valid?
    end

    test "if the model does not respond to the parent model, it should not be valid" do
      ability_generator = Role::AbilityGenerator.new(@admin_role, "Team", @admin_user, :memberships, :tangible_thing)
      refute ability_generator.valid?
    end

    test "it outputs the correct model" do
      assert_equal @ability_generator.model, Team
    end

    test "it outputs the correct actions when given a string" do
      assert_equal @ability_generator.actions, [:manage]
    end

    test "it outputs the correct actions when given an array" do
      # Find a role with an array for the permissions
      role = nil
      model = nil
      expected_output = nil
      Role.all.each do |role_test|
        role_test.models.each do |model_test, model_data|
          if model_data.is_a?(Array)
            model = model_test
            role = role_test
            expected_output = model_data
            break
          end
        end
      end
      skip "You have no abilities with array conditions defined for a model.  Skipping this test." unless role && model
      ability_generator = Role::AbilityGenerator.new(role, model, @admin_user, :memberships, :team)
      assert_empty expected_output - ability_generator.actions
    end

    test "it outputs the correct condition hash for a child object" do
      ability_generator = Role::AbilityGenerator.new(@admin_role, "Membership", @admin_user, :memberships, :team)
      assert_equal ({team: {id: [@admin_user.teams.first.id]}}), ability_generator.condition
    end

    test "when the parent and the model are the same class, the condition hash checks the id attribute directly" do
      ability_generator = Role::AbilityGenerator.new(@admin_role, "Team", @admin_user, :memberships, :team)
      assert_equal ({id: [@admin_user.teams.first.id]}), ability_generator.condition
    end

    test "possible_parent_associations returns all namespace possibilities" do
      expected_output = %i[creative_concept absolutely_abstract_creative_concept scaffolding_absolutely_abstract_creative_concept]
      ability_generator = Role::AbilityGenerator.new(@admin_role, "Scaffolding::AbsolutelyAbstract::CreativeConcept", @admin_user, :scaffolding_absolutely_abstract_creative_concepts_collaborators, :creative_concept)
      assert_empty expected_output - ability_generator.possible_parent_associations
    end
  end
end
