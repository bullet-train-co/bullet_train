class CreateBillingSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_subscriptions do |t|
      t.references :team, null: false, foreign_key: true
      t.references :provider_subscription, polymorphic: true, null: false
      t.datetime :cycle_ends_at

      t.timestamps
    end
  end
end
