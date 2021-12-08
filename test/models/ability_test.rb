require "test_helper"

module AbilityTest
  class TeamMemberScenarios < ActiveSupport::TestCase
    def setup
      @user = FactoryBot.create :onboarded_user
      @another_user = FactoryBot.create :onboarded_user
      @membership = FactoryBot.create :membership, user: @user, team: @user.current_team
      @team = @membership.team
      @user_ability = Ability.new(@user)
    end

    test "can manage their account" do
      assert @user_ability.can?(:manage, @user)
    end

    test "can't manage foreign account" do
      assert @user_ability.cannot?(:manage, @another_user)
    end

    test "can manage team" do
      assert @user_ability.can?(:manage, @user, Team.new)
    end

    test "can destroy their membership" do
      skip("app/models/ability.rb:22")
      assert @user_ability.cannot?(:destroy, @user, Membership.new(user: @user))
    end
  end

  class NonTeamMemberScenarios < ActiveSupport::TestCase
    def setup
      @user = FactoryBot.create :user
      @another_user = FactoryBot.create :user
      @team = FactoryBot.create :team
      @user_ability = Ability.new(@user)
    end

    test "can manage their account" do
      assert @user_ability.can?(:manage, @user)
    end

    test "can't manage foreign account" do
      assert @user_ability.cannot?(:manage, @another_user)
    end

    test "can't manage team" do
      assert @user_ability.cannot?(:manage, @another_user, @team)
    end

    test "can't manage membership" do
      assert @user_ability.cannot?(:manage, @another_user, Membership.new)
    end
  end

  class TeamAdminScenarios < ActiveSupport::TestCase
    def setup
      @admin = FactoryBot.create :onboarded_user
      @another_user = FactoryBot.create :onboarded_user
      @membership = FactoryBot.create :membership, user: @admin, team: @admin.current_team, role_ids: [Role.admin.id]
      @admin_ability = Ability.new(@admin)
    end

    test "can manage team" do
      assert @admin_ability.can?(:manage, @membership.team)
    end

    test "can manage membership" do
      assert @admin_ability.can?(:manage, Membership.new(team: @admin.current_team))
    end
  end
end
