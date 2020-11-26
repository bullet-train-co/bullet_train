json.extract! api_key,
  :id,
  :token,
  :secret,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url api_key_url(api_key, format: :json)
