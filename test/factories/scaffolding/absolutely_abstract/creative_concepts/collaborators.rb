FactoryBot.define do
  factory :scaffolding_absolutely_abstract_creative_concepts_collaborator, class: 'Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator' do
    creative_concept { nil }
    membership { |collaborator| create(:membership, team: collaborator.creative_concept.team) }
  end
end
