class AddStatusToBillingSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :billing_subscriptions, :status, :string, default: "initiated"
  end
end
