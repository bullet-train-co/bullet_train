FactoryBot.define do
  factory :invitation do
    uuid { "1111" }
    association :team
    association :from_membership, factory: :membership
    sequence(:email) { |n| "example#{n}@email.com" }

    factory :invitation_example do
      team { FactoryBot.example(:team) }
    end
  end
end
