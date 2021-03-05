class Webhooks::Incoming::Oauth::StripeAccountWebhook < ApplicationRecord
  include Webhooks::Incoming::Webhook

  belongs_to :oauth_stripe_account, class_name: "Oauth::StripeAccount", optional: true

  def process
    # if this is a stripe connect webhook ..
    if data["account"]

      # if we're able to find an account in our system that this webhook should be routed to ..
      if self.oauth_stripe_account = Oauth::StripeAccount.find_by(uid: data["account"])

        # save the reference to the account.
        save

        # delegate processing to that account.
        oauth_stripe_account.process_webhook(self)

      end

      # if we didn't find an account for the webhook, they've probably deleted their account. we'll just ignore it for
      # now, but it's still in our database for debugging purposes. we'll probably want to send a request to stripe
      # in order to disconnect their account from our application so we stop receiving webhooks.

    else

      # it's possible we're receiving a general webhook that isn't specific to an account.
      # however, we want to know about these, so raise an error.
      raise "received a webhook we weren't expecting"

    end
  end
end
