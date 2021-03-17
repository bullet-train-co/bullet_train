class AddUidUniquenessToOauthStripeAccounts < ActiveRecord::Migration[6.1]
  def change
    add_index :oauth_stripe_accounts, :uid, unique: true
  end
end
