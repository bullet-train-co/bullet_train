# Integrating Stripe to Enable Pricing Page and Subscriptions

1. Get your *test-mode* Stripe API keys at [https://dashboard.stripe.com/account/apikeys](https://dashboard.stripe.com/account/apikeys) and configure them as `STRIPE_PUBLISHABLE_KEY` and `STRIPE_SECRET_KEY` in your environment. I do this by creating a `config/application.yml` file (which will be ignored by Git) and populating it like so:

```
STRIPE_PUBLISHABLE_KEY: pk_0CJwz5wHlKBXxPA4DOOuEoipxQob0
STRIPE_SECRET_KEY: sk_0CJw2Iu5wwIKHUDdrphrtGzFZyOCH
```

(The keys above are just an example and actually not valid for use.)

## Plans

By default, Bullet Train applications come configured with four plans, offering a "Basic" and "Pro" product with "Monthly" and "Annual" pricing options and there are two separate pricing tables for displaying the "Monthly" and "Annual" options. Obviously your own product's pricing structure might vary substantially from this, but having these as a baseline helps streamline testing.

2. Run `rake bullet_train:setup:populate_stripe_products` to push the default products and prices over to Stripe. This script will output some environment values you'll need to copy into `config/application.yml`.

3. Run `rake db:seed` to create corresponding plans and pricing tables for your application.

4. Run `rails restart` to ensure the new Stripe configuration takes effect.

You can now refresh the homepage and test your pricing page by clicking on the "Pricing" link on the homepage, and proceed to sign up. In test mode, you can use "4242424242424242" as a credit card number to get past the payment page.
