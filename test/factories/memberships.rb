FactoryBot.define do
  factory :membership do
    association :user
    association :team
  end
end
