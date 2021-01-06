class Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :creative_concept
  belongs_to :membership
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  scope :with_role, -> (role) { where("roles @> ?", role.to_json) }
  scope :admins, -> { with_role(:admin) }
  scope :editors, -> { with_role(:editor) }
  scope :viewers, -> { where("roles = ?", [].to_json) }
  # 🚅 add scopes above.

  validates :membership_id, presence: true
  validate :validate_membership
  validate :validate_roles
  # 🚅 add validations above.

  after_save :invalidate_caches
  after_destroy :invalidate_caches
  # 🚅 add callbacks above.

  delegate :team, to: :creative_concept
  delegate :invalidate_caches, to: :team
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

  def valid_roles
    I18n.t('scaffolding/absolutely_abstract/creative_concepts/collaborators.fields.roles.options').keys.map(&:to_s)
  end

  def validate_roles
    if (roles.map(&:to_s) - valid_roles).any?
      errors.add(:roles, :invalid)
    end
  end

  # 🚅 add methods above.
end
