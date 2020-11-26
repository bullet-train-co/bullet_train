class Webhooks::Incoming::StripeWebhook < ApplicationRecord
  include Webhooks::Incoming::Webhook

  def process
    # what do we want to do with this webhook?
  end
end
