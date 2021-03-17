class MigrateTeamConnectedOauthStripeAccounts < ActiveRecord::Migration[6.1]
  def up
    Oauth::StripeAccount.find_each do |oauth_stripe_account|
      if (team = oauth_stripe_account.team)
        team.integrations_stripe_installations.find_or_create_by(oauth_stripe_account: oauth_stripe_account)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
