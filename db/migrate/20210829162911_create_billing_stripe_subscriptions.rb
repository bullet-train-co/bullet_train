class CreateBillingStripeSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_stripe_subscriptions do |t|
      t.references :team, null: false, foreign_key: true
      t.string :stripe_customer_id
      t.string :stripe_subscription_id

      t.timestamps
    end
  end
end
