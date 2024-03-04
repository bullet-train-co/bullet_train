class Job < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :department
  belongs_to :quoted_by, class_name: "Membership", optional: true
  belongs_to :project_manager, class_name: "Membership", optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :department
  has_rich_text :description
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :quoted_by, scope: true
  validates :project_manager, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_quoted_bys
    # TODO - scope this to only users who do quotes
    team.memberships
  end

  def valid_project_managers
    # TODO - scope this to just project managers
    team.memberships
  end

  # 🚅 add methods above.
end
