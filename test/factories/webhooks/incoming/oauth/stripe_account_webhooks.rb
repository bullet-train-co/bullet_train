FactoryBot.define do
  factory :webhooks_incoming_oauth_stripe_account_webhook, class: "Webhooks::Incoming::Oauth::StripeAccountWebhook" do
    data { "" }
    processed_at { "2019-03-30 12:58:23" }
    verified_at { "2019-03-30 12:58:23" }
    oauth_stripe_account { nil }
  end
end
