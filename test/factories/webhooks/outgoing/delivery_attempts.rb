FactoryBot.define do
  factory :webhooks_outgoing_delivery_attempt, class: "Webhooks::Outgoing::DeliveryAttempt" do
    association :delivery, factory: :webhooks_outgoing_delivery
    response_code { 200 }
    response_body { "MyString" }
    response_message { "MyString" }
    error_message { nil }
    attempt_number { 1 }
  end
end
