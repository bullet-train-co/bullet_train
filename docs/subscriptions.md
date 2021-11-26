# Integrating Stripe to Enable Pricing Page and Subscriptions

## 1. Merge the Stripe Billing Mixin

```
git merge bullet-train/features/billing-stripe
```

## 2. Migrate the Database

```
rake db:migrate
```

## 3. Create API Keys with Stripe

 - Create a Stripe account if you don't already have one.
 - Visit https://dashboard.stripe.com/apikeys.
 - For your development environment, make sure you toggle the "test mode" flag to "on" in the top-right corner.
 - Create a new secret key.

## 4. Configure Stripe API Keys Locally

Edit `config/application.yml` and add your Stripe publishable key and new secret key to the file like so:

```
STRIPE_PUBLISHABLE_KEY: pk_0CJwz5wHlKBXxDA4VO1uEoipxQob0
STRIPE_SECRET_KEY: sk_0CJw2Iu5wwIKXUDdqphrt2zFZyOCH
```

## 5. Populate Stripe with Locally Configured Products

Bullet Train defines subscription plans and other purchasable add-ons in `config/models/billing/products.yml` and comes preconfigured with some example plans. We recommend just getting started with these plans to ensure your setup is working before customizing the attributes of these plans.

Before you can use Stripe Checkout or Stripe Billing's customer portal, these products will have to be defined on Stripe as well. You can have all locally defined products automatically created on Stripe by running the following:

```
rake billing:stripe:populate_products_in_stripe
```

That script will output some environment variables you need to copy into `config/application.yml`.

## 6. Restart Rails

We've modified a bunch of environment variables, so you'll have to have to restart your Rails server before you see the results in your browser.

```
rails restart
```

### 7. Test Creating a Subscription

Bullet Train comes preconfigured with a "freemium" plan, so new and existing accounts will continue to work as normal. A new "Billing" menu item will appear and you can test subscription creation by clicking "Upgrade" and selecting one of the two plans presented.

You should be in "test mode" on Stripe, so when prompted for a credit card number, you can enter `4242 4242 4242 4242`.
