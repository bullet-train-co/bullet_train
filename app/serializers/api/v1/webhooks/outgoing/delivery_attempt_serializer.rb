class Api::V1::Webhooks::Outgoing::DeliveryAttemptSerializer < Api::V1::ApplicationSerializer
  set_type "webhooks/outgoing/delivery_attempt"

  attributes :id,
    :delivery_id,
    :response_code,
    :response_body,
    :response_message,
    :error_message,
    :attempt_number,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :delivery, serializer: Api::V1::Webhooks::Outgoing::DeliverySerializer
end
