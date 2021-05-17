FactoryBot.define do
  factory :doorkeeper_application, class: "Doorkeeper::Application" do
    team
    sequence(:name) { |n| "OAuth App #{n}" }
    scopes { "read write delete" }
    redirect_uri { "" }
  end
end
