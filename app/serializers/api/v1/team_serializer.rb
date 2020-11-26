class Api::V1::TeamSerializer < ActiveModel::Serializer
  attributes :id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
end
