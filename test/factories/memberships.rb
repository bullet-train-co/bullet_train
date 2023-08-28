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
      # TODO: If we try to generate an `added_by` relationship in the factory we get stuck in an
      # infinite loop that eventually results in the following error:
      # Minitest::UnexpectedError: SystemStackError: stack level too deep
      #
      # Is there some way we can hadle this in the factory?
      # And/or do we _need_ to? Maybe we can just remove this?
      # Note: This used to incorrectly generate a :user instead of a :membership, but
      # added_by_id is indexed to the `memberships` table, so generating a :user is not valid.
      #
      # added_by_id { FactoryBot.example(:membership).id }
      platform_agent_of_id { nil }
      platform_agent { false }
      role_ids { ["admin"] }
    end
  end
end
