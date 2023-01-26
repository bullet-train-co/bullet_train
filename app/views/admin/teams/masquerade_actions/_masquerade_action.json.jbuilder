json.extract! masquerade_action,
  :id,
  :team_id,
  :target_count,
  :performed_count,
  :created_by,
  :approved_by,
  :scheduled_for,
  :started_at,
  :completed_at,
  :delay,
  :emoji,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url admin_teams_masquerade_action_url(masquerade_action, format: :json)
