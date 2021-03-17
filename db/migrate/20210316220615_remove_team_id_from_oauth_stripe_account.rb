class RemoveTeamIdFromOauthStripeAccount < ActiveRecord::Migration[6.1]
  def change
    remove_reference :oauth_stripe_accounts, :team, null: false, foreign_key: true
  end
end
