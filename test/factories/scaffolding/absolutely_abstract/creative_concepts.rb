FactoryBot.define do
  factory :scaffolding_absolutely_abstract_creative_concept, aliases: [:creative_concept], class: "Scaffolding::AbsolutelyAbstract::CreativeConcept" do
    team
    name { "MyString" }
    description { "MyText" }
  end
end
