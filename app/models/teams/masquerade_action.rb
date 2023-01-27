class Teams::MasqueradeAction < ApplicationRecord
  include Actions::TargetsOne
  include Actions::TracksCreator
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :created_by, class_name: "User"
  belongs_to :approve_by, class_name: "User", optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :membership, foreign_key: :teams_masquerade_action_id
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def targeted
    team
  end

  def label_string
    created_by.name
  end

  def calculate_target_count
    1
  end

  def perform_on_target(team)
    team.memberships.create(user: created_by, role_ids: [:admin], teams_masquerade_action: self)
  end

  def valid_created_bys
    User.developers
  end

  # 🚅 add methods above.
end
