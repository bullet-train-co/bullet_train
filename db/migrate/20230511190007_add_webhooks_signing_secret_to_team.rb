class AddWebhooksSigningSecretToTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :webhooks_signing_secret, :string
  end
end
