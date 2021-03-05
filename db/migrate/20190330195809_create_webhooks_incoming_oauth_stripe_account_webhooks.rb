class CreateWebhooksIncomingOauthStripeAccountWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks_incoming_oauth_stripe_account_webhooks do |t|
      t.jsonb :data
      t.datetime :processed_at
      t.datetime :verified_at
      t.references :oauth_stripe_account, optional: true, index: {name: "index_stripe_webhooks_on_stripe_account_id"}

      t.timestamps
    end
  end
end
