class Api::V1::TeamSerializer < Api::V1::ApplicationSerializer
  set_type "team"

  attributes :id,
    :name,
    :time_zone,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  has_many :scaffolding_absolutely_abstract_creative_concepts, serializer: Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptSerializer
end
