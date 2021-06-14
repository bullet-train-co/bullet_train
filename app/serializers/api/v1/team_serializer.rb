class Api::V1::TeamSerializer < Api::V1::ApplicationSerializer
  set_type "team"

  # TODO The commented attributes currently break our JSON:API schema validation.
  attributes :name,
    :time_zone,
    # 🚅 super scaffolding will insert new fields above this line.
    # TODO This should be the first attribute defined, but we have to do this until the JSON:API + date thing is fixed.
    :id
  # :created_at,
  # :updated_at

  has_many :scaffolding_absolutely_abstract_creative_concepts, serializer: Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptSerializer
end
