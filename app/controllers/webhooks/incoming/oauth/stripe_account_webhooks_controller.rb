class Webhooks::Incoming::Oauth::StripeAccountWebhooksController < Webhooks::Incoming::WebhooksController
  def create
    # we have to validate stripe webhooks based on the text content of their payload,
    # so we have to do it before we convert it to json in the database.
    payload = request.body.read

    # this throws an exception if the signature is invalid.
    Stripe::Webhook.construct_event(
      payload,
      request.env["HTTP_STRIPE_SIGNATURE"],
      ENV["STRIPE_WEBHOOKS_ACCOUNTS_ENDPOINT_SECRET"]
    )

    Webhooks::Incoming::Oauth::StripeAccountWebhook.create(
      data: JSON.parse(payload),
      # we can mark this webhook as verified because we authenticated it earlier in this controller.
      verified_at: Time.zone.now
    ).process_async

    render json: {status: "OK"}, status: :created
  end
end
