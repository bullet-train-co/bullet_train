FactoryBot.define do
  factory :webhooks_outgoing_endpoint, class: "Webhooks::Outgoing::Endpoint" do
    association :team, factory: :team
    name { "Example Endpoint" }
    url { "https://example.com/some-endpoint-url" }

    factory :webhooks_outgoing_endpoint_example do
      name { "Example Endpoint" }
    end
  end
end
