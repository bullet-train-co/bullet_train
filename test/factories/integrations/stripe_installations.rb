FactoryBot.define do
  factory :integrations_stripe_installation, class: "Integrations::StripeInstallation" do
    team { nil }
    oauth_stripe_account { nil }
    name { "MyString" }
  end
end
