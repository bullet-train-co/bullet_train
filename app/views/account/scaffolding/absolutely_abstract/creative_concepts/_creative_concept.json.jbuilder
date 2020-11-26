json.extract! creative_concept,
  :id,
  :name,
  :description,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_scaffolding_absolutely_abstract_creative_concept_url(creative_concept, format: :json)
