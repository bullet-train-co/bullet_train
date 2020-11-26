json.extract! oauth_stripe_account,
  :id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url oauth_stripe_account_url(oauth_stripe_account, format: :json)
