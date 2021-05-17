class AddApplicationIdToOauthAccessGrants < ActiveRecord::Migration[6.1]
  def change
    add_column :oauth_access_grants, :application_id, :bigint
  end
end
