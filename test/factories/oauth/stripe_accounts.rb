FactoryBot.define do
  factory :oauth_stripe_account, class: "Oauth::StripeAccount" do
    uid { "MyString" }
    data { "" }
    team { nil }
    user { nil }
  end
end
