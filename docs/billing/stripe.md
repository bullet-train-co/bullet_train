# Enabling Stripe Subscriptions

Bullet Train provides a base billing package and a Stripe-specific package with support for Stripe Checkout, Stripe Billing's customer portal, and incoming Stripe webhooks.

## 1. Merge the Stripe Billing Branch

You can import both the base billing package and the Stripe package from one branch:

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

Edit `config/application.yml` and add your Stripe publishable key and new secret key to the file, and also tell the system to use Stripe subscriptions by default:

```
BILLING_DEFAULT_SUBSCRIPTION: "Billing::Stripe::Subscription"
STRIPE_PUBLISHABLE_KEY: pk_0CJwz5wHlKBXxDA4VO1uEoipxQob0
STRIPE_SECRET_KEY: sk_0CJw2Iu5wwIKXUDdqphrt2zFZyOCH
```

## 5. Populate Stripe with Locally Configured Products

Bullet Train defines subscription plans and other purchasable add-ons in `config/models/billing/products.yml` and comes preconfigured with some example plans. We recommend just getting started with these plans to ensure your setup is working before customizing the attributes of these plans.

Before you can use Stripe Checkout or Stripe Billing's customer portal, these products will have to be defined on Stripe as well. You can have all locally defined products automatically created on Stripe by running the following:

```
rake billing:stripe:populate_products_in_stripe
```

## 6. Import Additional Environment Variables

The script in the previous step will output some additional environment variables you need to copy into `config/application.yml`.

## 7. Restart Rails

We've modified a bunch of environment variables, so you'll have to have to restart your Rails server before you see the results in your browser.

```
rails restart
```

## 8. Test Creating a Subscription

Bullet Train comes preconfigured with a "freemium" plan, so new and existing accounts will continue to work as normal. A new "billing" menu item will appear and you can test subscription creation by clicking "upgrade" and selecting one of the two plans presented.

You should be in "test mode" on Stripe, so when prompted for a credit card number, you can enter `4242 4242 4242 4242`.

## 9. Configuring Webhooks

Basic subscription creation will work without receiving and processing Stripe's webhooks. However, advanced payment workflows like SCA payments and customer portal cancelations and plan changes require receiving webhooks and processing them.

 - Stripe can't deliver webhooks to `http://localhost:3000`, so you'll need to [get an HTTP tunnel up and running](/docs/tunneling.md). For this example, we'll assume you're using ngrok.
 - Visit https://dashboard.stripe.com/test/webhooks/create.
 - Configure the "endpoint URL" to be `https://your-tunnel.ngrok.io/webhooks/incoming/stripe_webhooks`, replacing `your-tunnel` with whatever the subdomain of your tunnel is.
 - When configuring which events to receive, just "select all events" for simplicity. This ensures that any webhooks Bullet Train might add support for in the future will be properly handled when you upgrade.
 - Add the endpoint.
 - On the page for the webhook endpoint you've just configured with Stripe, click on "reveal" under the heading "signing secret". This is a secret token that is required to authenticate that webhooks your application is receiving are actually coming from Stripe. Copy this into your `config/application.yml` like so:

 ```
 STRIPE_WEBHOOKS_ENDPOINT_SECRET: whsec_VsM3c2zeZyqAddkaPaXzf1wJsYp2fRKR
 ```

 - Restart your Rails server with `rails restart`.
 - Trigger a test webhook just to ensure it's resulting in an HTTP status code of 201.

## 10. Configure Stripe Billing's Customer Portal

  - Visit https://dashboard.stripe.com/test/settings/billing/portal.
  - Complete all required fields.
  - Be sure to add all of your actively available plans under "products".

This "products" list is what Stripe will display to users as upgrade and downgrade options in the customer portal. You shouldn't list any products here that aren't properly configured in your Rails app, otherwise the resulting webhook will fail to process. If you want to stop offering a plan, you should remove it from this list as well.

## 11. Test Webhooks by Managing a Subscription

In the same account where you created your first test subscription, go into the "billing" menu and click "manage" on that subscription. This will take you to the Stripe Billing customer portal.

Once you're in the customer portal, you should test upgrading, downgrading, and canceling your subscription and clicking "⬅ Return to {Your Application Name}" in between each step to ensure that each change you're making is properly reflected in your Bullet Train application. This will let you know that webhooks are being properly delivered and processed and all the products in both systems are properly mapped in both directions.
