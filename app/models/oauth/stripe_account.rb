class Oauth::StripeAccount < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :user, optional: true
  has_many :webhooks_incoming_stripe_webhooks, class_name: "Webhooks::Incoming::StripeWebhook",
                                               foreign_key: "oauth_stripe_account_id"

  validates :uid, presence: true

  def label_string
    name
  end

  def name
    data["info"]["name"]
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
    # consider using transactions here. if an error occurs in the processing of a webhook, it's not like user-facing
    # errors on the web where they see a red screen of death. instead, sidekiq will reattempt the processing of the
    # entire webhook, which means that earlier portions of your logic will be run more than once unless you're careful
    # to avoid it.
  end
end
