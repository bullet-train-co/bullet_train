FactoryBot.define do
  factory :department do
    association :team
    name { "MyString" }
  end
end
