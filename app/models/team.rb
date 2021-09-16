class Team < ApplicationRecord
  # 🚫 DEFAULT BULLET TRAIN TEAM FUNCTIONALITY
  # Typically you should avoid adding your own functionality in this section to avoid merge conflicts in the future.
  # (If you specifically want to change Bullet Train's default behavior, that's OK and you can do that here.)

  # super scaffolding
  unless scaffolding_things_disabled?
    has_many :scaffolding_absolutely_abstract_creative_concepts, class_name: "Scaffolding::AbsolutelyAbstract::CreativeConcept", dependent: :destroy, broadcast: true
  end

  # webhooks
  has_many :webhooks_outgoing_endpoints, class_name: "Webhooks::Outgoing::Endpoint", dependent: :destroy
  has_many :webhooks_outgoing_events, class_name: "Webhooks::Outgoing::Event", dependent: :destroy

  # memberships and invitations
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :invitations

  # oauth for grape api
  has_many :doorkeeper_applications, class_name: "Doorkeeper::Application", dependent: :destroy, foreign_key: :team_id

  # integrations
  has_many :integrations_stripe_installations, class_name: "Integrations::StripeInstallation", dependent: :destroy if stripe_enabled?

  # validations
  validates :name, presence: true
  validates :time_zone, inclusion: {in: ActiveSupport::TimeZone.all.map(&:name)}, allow_nil: true

  before_destroy :mark_for_destruction, prepend: true

  # ✅ YOUR APPLICATION'S TEAM FUNCTIONALITY
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

  def admins
    memberships.current_and_invited.admins
  end

  def admin_users
    admins.map(&:user).compact
  end

  def primary_contact
    admin_users.min { |user| user.created_at }
  end

  def formatted_email_address
    primary_contact.email
  end

  def invalidate_caches
    users.map(&:invalidate_ability_cache)
  end

  def mark_for_destruction
    # this allows downstream logic to check whether a team is being destroyed in order to bypass webhook issuance and
    # bypass restrictions on removing the last admin.
    update_column(:being_destroyed, true)
  end

  def team
    # some generic features appeal to the `team` method for security or scoping purposes, but sometimes those same
    # generic functions need to function for a team model as well, so we do this.
    self
  end
end
