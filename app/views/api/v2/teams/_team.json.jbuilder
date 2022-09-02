json.extract! team,
  :id,
  :name,
  :time_zone,
  :locale,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_team_url(team, format: :json)
