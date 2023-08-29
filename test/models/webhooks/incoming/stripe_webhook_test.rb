require "test_helper"

if defined?(BulletTrain::Billing::Stripe)
  class Webhooks::Incoming::StripeWebhookTest < ActiveSupport::TestCase
    include ::FactoryBot::Syntax::Methods

    # This is a _very_ minimal representation of a webhook payload. It's just
    # enough for the purposes of these tests.
    def customer_subscription_updated_data(created_at, stripe_subscription_id)
      {
        "id" => "evt_1NgIq2BiWqhbiHpFXvtRJZtY",
        "data" => {
          "object" => {
            "id" => stripe_subscription_id,
            "items" => {"data" => []},
            "status" => "active",
            "created" => created_at.to_i,
          }
        },
        "type" => "customer.subscription.updated",
        "created" => created_at.to_i,
      }
    end

    # This is a _very_ minimal representation of a webhook payload. It's just
    # enough for the purposes of these tests.
    def customer_subscription_created_data(created_at, stripe_subscription_id)
      {
        "id" => "evt_1NgIq1BiWqhbiHpFTeqASYDz",
        "data" => {
          "object" => {
            "id" => stripe_subscription_id,
            "items" => {"data" => []},
            "status" => "incomplete",
            "created" => created_at.to_i,
          }
        },
        "type" => "customer.subscription.created",
        "created" => created_at.to_i,
      }
    end

    class SubscriptionValidOrderTests < Webhooks::Incoming::StripeWebhookTest
      def setup
        team = create :team
        stripe_subscription = create :billing_stripe_subscription, team: team
        @generic_subscription = create :billing_subscription, provider_subscription: stripe_subscription, status: nil
        @subscription_created_webhook = create :webhooks_incoming_stripe_webhook,
          data: customer_subscription_created_data(Time.now - 2.minutes, stripe_subscription.stripe_subscription_id)
        @subscription_updated_webhook = create :webhooks_incoming_stripe_webhook,
          data: customer_subscription_updated_data(Time.now - 1.minutes, stripe_subscription.stripe_subscription_id)
      end

      test "the subscription ends up as 'active'" do
        @subscription_created_webhook.process
        assert_equal "pending", @generic_subscription.reload.status
        @subscription_updated_webhook.process
        assert_equal "active", @generic_subscription.reload.status
      end
    end

    # Sometimes we recieve a subscription.updated webhook _before_ we recieve
    # the subscription.created webhook for the same subscription. In that case
    # we want to make sure that we don't erroneously set the subscription status
    # back to 'pending' becasue that's confusing for everyone especially customers.
    class SubscriptionInvalidOrderTests < Webhooks::Incoming::StripeWebhookTest
      def setup
        team = create :team
        stripe_subscription = create :billing_stripe_subscription, team: team
        @generic_subscription = create :billing_subscription, provider_subscription: stripe_subscription, status: nil
        @subscription_updated_webhook = create :webhooks_incoming_stripe_webhook,
          data: customer_subscription_updated_data(Time.now - 2.minutes, stripe_subscription.stripe_subscription_id)
        @subscription_created_webhook = create :webhooks_incoming_stripe_webhook,
          data: customer_subscription_created_data(Time.now - 1.minutes, stripe_subscription.stripe_subscription_id)
      end

      test "the subscription ends up as 'active'" do
        @subscription_updated_webhook.process
        assert_equal "active", @generic_subscription.reload.status
        @subscription_created_webhook.process
        assert_equal "active", @generic_subscription.reload.status
      end
    end
  end
end
