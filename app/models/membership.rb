class Membership < ApplicationRecord
  # 🚫 DEFAULT BULLET TRAIN MEMBERSHIP FUNCTIONALITY
  # Typically you should avoid adding your own functionality in this section to avoid merge conflicts in the future.
  # (If you specifically want to change Bullet Train's default behavior, that's OK and you can do that here.)

  include Sprinkles::Broadcasted

  belongs_to :user, optional: true
  belongs_to :team
  belongs_to :invitation, optional: true, dependent: :destroy
  belongs_to :added_by, class_name: "Membership", optional: true
  has_many :membership_roles, dependent: :destroy
  has_many :roles, through: :membership_roles

  has_many :scaffolding_completely_concrete_tangible_things_assignments, class_name: "Scaffolding::CompletelyConcrete::TangibleThings::Assignment", dependent: :destroy
  has_many :scaffolding_completely_concrete_tangible_things, through: :scaffolding_completely_concrete_tangible_things_assignments, source: :tangible_thing
  has_many :reassignments_scaffolding_completely_concrete_tangible_things_reassignments, class_name: "Memberships::Reassignments::ScaffoldingCompletelyConcreteTangibleThingsReassignment", dependent: :destroy, foreign_key: :membership_id

  has_many :scaffolding_absolutely_abstract_creative_concepts_collaborators, class_name: "Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator", dependent: :destroy

  after_save :invalidate_caches
  after_destroy :invalidate_caches

  after_destroy do
    # if we're destroying a user's membership to the team they have set as
    # current, then we need to remove that so they don't get an error.
    if user&.current_team == team
      user.current_team = nil
      user.save
    end
  end

  scope :current_and_invited, -> { includes(:invitation).where("user_id IS NOT NULL OR invitations.id IS NOT NULL").references(:invitation) }
  scope :current, -> { where("user_id IS NOT NULL") }
  scope :tombstones, -> { includes(:invitation).where("user_id IS NULL AND invitations.id IS NULL").references(:invitation) }

  # ✅ YOUR APPLICATION'S MEMBERSHIP FUNCTIONALITY
  # This is the place where you should implement your own features on top of Bullet Train's functionality. There
  # are a bunch of Super Scaffolding hooks here by default to try and help keep generated code logically organized.

  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.

  # 🚫 DEFAULT BULLET TRAIN TEAM FUNCTIONALITY
  # We put these at the bottom of this file to keep them out of the way. You should define your own methods above here.

  def invalidate_caches
    user&.invalidate_ability_cache
    team&.invalidate_caches
  end

  def name
    full_name
  end

  def label_string
    full_name
  end

  # we overload this method so that when setting the list of role ids
  # associated with a membership, admins can never remove the last admin
  # of a team.
  def role_ids=(ids)
    # if this membership was an admin, and the new list of role ids don't include admin.
    if admin? && !ids.include?(Role.admin.id)
      unless team.admins.count > 1
        raise RemovingLastTeamAdminException.new("You can't remove the last team admin.")
      end
    end

    super(ids)
  end

  def manageable_roles
    (Role.roles_managable_by_all + roles.map(&:manageable_roles)).flatten.uniq
  end

  def can_manage_role?(role)
    manageable_roles.include?(role)
  end

  def admin?
    roles.include?(Role.admin)
  end

  def unclaimed?
    user.nil? && !invitation.nil?
  end

  def tombstone?
    user.nil? && invitation.nil?
  end

  def last_admin?
    return false unless admin?
    return false unless user.present?
    team.memberships.current.select(&:admin?) == [self]
  end

  def nullify_user
    if last_admin?
      raise RemovingLastTeamAdminException.new("You can't remove the last team admin.")
    end

    if (user_was = user)
      unless user_first_name.present?
        self.user_first_name = user.first_name
      end

      unless user_last_name.present?
        self.user_last_name = user.last_name
      end

      unless user_profile_photo_id.present?
        self.user_profile_photo_id = user.profile_photo_id
      end

      unless user_email.present?
        self.user_email = user.email
      end

      self.user = nil
      save

      user_was.invalidate_ability_cache
      team.invalidate_caches

      user_was.update(
        current_team: user_was.teams.first,
        former_user: user_was.teams.empty?
      )
    end

    # we do this here just in case by some weird chance an active membership had an invitation attached.
    invitation&.destroy
  end

  def email
    user&.email || user_email.presence || invitation&.email
  end

  def full_name
    user&.full_name || [first_name.presence, last_name.presence].join(" ").presence || email
  end

  def first_name
    user&.first_name || user_first_name
  end

  def last_name
    user&.last_name || user_last_name
  end

  def last_initial
    return nil unless last_name.present?
    "#{last_name}."
  end

  def first_name_last_initial
    [first_name, last_initial].map(&:present?).join(" ")
  end

  # TODO utilize this.
  # members shouldn't receive notifications unless they are either an active user or an outstanding invitation.
  def should_receive_notifications?
    invitation.present? || user.present?
  end
end
