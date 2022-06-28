class CreateBillingExternalSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_external_subscriptions do |t|
      t.references :team, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
