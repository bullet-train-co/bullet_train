FactoryBot.define do
  factory :platform_application, class: "Platform::Application" do
    team
    sequence(:name) { |n| "OAuth App #{n}" }
    scopes { "read write delete" }
    redirect_uri { "" }
  end
end
