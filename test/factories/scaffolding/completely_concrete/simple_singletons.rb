FactoryBot.define do
  factory :scaffolding_completely_concrete_simple_singleton, class: 'Scaffolding::CompletelyConcrete::SimpleSingleton' do
    association :absolutely_abstract_creative_concept, factory: :scaffolding_absolutely_abstract_creative_concept
    name { "MyString" }
  end
end
