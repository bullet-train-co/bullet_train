class Api::V1::Webhooks::Outgoing::EndpointSerializer < Api::V1::ApplicationSerializer
  set_type "webhooks/outgoing/endpoint"

  attributes :id,
    :team_id,
    :name,
    :url,
    :event_type_ids,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
