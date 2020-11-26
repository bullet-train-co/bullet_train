json.extract! endpoint,
  :id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_webhooks_outgoing_endpoint_url(endpoint, format: :json)
