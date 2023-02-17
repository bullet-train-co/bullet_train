FactoryBot.define do
  factory :platform_access_token, class: "Platform::AccessToken" do
    association :application, factory: :platform_application
    sequence(:description) { |n| "Token #{n}" }
    provisioned { true }
  end
end
