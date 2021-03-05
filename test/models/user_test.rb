require "test_helper"
require "mocha/test_unit"

describe User do
  subject { User.new(email: "bart@bullettrain.co") }

  it { must have_many(:api_keys) }
  it { must have_many(:memberships) }
  it { must have_many(:teams) }
  it { must belong_to(:current_team).without_validating_presence }

  it "call email custom validation" do
    User.any_instance.stubs(:real_emails_only).returns(true)
    assert_equal true, subject.real_emails_only
  end

  describe "#name" do
    it { assert_respond_to(subject, :name) }
    it { assert subject.name == "bart@bullettrain.co" }
  end

  describe "#details_provided?" do
    it "should be true" do
      user = FactoryBot.create :onboarded_user, first_name: "a", last_name: "b"
      membership = FactoryBot.create :membership, user: user
      assert membership.user.details_provided?
    end

    it "should be false" do
      user = FactoryBot.create :user, first_name: "a", last_name: nil
      membership = FactoryBot.create :membership, user: user
      assert membership.user.details_provided? == false
    end
  end
end
