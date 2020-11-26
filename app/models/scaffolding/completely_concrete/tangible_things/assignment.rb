class Scaffolding::CompletelyConcrete::TangibleThings::Assignment < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :tangible_thing
  belongs_to :membership
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :membership, through: :membership
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  delegate :team, to: :tangible_thing
  # 🚅 add delegations above.

  # 🚅 add methods above.
end
