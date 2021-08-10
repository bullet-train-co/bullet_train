require "test_helper"

class InvitationTest < ActiveSupport::TestCase
  def setup
    @user = create(:onboarded_user)
    @membership = Membership.new(team: @user.current_team)
    @invitation = Invitation.create(team: @user.current_team, email: "test@user.com", from_membership: @user.memberships.first, membership: @membership)
  end

  test "must set uuid" do
    assert @invitation.uuid.present?
  end

  test "accept_for must set team" do
    @invitation.accept_for(@user)
    assert_equal @user.current_team, @invitation.team
  end

  test "accept_for must destroy invitation" do
    @invitation.accept_for(@user)
    assert @invitation.destroyed?
  end

  test "must be valid" do
    assert @invitation.valid?
  end
end
