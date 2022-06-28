if defined?(Stripe)
  Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
end
