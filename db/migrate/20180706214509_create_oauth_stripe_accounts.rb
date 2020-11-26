class CreateOauthStripeAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :oauth_stripe_accounts do |t|
      t.string :uid
      t.jsonb :data
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
