class Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConcepts::CollaboratorSerializer < ActiveModel::Serializer
  attributes :id,
  :creative_concept_id,
  :membership_id,
  :roles,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
end
