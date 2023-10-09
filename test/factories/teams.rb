FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Generic Team #{n}" }
    sequence(:slug) { |n| "team_#{n}" }
    time_zone { nil }
    locale { nil }

    factory :team_example do
      id { 42 }
      sequence(:name) { |n| "EXAMPLE Generic Team #{n}" }
      sequence(:slug) { |n| "EXAMPLE team_#{n}" }
      time_zone { ActiveSupport::TimeZone.all.first.name }
      locale { "en" }
      created_at { DateTime.new(2023, 1, 1) }
      updated_at { DateTime.new(2023, 1, 2) }
    end
  end
end
