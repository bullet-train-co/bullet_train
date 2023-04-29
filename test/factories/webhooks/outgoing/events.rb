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
      data {
        {id: 1,
         created_at: Time.now.utc,
         updated_at: Time.now.utc,
         value: "one"}.to_json
      }
    end
  end
end
