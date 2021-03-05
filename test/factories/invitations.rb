FactoryBot.define do
  factory :invitation do
    uuid { "1111" }
    association :team
    association :from_membership, factory: :membership
    sequence(:email) { |n| "example#{n}@email.com" }
  end
end
