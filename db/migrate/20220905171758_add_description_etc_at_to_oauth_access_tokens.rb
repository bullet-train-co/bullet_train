class AddDescriptionEtcAtToOauthAccessTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :oauth_access_tokens, :description, :string
    add_column :oauth_access_tokens, :last_used_at, :datetime
    add_column :oauth_access_tokens, :provisioned, :boolean, default: false
  end
end
