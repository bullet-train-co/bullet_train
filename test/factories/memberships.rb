FactoryBot.define do
  factory :membership do
    association :user
    association :team

    factory :membership_example do
      team { FactoryBot.example(:team) }
      user { FactoryBot.example(:user, teams: [team]) }
      invitation_id { nil }
      user_first_name { user.first_name }
      user_last_name { user.last_name }
      user_profile_photo_id { 1 }
      user_email { user.email }
      added_by_id { FactoryBot.example(:user).id }
      platform_agent_of_id { nil }
      platform_agent { false }
      role_ids { ["admin"] }
    end
  end
end
