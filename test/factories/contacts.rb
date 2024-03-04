FactoryBot.define do
  factory :contact do
    association :client
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
    notes { "MyText" }
  end
end
