class Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptSerializer < Api::V1::ApplicationSerializer
  set_type "scaffolding/absolutely_abstract/creative_concept"

  attributes :id,
    :team_id,
    :name,
    :description,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
  has_many :completely_concrete_tangible_things, serializer: Api::V1::Scaffolding::CompletelyConcrete::TangibleThingSerializer
end
