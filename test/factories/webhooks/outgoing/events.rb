FactoryBot.define do
  factory :webhooks_outgoing_event, class: "Webhooks::Outgoing::Event" do
    event_type_id { "scaffolding/absolutely_abstract/creative_concept.created" }
    association :subject, factory: :scaffolding_absolutely_abstract_creative_concept
    association :team, factory: :team
    uuid { SecureRandom.hex }
    api_version { BulletTrain::Api.current_version_numeric }
    after(:initialize) do |event|
      event.data = {}
    end

    factory :webhooks_outgoing_event_example do
      id { 42 }
      subject_id { 42 }
      team_id { 42 }
      created_at { DateTime.new(2023, 1, 1) }
      updated_at { DateTime.new(2023, 1, 2) }
      data {
        {id: 42,
         created_at: DateTime.new(2023, 1, 1).utc,
         updated_at: DateTime.new(2023, 1, 2).utc,
         value: "one"}.to_json
      }
    end
  end
end
