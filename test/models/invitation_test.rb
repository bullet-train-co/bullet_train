require 'test_helper'

describe Invitation do

  subject do
    user = create(:onboarded_user)
    membership = Membership.new(team: user.current_team)
    Invitation.create(team: user.current_team, email: 'test@user.com', from_membership: user.memberships.first, membership: membership)
  end

  it { must belong_to(:team) }
  it { must belong_to(:from_membership) }
  it { must validate_presence_of(:email) }

  describe '#before_create' do
    it 'must set uuid' do
      assert subject.uuid.present?
    end
  end

  describe '#accept_for' do
    it 'must set team' do
      user = create :onboarded_user
      assert_difference('user.current_team.id') do
        subject.accept_for(user)
      end
    end

    it 'must destroy invitation' do
      user = create :user
      subject.accept_for(user)
      assert subject.destroyed?
    end
  end

  it 'must be valid' do
    value(subject).must_be :valid?
  end
end
