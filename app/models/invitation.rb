class Invitation < ApplicationRecord
  # 🚫 DEFAULT BULLET TRAIN INVITATION FUNCTIONALITY
  # Typically you should avoid adding your own functionality in this section to avoid merge conflicts in the future.
  # (If you specifically want to change Bullet Train's default behavior, that's OK and you can do that here.)

  belongs_to :team
  belongs_to :from_membership, class_name: "Membership"
  has_one :membership, dependent: :nullify
  has_many :roles, through: :membership

  accepts_nested_attributes_for :membership

  validates :email, presence: true

  before_create :generate_uuid
  after_create :set_added_by_membership
  after_create :send_invitation_email

  # ✅ YOUR APPLICATION'S INVITATION FUNCTIONALITY
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

  # 🚫 DEFAULT BULLET TRAIN INVITATION FUNCTIONALITY
  # We put these at the bottom of this file to keep them out of the way. You should define your own methods above here.

  def set_added_by_membership
    membership.update(added_by: from_membership)
  end

  def send_invitation_email
    UserMailer.invited(uuid).deliver_later
  end

  def generate_uuid
    self.uuid = SecureRandom.hex
  end

  def accept_for(user)
    User.transaction do
      user.memberships << membership
      user.update(current_team: team, former_user: false)
      destroy
    end
  end

  def name
    I18n.t("invitations.values.name", team_name: team.name)
  end

  def is_for?(user)
    user.email.downcase.strip == email.downcase.strip
  end
end
