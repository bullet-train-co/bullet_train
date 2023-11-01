FactoryBot.define do
  factory :webhooks_outgoing_endpoint, class: "Webhooks::Outgoing::Endpoint" do
    association :team, factory: :team
    name { "Example Endpoint" }
    url { "https://example.com/some-endpoint-url" }

    factory :webhooks_outgoing_endpoint_example do
      id { 42 }
      team_id { 42 }
      name { "Example Endpoint" }
      created_at { DateTime.new(2023, 1, 1) }
      updated_at { DateTime.new(2023, 1, 2) }
    end
  end
end
