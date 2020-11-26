class Scaffolding::CompletelyConcrete::TangibleThing < ApplicationRecord
  include Sprinkles::Sortable
  # 🚅 add concerns above.

  belongs_to :absolutely_abstract_creative_concept, class_name: 'Scaffolding::AbsolutelyAbstract::CreativeConcept'
  # 🚅 add belongs_to associations above.

  has_many :assignments, class_name: 'Scaffolding::CompletelyConcrete::TangibleThings::Assignment', dependent: :destroy
  has_many :memberships, through: :assignments
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  delegate :team, to: :absolutely_abstract_creative_concept
  # 🚅 add delegations above.

  def collection
    absolutely_abstract_creative_concept.completely_concrete_tangible_things
  end

  # 🚅 add methods above.
end
