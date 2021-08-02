json.extract! delivery,
  :id,
  :endpoint_id,
  :event_id,
  :endpoint_url,
  :delivered_at,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_webhooks_outgoing_delivery_url(delivery, format: :json)
