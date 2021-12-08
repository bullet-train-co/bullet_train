class Scaffolding::CompletelyConcrete::TangibleThings::Assignment < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :tangible_thing, class_name: "Scaffolding::CompletelyConcrete::TangibleThing"
  belongs_to :membership, class_name: "Membership"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :tangible_thing
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
