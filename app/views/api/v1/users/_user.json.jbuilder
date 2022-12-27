json.extract! user,
  :id,
  :email,
  :first_name,
  :last_name,
  :time_zone,
  :locale,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at

# Needed by OAuth2 clients like Zapier so they know which team an installation was on.
if user.platform_agent_of
  json.team_id user.teams.first.id
  json.team_name user.teams.first.name
end
