FactoryBot.define do
  factory :page do
    association :team
    name { "MyString" }
    path { "MyText" }
  end
end
