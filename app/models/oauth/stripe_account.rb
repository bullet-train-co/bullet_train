class Oauth::StripeAccount < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :user, optional: true
  # 🚅 add belongs_to associations above.

  has_many :webhooks_incoming_oauth_stripe_account_webhooks, class_name: "Webhooks::Incoming::Oauth::StripeAccountWebhook", foreign_key: "oauth_stripe_account_id"
  has_many :integrations_stripe_installations, class_name: "Integrations::StripeInstallation", foreign_key: "oauth_stripe_account_id"
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :uid, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def label_string
    name
  end

  # TODO You should update this with an implementation appropriate for the provider you're integrating with.
  # This must return _something_, otherwise new installations won't save.
  def name
    data.dig("info", "name").presence || "Stripe Account"
  rescue
    "Stripe Account"
  end

  def name_was
    name
  end

  def update_from_oauth(auth)
    self.uid = auth.uid
    self.data = auth
    save
  end

  # webhooks received for this account will be routed here asynchronously for processing on a worker.
  def process_webhook(webhook)
    # we delegate processing to any active installations.
    integrations_stripe_installations.order(:id).each do |installation|
      installation.process_webhook(webhook)
    end
  end

  # 🚅 add methods above.
end
