json.extract! application,
  :id,
  :team_id,
  :name,
  :scopes,
  :redirect_uri,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_platform_application_url(application, format: :json)
