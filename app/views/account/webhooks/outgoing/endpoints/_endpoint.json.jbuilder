json.extract! endpoint,
  :id,
  :team_id,
  :name,
  :url,
  :event_type_ids,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_webhooks_outgoing_endpoint_url(endpoint, format: :json)
