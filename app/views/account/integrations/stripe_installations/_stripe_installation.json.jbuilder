json.extract! stripe_installation,
  :id,
  :team_id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_integrations_stripe_installation_url(stripe_installation, format: :json)
