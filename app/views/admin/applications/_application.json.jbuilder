json.extract! application,
  :id,
  :name,
  :time_zone,
  :locale,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url admin_application_url(application, format: :json)
