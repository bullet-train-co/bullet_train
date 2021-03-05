require "test_helper"

describe Team do
  subject { Team.new }

  it { must have_many(:invitations) }
  it { must have_many(:memberships) }
  it { must have_many(:users) }

  unless scaffolding_things_disabled?
    it { must have_many(:scaffolding_absolutely_abstract_creative_concepts) }
  end

  it "validates name presence if persisted" do
    subject.save
    must validate_presence_of(:name)
  end
end
