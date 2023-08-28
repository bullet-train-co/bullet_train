FactoryBot.define do
  factory :site do
    association :team
    name { "MyString" }
    url { "MyText" }
  end
end
