FactoryBot.define do
  factory :membership do
    association :user
    association :team

    factory :membership_example do
      id { 42 }
      team { FactoryBot.example(:team) }
      user { FactoryBot.example(:user, teams: [team]) }
      invitation_id { nil }
      user_first_name { user.first_name }
      user_last_name { user.last_name }
      user_profile_photo_id { 1 }
      user_email { user.email }
      platform_agent_of_id { nil }
      platform_agent { false }
      role_ids { ["admin"] }
      created_at { DateTime.new(2023, 1, 1) }
      updated_at { DateTime.new(2023, 1, 2) }

      # The `added_by` attribute is an optional foreign_key which points
      # to another membership and is automatically populated when someone
      # on a team invites another person. We do not give it a value here
      # in the factory because it will cause an infinite loop. If you
      # want to populate this value for a Membership in your tests, you
      # can do so by creating a Membership and passing it to an :invitation factory:
      #
      # # (Where `test_team`, `issuer_email`, and `receiver_email` are all custom values)
      # invitation_issuer_membership = Membership.new(team: test_team, user_email: issuer_email)
      # invitation_receiver_membership = Membership.new(team: test_team, user_email: receiver_email)
      # create :invitation, team: test_team, from_membership: invitation_issuer_membership, email: receiver_email, membership: invitation_receiver_membership
      #
      # This will automatically populate the `added_by` attribute for `invitation_receiver_membership`.
      added_by_id { nil }
    end
  end
end
