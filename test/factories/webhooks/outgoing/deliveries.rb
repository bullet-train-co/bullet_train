FactoryBot.define do
  factory :webhooks_outgoing_delivery, class: "Webhooks::Outgoing::Delivery" do
    association :endpoint, factory: :webhooks_outgoing_endpoint
    association :event, factory: :webhooks_outgoing_event
    delivered_at { "2021-03-16 18:04:09" }
  end
end
