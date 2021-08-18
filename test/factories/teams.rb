FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Generic Team #{n}" }
    sequence(:slug) { |n| "team_#{n}" }
    time_zone { nil }
    locale { nil }
  end
end
