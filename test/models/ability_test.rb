require "test_helper"

describe Ability do

  describe 'team member' do
    let(:user) { FactoryBot.create :onboarded_user }
    let(:another_user) { FactoryBot.create :onboarded_user }
    let(:membership) { FactoryBot.create :membership, user: user, team: user.current_team }
    let(:team) { membership.team }
    let(:user_ability) { Ability.new(user) }

    it 'can manage their account' do
      assert user_ability.can?(:manage, user)
    end

    it 'can\'t manage foreign account' do
      assert user_ability.cannot?(:manage, another_user)
    end

    it 'can manage their api_key' do
      assert user_ability.can?(:manage, ApiKey.new(user: user))
    end

    it 'can\'t manage foreign api_key' do
      assert user_ability.cannot?(:manage, another_user, ApiKey.new)
    end

    it 'can manage team' do
      assert user_ability.can?(:manage, user, Team.new)
    end

    it 'can destroy their membership' do
      skip('app/models/ability.rb:22')
      assert user_ability.cannot?(:destroy, user, Membership.new(user: user))
    end
  end

  describe 'non team member' do
    let(:user) { FactoryBot.create :user }
    let(:another_user) { FactoryBot.create :user }
    let(:team) { FactoryBot.create :team }
    let(:user_ability) { Ability.new(user) }

    it 'can manage their account' do
      assert user_ability.can?(:manage, user)
    end

    it 'can\'t manage foreign account' do
      assert user_ability.cannot?(:manage, another_user)
    end

    it 'can manage their api_key' do
      assert user_ability.can?(:manage, ApiKey.new(user: user))
    end

    it 'can\'t manage foreign api_key' do
      assert user_ability.cannot?(:manage, another_user, ApiKey.new)
    end

    it 'can\'t manage team' do
      assert user_ability.cannot?(:manage, another_user, team)
    end

    it 'can\'t manage membership' do
      assert user_ability.cannot?(:manage, another_user, Membership.new)
    end
  end

  describe 'team admin ability' do
    let(:admin) { FactoryBot.create :onboarded_user }
    let(:another_user) { FactoryBot.create :onboarded_user }
    let(:membership) { FactoryBot.create :membership, user: admin, team: admin.current_team, roles: [Role.admin] }
    let(:admin_ability) { Ability.new(admin) }

    it 'can manage team' do
      membership
      assert admin_ability.can?(:manage, membership.team)
    end

    it 'can manage membership' do
      membership
      assert admin_ability.can?(:manage, Membership.new(team: admin.current_team))
    end
  end
end
