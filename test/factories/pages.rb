FactoryBot.define do
  factory :page do
    association :site
    name { "MyString" }
  end
end
