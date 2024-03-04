FactoryBot.define do
  factory :client do
    association :team
    name { "MyString" }
  end
end
