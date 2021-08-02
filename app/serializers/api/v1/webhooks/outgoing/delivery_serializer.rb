class Api::V1::Webhooks::Outgoing::DeliverySerializer < Api::V1::ApplicationSerializer
  set_type "webhooks/outgoing/delivery"

  attributes :id,
    :endpoint_id,
    :event_id,
    :endpoint_url,
    :delivered_at,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :endpoint, serializer: Api::V1::Webhooks::Outgoing::EndpointSerializer
end
