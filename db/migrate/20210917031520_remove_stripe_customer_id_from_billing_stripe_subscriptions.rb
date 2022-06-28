class RemoveStripeCustomerIdFromBillingStripeSubscriptions < ActiveRecord::Migration[6.1]
  def change
    remove_column :billing_stripe_subscriptions, :stripe_customer_id, :string
  end
end
