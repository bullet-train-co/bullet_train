class DropOauthAccessGrants < ActiveRecord::Migration[6.1]
  def up
    drop_table :oauth_access_grants
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
