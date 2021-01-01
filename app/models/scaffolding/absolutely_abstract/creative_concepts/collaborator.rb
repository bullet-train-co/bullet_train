class Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :creative_concept
  belongs_to :membership
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validate :validate_membership
  validates :membership_id, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  delegate :team, to: :creative_concept
  # 🚅 add delegations above.

  def valid_memberships
    team.memberships.current_and_invited
  end

  def validate_membership
    if membership_id.present?
      # don't allow users to assign the ids of other teams' or users' resources to this attribute.
      unless valid_memberships.ids.include?(membership_id)
        errors.add(:membership_id, :invalid)
      end
    end
  end

  # 🚅 add methods above.

end
