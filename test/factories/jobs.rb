FactoryBot.define do
  factory :job do
    association :department
    name { "MyString" }
    description { "MyText" }
  end
end
