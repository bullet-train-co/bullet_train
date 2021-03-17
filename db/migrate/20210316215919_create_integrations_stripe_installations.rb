class CreateIntegrationsStripeInstallations < ActiveRecord::Migration[6.1]
  def change
    create_table :integrations_stripe_installations do |t|
      t.references :team, null: false, foreign_key: true
      t.references :oauth_stripe_account, null: false, foreign_key: true, index: {name: "index_stripe_installations_on_stripe_account_id"}
      t.string :name

      t.timestamps
    end
  end
end
