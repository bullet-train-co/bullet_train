class Scaffolding::AbsolutelyAbstract::CreativeConcept < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :completely_concrete_tangible_things, class_name: "Scaffolding::CompletelyConcrete::TangibleThing", foreign_key: :absolutely_abstract_creative_concept_id, dependent: :destroy
  has_many :collaborators, class_name: "Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator", dependent: :destroy, foreign_key: :creative_concept_id
  has_many :memberships, through: :collaborators
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def admins
    collaborators.admins.map(&:membership)
  end

  def editors
    collaborators.editors.map(&:membership)
  end

  def viewers
    collaborators.viewers.map(&:membership)
  end

  def all_collaborators
    team.admins.or(Membership.where(id: memberships.pluck(:id)))
  end

  # 🚅 add methods above.
end
