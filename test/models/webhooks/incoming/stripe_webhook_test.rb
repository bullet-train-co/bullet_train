require 'test_helper'

if defined?(BulletTrain::Billing::Stripe)

  puts Rails.configuration.factory_bot.definition_file_paths
  class Webhooks::Incoming::StripeWebhookTest < ActiveSupport::TestCase
    include ::FactoryBot::Syntax::Methods
    # TODO: Cut this down to just the attributes we need
    def customer_subscription_updated_data(created_at, stripe_subscription_id)
      {
        "id" => "evt_1NgIq2BiWqhbiHpFXvtRJZtY",
        "data" => {
          "object" => {
            "id" => stripe_subscription_id,
            "plan" => {
            },
            "items" => {
              "data" => [],
            },
            "object" => "subscription",
            "status" => "active",
            "created" => created_at.to_i,
            "cancel_at_period_end" => false,
            "cancellation_details" => {
              "reason" => nil, "comment" => nil, "feedback" => nil
            },
          }
        },
        "type" => "customer.subscription.updated",
        "object" => "event",
        "created" => created_at.to_i,
        "request" => {
          "id" => "req_xecKk5kzBB6YxH", "idempotency_key" => "4b0d30d5-4bbd-400b-87ae-f551e3be0748"
        },
        "livemode" => true,
        "api_version" => "2022-11-15",
        "pending_webhooks" => 2
      }
    end

    # TODO: Cut this down to just the attributes we need
    def customer_subscription_created_data(created_at, stripe_subscription_id)
      {
        "id" => "evt_1NgIq1BiWqhbiHpFTeqASYDz",
        "data" => {
          "object" => {
            "id" => stripe_subscription_id,
            "plan" => {
            },
            "items" => {
              "data" => [],
            },
            "object" => "subscription",
            "status" => "incomplete",
            "created" => created_at.to_i,
            "cancel_at_period_end" => false,
            "cancellation_details" => {
              "reason" => nil, "comment" => nil, "feedback" => nil
            },
          }
        },
        "type" => "customer.subscription.created",
        "object" => "event",
        "created" => created_at.to_i,
        "request" => {
          "id" => "req_xecKk5kzBB6YxH", "idempotency_key" => "4b0d30d5-4bbd-400b-87ae-f551e3be0748"
        },
        "livemode" => true,
        "api_version" => "2022-11-15",
        "pending_webhooks" => 2
      }
    end

    class SubscriptionValidOrderTests < Webhooks::Incoming::StripeWebhookTest
      def setup
        team = create :team
        stripe_subscription = create :billing_stripe_subscription, team: team
        @generic_subscription = create :billing_subscription, provider_subscription: stripe_subscription, status: nil
        #create :billing_subscriptions_included_price, subscription: @generic_subscription
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
        #create :billing_subscriptions_included_price, subscription: @generic_subscription
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
