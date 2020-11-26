json.extract! invitation,
  :id,
  :email,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_invitation_url(invitation, format: :json)
