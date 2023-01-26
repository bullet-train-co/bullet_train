FactoryBot.define do
  factory :teams_masquerade_action, class: "Teams::MasqueradeAction" do
    association :team, factory: :team
    emoji { "MyString" }
    scheduled_for { "2021-08-31 20:37:40" }
    started_at { "2021-08-31 20:37:40" }
    completed_at { "2021-08-31 20:37:40" }
    # This is really important, otherwise you'll introduce a `delay` into your test suite.
    delay { 0 }
  end
end
