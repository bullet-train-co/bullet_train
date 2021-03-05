FactoryBot.define do
  factory :scaffolding_absolutely_abstract_creative_concepts_collaborator, class: "Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator" do
    creative_concept { create(:scaffolding_absolutely_abstract_creative_concept) }
    membership { |collaborator| create(:membership, team: collaborator.instance.creative_concept&.team) }
    roles { [] }
  end
end
