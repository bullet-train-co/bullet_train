FactoryBot.define do
  factory :invitation do
    uuid { "1111" }
    association :team
    association :from_membership, factory: :membership
    sequence(:email) { |n| "example#{n}@email.com" }

    factory :invitation_example do
      id { 42 }
      from_membership_id { 42 }
      team { FactoryBot.example(:team) }
      membership { FactoryBot.example(:membership) }
    end
  end
end
