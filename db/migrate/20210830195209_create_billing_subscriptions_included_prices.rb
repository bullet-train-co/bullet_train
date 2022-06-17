class CreateBillingSubscriptionsIncludedPrices < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_subscriptions_included_prices do |t|
      t.references :subscription, null: false, foreign_key: {to_table: "billing_subscriptions"}
      t.string :price_id
      t.integer :quantity

      t.timestamps
    end
  end
end
