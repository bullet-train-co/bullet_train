require 'bcrypt'

class ApiKey < ApplicationRecord

  # 🚫 DEFAULT BULLET TRAIN API KEY FUNCTIONALITY
  # Typically you should avoid adding your own functionality in this section to avoid merge conflicts in the future.
  # (If you specifically want to change Bullet Train's default behavior, that's OK and you can do that here.)

  belongs_to :user

  scope :active, -> { where(revoked_at: nil).not(encrypted_secret: nil) }

  before_create do
    self.token = "p" + SecureRandom.hex
    self.last_used_at = nil
  end

  def generate_encrypted_secret(supplied_secret = nil)
    raise 'secret is already set' if encrypted_secret.present?
    supplied_secret ||= "s" + SecureRandom.hex
    update(encrypted_secret: BCrypt::Password.create(supplied_secret, cost: Devise.stretches))
    return supplied_secret
  end

  def self.find_by_credentials(token, secret)
    api_key = find_by(token: token)
    api_key&.valid_secret?(secret) ? api_key : nil
  end

  def valid_secret?(supplied_secret)
    BCrypt::Password.new(encrypted_secret) == supplied_secret
  end


  # ✅ YOUR APPLICATION'S API KEY FUNCTIONALITY
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


  # 🚫 DEFAULT BULLET TRAIN API KEY FUNCTIONALITY
  # We put these at the bottom of this file to keep them out of the way. You should define your own methods above here.

  def name
    token
  end

  def revoke
    self.revoked_at = Time.zone.now
    save
  end
end
