FactoryBot.define do
  factory :role do
    sequence(:display_order) { |n| n }

    key { "MyString" }
  end
end
