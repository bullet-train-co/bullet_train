class Scaffolding::CompletelyConcrete::TangibleThing < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :absolutely_abstract_creative_concept, class_name: "Scaffolding::AbsolutelyAbstract::CreativeConcept"
  # 🚅 add belongs_to associations above.

  has_many :assignments, class_name: "Scaffolding::CompletelyConcrete::TangibleThings::Assignment", dependent: :destroy
  has_many :memberships, through: :assignments
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  has_one_attached :file_field_value
  has_one :team, through: :absolutely_abstract_creative_concept
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :text_field_value, presence: true
  # 🚅 add validations above.

  after_validation :remove_file_field_value, if: :file_field_value_removal?
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  has_rich_text :action_text_value
  attr_accessor :file_field_value_removal

  def collection
    absolutely_abstract_creative_concept.completely_concrete_tangible_things
  end

  def file_field_value_removal?
    file_field_value_removal.present?
  end

  def remove_file_field_value
    file_field_value.purge
  end
  # 🚅 add methods above.
end
