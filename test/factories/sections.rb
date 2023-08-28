FactoryBot.define do
  factory :section do
    association :page
    title { "MyString" }
  end
end
