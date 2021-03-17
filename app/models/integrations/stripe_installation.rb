class Integrations::StripeInstallation < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :team
  belongs_to :oauth_stripe_account, class_name: "Oauth::StripeAccount"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def process_webhook(webhook)
    # consider using transactions here. if an error occurs in the processing of a webhook, it's not like user-facing
    # errors on the web where they see a red screen of death. instead, sidekiq will reattempt the processing of the
    # entire webhook, which means that earlier portions of your logic will be run more than once unless you're careful
    # to avoid it.
  end

  # 🚅 add methods above.
end
