FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Generic Team #{n}" }
    sequence(:slug) { |n| "team_#{n}" }
    time_zone { nil }
    locale { nil }

    factory :team_example do
      sequence(:name) { |n| "EXAMPLE Generic Team #{n}" }
      sequence(:slug) { |n| "EXAMPLE team_#{n}" }
      time_zone { ActiveSupport::TimeZone.all.first.name }
      locale { "en" }
    end
  end
end
