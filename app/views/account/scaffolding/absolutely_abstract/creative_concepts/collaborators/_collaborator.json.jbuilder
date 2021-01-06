json.extract! collaborator,
  :id,
  :creative_concept_id,
  :membership_id,
  :roles,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_scaffolding_absolutely_abstract_creative_concepts_collaborator_url(collaborator, format: :json)
