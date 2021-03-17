FactoryBot.define do
  factory :webhooks_incoming_stripe_installation_webhook, class: "Webhooks::Incoming::StripeInstallationWebhook" do
    data { "" }
    processed_at { "2021-03-16 18:04:09" }
    verified_at { "2021-03-16 18:04:09" }
    integrations_stripe_installation { nil }
  end
end
