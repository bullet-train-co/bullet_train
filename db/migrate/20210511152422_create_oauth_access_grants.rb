class CreateOauthAccessGrants < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_access_grants do |t|
      t.timestamps
    end
  end
end
