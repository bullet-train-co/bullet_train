class Api::V1::Integrations::StripeInstallationSerializer < ActiveModel::Serializer
  attributes :id,
    :team_id,
    :name,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at
end
